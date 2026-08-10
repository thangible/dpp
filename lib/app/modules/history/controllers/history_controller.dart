import 'package:get/get.dart';
import 'package:dpp/app/data_model/history/history_entry.dart';
import 'package:dpp/app/modules/auth/controllers/auth_controller.dart';
import 'package:dpp/app/services/hive/hive_service.dart';

/// Scan/search history + favorites. Signed-in users get it persisted in
/// Hive; a guest session keeps it in memory only, so it resets the moment
/// they sign out or the app restarts (confirmed scope: guests get
/// History/Favorites, but session-only).
class HistoryController extends GetxController {
  static const _maxEntries = 50;

  final RxList<HistoryEntry> entries = <HistoryEntry>[].obs;

  AuthController get _auth => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _reload();
    ever(_auth.isAuthenticated, (_) => _reload());
    ever(_auth.isGuest, (_) => _reload());
  }

  void _reload() {
    if (!_auth.isAuthenticated.value || _auth.isGuest.value) {
      // Signed out, or a fresh guest session: start empty. Guests never
      // read from Hive, so nothing from a previous account leaks in.
      entries.clear();
      return;
    }
    final stored = HiveService.getHistoryEntries();
    entries.assignAll(stored.map(HistoryEntry.fromJson));
  }

  Future<void> _persist() async {
    if (_auth.isGuest.value) return;
    await HiveService.saveHistoryEntries(
      entries.map((e) => e.toJson()).toList(),
    );
  }

  List<HistoryEntry> get favorites {
    final list = entries.where((e) => e.isFavorite).toList();
    list.sort((a, b) => b.viewedAt.compareTo(a.viewedAt));
    return list;
  }

  List<HistoryEntry> get recent {
    final list = List<HistoryEntry>.of(entries);
    list.sort((a, b) => b.viewedAt.compareTo(a.viewedAt));
    return list;
  }

  bool isFavorite(String id, HistoryItemType type) {
    return entries.any(
      (e) => e.id == id && e.type == type && e.isFavorite,
    );
  }

  Future<void> addEntry(String id, HistoryItemType type) async {
    final wasFavorite = isFavorite(id, type);
    entries.removeWhere((e) => e.id == id && e.type == type);
    entries.insert(
      0,
      HistoryEntry(
        id: id,
        type: type,
        viewedAt: DateTime.now(),
        isFavorite: wasFavorite,
      ),
    );
    if (entries.length > _maxEntries) {
      entries.removeRange(_maxEntries, entries.length);
    }
    await _persist();
  }

  Future<void> toggleFavorite(String id, HistoryItemType type) async {
    final index = entries.indexWhere((e) => e.id == id && e.type == type);
    if (index == -1) return;
    entries[index] = entries[index].copyWith(
      isFavorite: !entries[index].isFavorite,
    );
    await _persist();
  }
}
