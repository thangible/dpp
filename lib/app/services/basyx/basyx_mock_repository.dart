import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'basyx_models.dart';
import 'basyx_repository.dart';

/// Offline stand-in for the real BaSyx server: reads the same shell-list /
/// package / thumbnail shapes [BasyxRepository] promises, but from assets
/// bundled at build time (assets/basyx_mock/) instead of over HTTP.
///
/// assets/basyx_mock/shells_index.json is the mock's own bookkeeping — it
/// maps each shell id to which asset holds its package JSON and (if any)
/// its thumbnail image. That file's shape is specific to this mock; a real
/// server obviously doesn't need it; it's how this class fakes having a
/// server there in the first place.
class BasyxMockRepository implements BasyxRepository {
  static const _indexAsset = 'assets/basyx_mock/shells_index.json';

  List<Map<String, dynamic>>? _index;

  Future<List<Map<String, dynamic>>> _loadIndex() async {
    final cached = _index;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString(_indexAsset);
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _index = list;
    return list;
  }

  Future<Map<String, dynamic>> _entryFor(ShellDescriptor shell) async {
    final index = await _loadIndex();
    return index.firstWhere(
      (entry) => entry['id'] == shell.id,
      orElse: () => throw StateError('No mock entry for shell ${shell.id}'),
    );
  }

  @override
  Future<List<ShellDescriptor>> fetchShellList() async {
    final index = await _loadIndex();
    return index
        .map(
          (entry) => ShellDescriptor(
            id: entry['id'] as String,
            idShort: entry['idShort'] as String,
          ),
        )
        .toList();
  }

  @override
  Future<AasResponse> fetchShellPackage(ShellDescriptor shell) async {
    final entry = await _entryFor(shell);
    final packageAsset = entry['packageAsset'] as String;
    final raw = await rootBundle.loadString(packageAsset);
    return AasResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<Uint8List?> fetchThumbnail(ShellDescriptor shell) async {
    final entry = await _entryFor(shell);
    final thumbnailAsset = entry['thumbnailAsset'] as String?;
    if (thumbnailAsset == null) return null;
    final bytes = await rootBundle.load(thumbnailAsset);
    return bytes.buffer.asUint8List();
  }
}
