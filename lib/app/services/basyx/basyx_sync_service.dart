import 'dart:typed_data';

import 'package:dpp/app/data_model/api/base_aas_model.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'package:dpp/app/data_model/material/material.dart' as model;
import 'package:dpp/app/data_model/test/product.dart';
import 'package:dpp/app/services/test/material_service.dart';
import 'package:dpp/app/services/test/product_service.dart';
import 'basyx_config.dart';
import 'basyx_local_cache.dart';
import 'basyx_log.dart';
import 'basyx_mock_repository.dart';
import 'basyx_models.dart';
import 'basyx_remote_repository.dart';
import 'basyx_repository.dart';

/// Runs on every app open: ask the server (or the mock standing in for
/// one) what's out there, pull down anything new, and fold it into
/// [ProductService]/[MaterialService] — same catalog Home search, History,
/// and the detail screens already read from, so a synced product just
/// shows up next to the regular mock ones without anything else needing to
/// know where it came from.
///
/// If it can't reach anything, falls back to whatever synced successfully
/// last time (see [BasyxLocalCache]) instead of showing nothing.
class BasyxSyncService {
  BasyxSyncService({BasyxRepository? repository, BasyxLocalCache? cache})
    : _repository = repository ?? _defaultRepository(),
      _cache = cache ?? BasyxLocalCache();

  static BasyxRepository _defaultRepository() =>
      BasyxConfig.useMockData ? BasyxMockRepository() : BasyxRemoteRepository();

  final BasyxRepository _repository;
  final BasyxLocalCache _cache;

  /// Runs at startup so it can't throw — worst case we just don't get
  /// anything new this launch, same as before this whole thing existed.
  Future<void> syncOnAppStart() async {
    basyxLog(
      BasyxConfig.useMockData
          ? 'starting sync (mock mode)'
          : 'starting sync (real server: ${BasyxConfig.baseUrl})',
    );
    try {
      final shells = await _repository.fetchShellList();
      await _cache.saveShellList(shells);
      var okCount = 0;
      for (final shell in shells) {
        // One bad shell (bad data, a request that fails partway through)
        // shouldn't take the rest of the batch down with it.
        try {
          await _syncShell(shell);
          okCount++;
        } catch (e) {
          basyxLog('FAILED to sync shell ${shell.idShort}: $e');
        }
      }
      basyxLog('sync done: $okCount/${shells.length} shell(s) registered');
    } catch (e) {
      // A failed sync (server unreachable, mock asset missing, ...)
      // shouldn't block the app from starting — fall back to whatever the
      // last successful sync already put in the local cache.
      basyxLog('sync failed ($e), falling back to local cache only');
      try {
        await _registerFromCacheOnly();
      } catch (e2) {
        basyxLog('local cache fallback also failed ($e2) — nothing to show');
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
    Uint8List? imageBytes;

    if (isFresh) {
      basyxLog('${shell.idShort}: using cached copy from $downloadedAt');
      packageJson = (await _cache.loadPackage(shell.id))!;
    } else {
      basyxLog('${shell.idShort}: downloading fresh copy');
      final package = await _repository.fetchShellPackage(shell);
      packageJson = package.toJson();
      await _cache.savePackage(shell.id, packageJson);

      final thumbnailBytes = await _repository.fetchThumbnail(shell);
      if (thumbnailBytes != null) {
        imagePath = await _cache.saveThumbnail(shell.id, thumbnailBytes);
        // No filesystem to save to (Flutter Web) — saveThumbnail comes back
        // null, so keep the bytes themselves instead of losing the image.
        if (imagePath == null) imageBytes = thumbnailBytes;
      }
    }

    _registerPackage(
      AasResponse.fromJson(packageJson),
      imagePath,
      imageBytes,
    );
  }

  Future<void> _registerFromCacheOnly() async {
    final shells = await _cache.loadShellList();
    basyxLog('registering ${shells.length} shell(s) from local cache');
    for (final shell in shells) {
      final packageJson = await _cache.loadPackage(shell.id);
      if (packageJson == null) continue;
      final imagePath = await _cache.thumbnailPath(shell.id);
      _registerPackage(AasResponse.fromJson(packageJson), imagePath, null);
    }
  }

  void _registerPackage(
    AasResponse aasResponse,
    String? imagePath,
    Uint8List? imageBytes,
  ) {
    final material = _materialFromDinSpec91481(aasResponse);
    if (material != null) {
      MaterialService.registerMaterial(material);
    }

    final product = Product.fromJson(
      aasResponse,
      resolvedImagePath: imagePath,
      resolvedImageBytes: imageBytes,
      resolvedMaterialId: material?.id,
    );
    if (product.id.isNotEmpty) {
      ProductService.registerProduct(product);
      basyxLog(
        'registered product "${product.id}"'
        '${material != null ? ' with material "${material.id}"' : ''}',
      );
    } else {
      basyxLog('package had no usable product id, skipped');
    }
  }

  /// Pulls a [model.Material] out of a "MaterialData_DINSPEC91481"
  /// submodel if the package has one (plus "Temperaturen" for the
  /// print-condition fields, if that's there too). Lives here rather than
  /// on Product itself since "is this worth its own catalog entry" felt
  /// like a sync-layer call, not something the data model should decide.
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

    // nothing worth showing, skip it
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

    // deterministic id, so re-syncing the same lot doesn't create a new
    // duplicate entry every time the app opens
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
