import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'basyx_models.dart';

/// The "downloaded files kept in local" half of the sync flow. Both
/// [BasyxMockRepository] and [BasyxRemoteRepository] feed the *same* cache
/// shape here — this class has no idea (and doesn't need to know) which one
/// supplied what it's writing. On the next app start, whatever's here is
/// available immediately, before any network/asset round-trip completes.
///
/// path_provider has no local-filesystem concept on Flutter Web, so every
/// method here degrades to a harmless no-op/miss there (caught once, in
/// [_cacheDir]) instead of throwing — a missing cache should mean "download
/// fresh every time", never "crash on startup".
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
      _dir = dir;
      return dir;
    } catch (_) {
      // No local filesystem on this platform (e.g. web) — remember that so
      // every call after the first fails fast instead of retrying.
      _unavailable = true;
      return null;
    }
  }

  /// Turns an AAS id (a long URL) into something safe to use as a file
  /// name, while staying human-readable enough to debug by eye.
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
  }

  Future<Map<String, dynamic>?> loadPackage(String shellId) async {
    final dir = await _cacheDir();
    if (dir == null) return null;
    final file = File('${dir.path}/${_safeName(shellId)}.package.json');
    if (!await file.exists()) return null;
    final wrapped = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
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

  /// Saves the image and returns a `file://`-prefixed path — the marker
  /// [ProductImageCard] uses to know this is a filesystem path, not a
  /// bundled Flutter asset key, and load it with `Image.file` instead of
  /// `Image.asset`. Null if there's no local filesystem to save it to.
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
