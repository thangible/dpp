import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'basyx_models.dart';
import 'basyx_repository.dart';

/// Stands in for the real server — same shapes as [BasyxRepository]
/// promises, just reading from bundled assets instead of the network.
///
/// shells_index.json is our own bookkeeping (shell id -> which asset has
/// its package/thumbnail). Only exists because this is a mock — a real
/// server obviously wouldn't need a file like this.
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
