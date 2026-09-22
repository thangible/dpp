/// On/off switch for BaSyx. Mock mode reads from bundled assets, real mode
/// hits [baseUrl] instead — same sync flow either way, nothing else in the
/// app cares which one is active.
class BasyxConfig {
  BasyxConfig._();

  /// Set to false once the real server is reachable. Rest of the app
  /// doesn't need to change.
  static const bool useMockData = false;

  /// Only matters when useMockData is false.
  ///
  /// Port 3300 on this host serves the BaSyx web UI (HTML), not the REST
  /// API — the actual AAS Environment REST API lives on 8082.
  static const String baseUrl = 'http://10.75.50.133:8082';

  /// How long we trust a cached package before re-downloading it, even if
  /// the shell list looks the same. Just so a stale copy doesn't stick
  /// around forever.
  static const Duration cacheTtl = Duration(days: 7);
}
