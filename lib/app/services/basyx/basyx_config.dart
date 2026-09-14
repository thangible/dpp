/// Single on/off switch for the whole BaSyx integration. With
/// [useMockData] true, [BasyxSyncService] reads everything from bundled
/// assets (see BasyxMockRepository); set it false and the exact same sync
/// flow instead calls [baseUrl] over HTTP (see BasyxRemoteRepository) — no
/// other code needs to change either way, since both repositories satisfy
/// the same [BasyxRepository] contract and return the same shapes.
class BasyxConfig {
  BasyxConfig._();

  /// Flip this to false once a real BaSyx server is reachable. Everything
  /// downstream (the product list, images, the local cache) already works
  /// the same way in both modes.
  static const bool useMockData = true;

  /// BaSyx AAS/Submodel Repository base URL (IDTA Part 2 REST API). Only
  /// used when [useMockData] is false.
  static const String baseUrl = 'http://10.75.50.133:3300';

  /// How long a locally-cached package is trusted before the sync service
  /// re-downloads it on next app start, even if the shell list hasn't
  /// changed. Keeps a stale cache from lingering forever if a package is
  /// ever updated server-side without changing its id.
  static const Duration cacheTtl = Duration(days: 7);
}
