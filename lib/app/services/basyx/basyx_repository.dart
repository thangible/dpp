import 'dart:typed_data';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'basyx_models.dart';

/// What [BasyxSyncService] needs from "a BaSyx server" — implemented once
/// against bundled assets (BasyxMockRepository) and once against the real
/// AAS/Submodel Repository REST API (BasyxRemoteRepository). Swapping
/// [BasyxConfig.useMockData] swaps which implementation the sync service
/// gets; nothing else in the app needs to know which one is active.
abstract class BasyxRepository {
  /// The list of shells (AAS packages) available on the server — "the
  /// menu". Cheap and small on purpose: just enough to show a list and to
  /// then ask [fetchShellPackage]/[fetchThumbnail] for one entry's content.
  Future<List<ShellDescriptor>> fetchShellList();

  /// The shell's full AAS + submodels content, in the same shape the app
  /// already parses everywhere else via [AasResponse]/[Product.fromJson].
  Future<AasResponse> fetchShellPackage(ShellDescriptor shell);

  /// The shell's thumbnail image bytes, if it has one (from the Medien
  /// submodel's "Thumbnail" File element, or wherever the server exposes
  /// it) — null if the shell has no thumbnail rather than an error.
  Future<Uint8List?> fetchThumbnail(ShellDescriptor shell);
}
