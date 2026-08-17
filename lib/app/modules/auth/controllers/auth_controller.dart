import 'package:get/get.dart';
import 'package:dpp/app/services/hive/hive_service.dart';

/// Mock local auth: this app has no backend, so credentials are checked
/// against a single hardcoded account. Sign-in state persists across
/// restarts via Hive; a guest session deliberately does not.
class AuthController extends GetxController {
  static const _adminUsername = 'admin';
  static const _adminPassword = 'admin';

  final RxBool isAuthenticated = false.obs;
  final RxBool isGuest = false.obs;
  final RxString username = ''.obs;
  final RxString displayName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = HiveService.getSession();
    if (stored != null) {
      isAuthenticated.value = true;
      isGuest.value = false;
      username.value = stored['username'] as String? ?? _adminUsername;
      displayName.value = stored['displayName'] as String? ?? 'Admin';
    }
  }

  /// Returns true on success. The screen owns the (localized) error
  /// message on failure — this controller has no BuildContext to
  /// translate one itself.
  Future<bool> signIn(String enteredUsername, String enteredPassword) async {
    final user = enteredUsername.trim();
    if (user != _adminUsername || enteredPassword != _adminPassword) {
      return false;
    }
    username.value = user;
    displayName.value = 'Admin';
    isGuest.value = false;
    isAuthenticated.value = true;
    await HiveService.saveSession(username: user, displayName: 'Admin');
    return true;
  }

  void continueAsGuest() {
    username.value = 'guest';
    displayName.value = 'Guest';
    isGuest.value = true;
    isAuthenticated.value = true;
    // Deliberately not persisted — guest sessions don't survive a restart.
  }

  Future<void> updateDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    displayName.value = trimmed;
    if (!isGuest.value) {
      await HiveService.saveSession(username: username.value, displayName: trimmed);
    }
  }

  Future<void> signOut() async {
    isAuthenticated.value = false;
    isGuest.value = false;
    username.value = '';
    displayName.value = '';
    await HiveService.clearSession();
  }
}
