// ignore_for_file: avoid_print

/// One place for all the Basyx debug prints, so they're all prefixed the
/// same way — search the console/logcat for "[Basyx]" to see just this
/// subsystem's activity.
void basyxLog(String message) {
  print('[Basyx] $message');
}
