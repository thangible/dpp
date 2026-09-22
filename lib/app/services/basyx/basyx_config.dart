/// Server address for BaSyx. [BasyxSyncService] auto-detects whether the
/// server at [baseUrl] is actually reachable on every sync — real data when
/// it is, bundled mock data as a transparent fallback when it isn't. See
/// [BasyxSyncService.isOnline] for the connection status this produces.
class BasyxConfig {
  BasyxConfig._();

  /// Port 3300 on this host serves the BaSyx web UI (HTML), not the REST
  /// API — the actual AAS Environment REST API lives on 8082.
  static const String baseUrl = 'http://10.75.50.133:8082';

  /// How long we trust a cached package before re-downloading it, even if
  /// the shell list looks the same. Just so a stale copy doesn't stick
  /// around forever.
  static const Duration cacheTtl = Duration(days: 7);
}
