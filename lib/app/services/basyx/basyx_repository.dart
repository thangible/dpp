import 'dart:typed_data';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'basyx_models.dart';

/// Basically "what does a BaSyx server give us" — one implementation backed
/// by bundled assets, one backed by real HTTP. Whichever one BasyxConfig
/// picks, the sync service just calls these three methods and doesn't care
/// which.
abstract class BasyxRepository {
  /// The shells available — "the menu". Keep it small, just enough to show
  /// a list and let us ask for one entry's full content afterwards.
  Future<List<ShellDescriptor>> fetchShellList();

  /// Full AAS + submodels for one shell, same shape Product.fromJson etc.
  /// already expect elsewhere.
  Future<AasResponse> fetchShellPackage(ShellDescriptor shell);

  /// Thumbnail bytes if the shell has one, null if not — not having one
  /// isn't an error, most shells probably won't.
  Future<Uint8List?> fetchThumbnail(ShellDescriptor shell);
}
