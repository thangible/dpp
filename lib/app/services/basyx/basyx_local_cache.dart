import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'basyx_log.dart';
import 'basyx_models.dart';

/// The "keep it on disk" part of the sync flow. Doesn't care whether mock
/// or remote wrote what's here, just reads/writes files.
///
/// Web has no real filesystem, so every method here just quietly does
/// nothing there instead of throwing (see [_cacheDir]) — a missing cache
/// should mean "fetch fresh next time", not "crash on startup".
class BasyxLocalCache {
  static const _dirName = 'basyx_cache';

  Directory? _dir;
  bool _unavailable = false;

  Future<Directory?> _cacheDir() async {
    if (_unavailable) return null;
    final existing = _dir;
    if (existing != null) return existing;
    try {
      final support = await getApplicationSupportDirectory();
      final dir = Directory('${support.path}/$_dirName');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      basyxLog('local cache dir: ${dir.path}');
      _dir = dir;
      return dir;
    } catch (e) {
      // probably web, no filesystem here — remember it so we stop retrying
      basyxLog(
        'no local cache available (${e.runtimeType}) — will fetch fresh '
        'every time instead of persisting between launches',
      );
      _unavailable = true;
      return null;
    }
  }

  /// AAS ids are long URLs — turn one into something safe to use as a
  /// filename (and still readable enough to eyeball while debugging).
  String _safeName(String id) {
    final cleaned = id.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
    return cleaned.length > 120 ? cleaned.substring(0, 120) : cleaned;
  }

  // ---- Shell list -------------------------------------------------------

  Future<void> saveShellList(List<ShellDescriptor> shells) async {
    final dir = await _cacheDir();
    if (dir == null) return;
    final file = File('${dir.path}/shells_index.json');
    final json = shells.map((s) => {'id': s.id, 'idShort': s.idShort}).toList();
    await file.writeAsString(jsonEncode(json));
  }

  Future<List<ShellDescriptor>> loadShellList() async {
    final dir = await _cacheDir();
    if (dir == null) return const [];
    final file = File('${dir.path}/shells_index.json');
    if (!await file.exists()) return const [];
    final decoded = jsonDecode(await file.readAsString()) as List;
    return decoded
        .cast<Map<String, dynamic>>()
        .map(
          (e) => ShellDescriptor(
            id: e['id'] as String,
            idShort: e['idShort'] as String,
          ),
        )
        .toList();
  }

  // ---- Per-shell package (AAS + submodels JSON) --------------------------

  Future<void> savePackage(String shellId, Map<String, dynamic> packageJson) async {
    final dir = await _cacheDir();
    if (dir == null) return;
    final file = File('${dir.path}/${_safeName(shellId)}.package.json');
    final wrapped = {
      'downloadedAt': DateTime.now().toIso8601String(),
      'package': packageJson,
    };
    await file.writeAsString(jsonEncode(wrapped));
    basyxLog('cached package for $shellId -> ${file.path}');
  }

  Future<Map<String, dynamic>?> loadPackage(String shellId) async {
    final dir = await _cacheDir();
    if (dir == null) return null;
    final file = File('${dir.path}/${_safeName(shellId)}.package.json');
    if (!await file.exists()) {
      basyxLog('no cached package for $shellId');
      return null;
    }
    final wrapped = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    basyxLog('read cached package for $shellId');
    return wrapped['package'] as Map<String, dynamic>;
  }

  Future<DateTime?> packageDownloadedAt(String shellId) async {
    final dir = await _cacheDir();
    if (dir == null) return null;
    final file = File('${dir.path}/${_safeName(shellId)}.package.json');
    if (!await file.exists()) return null;
    final wrapped = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return DateTime.tryParse(wrapped['downloadedAt'] as String? ?? '');
  }

  // ---- Per-shell thumbnail -----------------------------------------------

  /// Returns a `file://` path — that's the marker ProductImageCard checks
  /// for to use Image.file instead of Image.asset. Null if there's nowhere
  /// to save it (no local filesystem).
  Future<String?> saveThumbnail(String shellId, Uint8List bytes) async {
    final dir = await _cacheDir();
    if (dir == null) return null;
    final file = File('${dir.path}/${_safeName(shellId)}.img');
    await file.writeAsBytes(bytes, flush: true);
    return Uri.file(file.path).toString();
  }

  Future<String?> thumbnailPath(String shellId) async {
    final dir = await _cacheDir();
    if (dir == null) return null;
    final file = File('${dir.path}/${_safeName(shellId)}.img');
    if (!await file.exists()) return null;
    return Uri.file(file.path).toString();
  }
}
