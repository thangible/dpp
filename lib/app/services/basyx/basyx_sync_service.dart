import 'package:dpp/app/data_model/api/base_aas_model.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/data_model/material/material.dart' as model;
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/services/test/material_service.dart';
import 'package:dpp/app/services/test/product_service.dart';
import 'basyx_config.dart';
import 'basyx_local_cache.dart';
import 'basyx_mock_repository.dart';
import 'basyx_models.dart';
import 'basyx_remote_repository.dart';
import 'basyx_repository.dart';

/// The "every time we open the app" half of the integration: ask the
/// server (or, with [BasyxConfig.useMockData], the mock standing in for
/// one) what shells exist, download whatever's new, and fold the result
/// into [ProductService]/[MaterialService] — the same catalog Home search,
/// History, and the detail screens already read from, so a synced product
/// shows up exactly like any bundled mock product without the rest of the
/// app needing to know where it came from.
///
/// If the sync fails outright (server down, no network), it falls back to
/// whatever was cached from the last successful run rather than leaving
/// the app with nothing — see [BasyxLocalCache].
class BasyxSyncService {
  BasyxSyncService({BasyxRepository? repository, BasyxLocalCache? cache})
    : _repository = repository ?? _defaultRepository(),
      _cache = cache ?? BasyxLocalCache();

  static BasyxRepository _defaultRepository() =>
      BasyxConfig.useMockData ? BasyxMockRepository() : BasyxRemoteRepository();

  final BasyxRepository _repository;
  final BasyxLocalCache _cache;

  /// Never lets an exception escape: this runs during app startup (see
  /// main.dart), and a sync going wrong — server down, a malformed mock
  /// asset, no local filesystem on this platform — must never be the
  /// reason the app fails to open. Worst case it just registers nothing
  /// new this launch, same as before BaSyx existed.
  Future<void> syncOnAppStart() async {
    try {
      final shells = await _repository.fetchShellList();
      await _cache.saveShellList(shells);
      for (final shell in shells) {
        await _syncShell(shell);
      }
    } catch (e) {
      // A failed sync (server unreachable, mock asset missing, ...)
      // shouldn't block the app from starting — fall back to whatever the
      // last successful sync already put in the local cache.
      // ignore: avoid_print
      print('BasyxSyncService: sync failed ($e), using local cache only');
      try {
        await _registerFromCacheOnly();
      } catch (e2) {
        // ignore: avoid_print
        print('BasyxSyncService: local cache fallback also failed ($e2)');
      }
    }
  }

  Future<void> _syncShell(ShellDescriptor shell) async {
    final downloadedAt = await _cache.packageDownloadedAt(shell.id);
    final isFresh =
        downloadedAt != null &&
        DateTime.now().difference(downloadedAt) < BasyxConfig.cacheTtl;

    Map<String, dynamic> packageJson;
    String? imagePath = await _cache.thumbnailPath(shell.id);

    if (isFresh) {
      packageJson = (await _cache.loadPackage(shell.id))!;
    } else {
      final package = await _repository.fetchShellPackage(shell);
      packageJson = package.toJson();
      await _cache.savePackage(shell.id, packageJson);

      final thumbnailBytes = await _repository.fetchThumbnail(shell);
      if (thumbnailBytes != null) {
        imagePath = await _cache.saveThumbnail(shell.id, thumbnailBytes);
      }
    }

    _registerPackage(AasResponse.fromJson(packageJson), imagePath);
  }

  Future<void> _registerFromCacheOnly() async {
    final shells = await _cache.loadShellList();
    for (final shell in shells) {
      final packageJson = await _cache.loadPackage(shell.id);
      if (packageJson == null) continue;
      final imagePath = await _cache.thumbnailPath(shell.id);
      _registerPackage(AasResponse.fromJson(packageJson), imagePath);
    }
  }

  void _registerPackage(AasResponse aasResponse, String? imagePath) {
    final material = _materialFromDinSpec91481(aasResponse);
    if (material != null) {
      MaterialService.registerMaterial(material);
    }

    final product = Product.fromJson(
      aasResponse,
      resolvedImagePath: imagePath,
      resolvedMaterialId: material?.id,
    );
    if (product.id.isNotEmpty) {
      ProductService.registerProduct(product);
    }
  }

  /// Builds a [model.Material] from a "MaterialData_DINSPEC91481" submodel
  /// if the package has one (plus a "Temperaturen" submodel, if present,
  /// for the processing-condition fields) — the same convention-driven,
  /// idShort-based mapping [Product.fromJson] uses for its own fields, just
  /// living here since deciding *whether* an AAS package's material data is
  /// rich enough to deserve its own catalog entry is a sync-layer call, not
  /// something the plain data model should hardcode.
  model.Material? _materialFromDinSpec91481(AasResponse aasResponse) {
    final submodels = aasResponse.submodels ?? const <Submodel>[];
    Submodel? materialData;
    Submodel? temperatures;
    for (final sm in submodels) {
      if (sm.idShort == 'MaterialData_DINSPEC91481') materialData = sm;
      if (sm.idShort == 'Temperaturen') temperatures = sm;
    }
    if (materialData == null) return null;

    String? field(String idShort) {
      for (final element in materialData!.submodelElements ?? const []) {
        if (element.idShort == idShort && element is Property) {
          return element.value?.toString();
        }
      }
      return null;
    }

    final polymerType = field('Polyamidtyp');
    final tradeName = field('Materialbezeichnung');
    final lotNumber = field('ChargeLotNr');
    final manufacturerName = field('Hersteller');
    final diameter = field('Durchmesser_mm');
    final density = field('Dichte_g_cm3');
    final initialWeight = field('Initialgewicht_g');
    final spoolId = field('SpoolmanSpoolId');

    // Nothing worth a catalog entry for — every field the UI would show
    // came back empty.
    if (polymerType == null && tradeName == null && manufacturerName == null) {
      return null;
    }

    double? temp(String idShort) {
      for (final element in temperatures?.submodelElements ?? const []) {
        if (element.idShort == idShort && element is Property) {
          return double.tryParse(element.value?.toString() ?? '');
        }
      }
      return null;
    }

    final nozzleMin = temp('Duesentemperatur_min_C');
    final nozzleMax = temp('Duesentemperatur_max_C');
    final bedMin = temp('Betttemperatur_min_C');
    final bedMax = temp('Betttemperatur_max_C');

    // Deterministic, not random: re-syncing the same lot of the same
    // polymer should resolve to the same catalog entry instead of piling
    // up duplicates every time the app opens.
    final slug = (polymerType ?? tradeName ?? 'MATERIAL')
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]+'), '');
    final id = lotNumber != null ? 'MAT-$slug-$lotNumber' : 'MAT-$slug';

    return model.Material(
      id: id,
      tradeName: tradeName,
      articleNumber: spoolId != null ? 'Spool #$spoolId' : null,
      lotNumber: lotNumber,
      manufacturerName: manufacturerName,
      polymerType: polymerType,
      filamentDiameter: diameter != null ? '$diameter mm' : null,
      density: density != null ? '$density g/cm³' : null,
      spoolWeight: initialWeight != null ? '$initialWeight g (initial)' : null,
      nozzleTemperature:
          (nozzleMin != null && nozzleMax != null)
              ? '${nozzleMin.toStringAsFixed(0)}-${nozzleMax.toStringAsFixed(0)} °C (measured, this print)'
              : null,
      bedTemperature:
          (bedMin != null && bedMax != null)
              ? '${bedMin.toStringAsFixed(0)}-${bedMax.toStringAsFixed(0)} °C (measured, this print)'
              : null,
      dataSource: 'Measured',
    );
  }
}
