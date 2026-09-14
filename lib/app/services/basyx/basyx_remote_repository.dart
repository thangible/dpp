import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dpp/app/data_model/api/base_aas_model.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'basyx_config.dart';
import 'basyx_log.dart';
import 'basyx_models.dart';
import 'basyx_repository.dart';

/// Real HTTP calls to a BaSyx server, following the standard IDTA REST API.
/// Haven't been able to test this against an actual live server yet
/// (useMockData is still true) — the endpoints below are the spec-standard
/// ones, so if the real deployment does something slightly different, this
/// is the one file that needs fixing.
class BasyxRemoteRepository implements BasyxRepository {
  BasyxRemoteRepository({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? BasyxConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  /// Every request gets cut off after this — without it, a server that's
  /// down or behind a firewall silently dropping packets can hang the
  /// whole app on startup instead of just failing.
  static const _requestTimeout = Duration(seconds: 10);

  /// Ids go in the URL base64url-encoded, per spec — the real id, not the
  /// idShort.
  String _encodeId(String id) => base64Url.encode(utf8.encode(id));

  /// All three fetch* methods go through this so the logging/timeout is in
  /// one place instead of copy-pasted three times.
  Future<http.Response> _get(Uri uri, String what) async {
    basyxLog('GET $uri  ($what)');
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _client.get(uri).timeout(_requestTimeout);
      basyxLog(
        '  -> ${response.statusCode} in ${stopwatch.elapsedMilliseconds}ms, '
        '${response.bodyBytes.length} bytes',
      );
      return response;
    } on TimeoutException {
      basyxLog(
        '  -> TIMED OUT after ${_requestTimeout.inSeconds}s — is $_baseUrl '
        'reachable from this device? (wrong address, VPN needed, server '
        'down, firewall dropping the connection...)',
      );
      rethrow;
    } catch (e) {
      basyxLog('  -> FAILED (${e.runtimeType}): $e');
      rethrow;
    }
  }

  @override
  Future<List<ShellDescriptor>> fetchShellList() async {
    final uri = Uri.parse('$_baseUrl/shells');
    final response = await _get(uri, 'shell list');
    _checkOk(response, 'GET /shells');

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final paging = PagingResponse<AssetAdministrationShell>.fromJson(
      decoded,
      (json) => AssetAdministrationShell.fromJson(json as Map<String, dynamic>),
    );
    final shells =
        paging.result
            .map((aas) => ShellDescriptor(id: aas.id, idShort: aas.idShort))
            .toList();
    basyxLog('found ${shells.length} shell(s) on the server');
    return shells;
  }

  @override
  Future<AasResponse> fetchShellPackage(ShellDescriptor shell) async {
    // shell only has submodel *references* — actual content needs a
    // separate call per submodel
    final shellUri = Uri.parse('$_baseUrl/shells/${_encodeId(shell.id)}');
    final shellResponse = await _get(shellUri, 'shell ${shell.idShort}');
    _checkOk(shellResponse, 'GET /shells/{id}');
    final aas = AssetAdministrationShell.fromJson(
      jsonDecode(shellResponse.body) as Map<String, dynamic>,
    );

    final submodelIds =
        aas.submodels
            ?.expand((ref) => ref.keys ?? const <Key>[])
            .where((key) => key.type == 'Submodel' && key.value != null)
            .map((key) => key.value!)
            .toList() ??
        const <String>[];
    basyxLog('  ${shell.idShort} references ${submodelIds.length} submodel(s)');

    final submodels = <Submodel>[];
    for (final submodelId in submodelIds) {
      final submodelUri = Uri.parse(
        '$_baseUrl/submodels/${_encodeId(submodelId)}',
      );
      final submodelResponse = await _get(submodelUri, 'submodel');
      _checkOk(submodelResponse, 'GET /submodels/{id}');
      final submodel = Submodel.fromJson(
        jsonDecode(submodelResponse.body) as Map<String, dynamic>,
      );
      basyxLog('    got submodel "${submodel.idShort}"');
      submodels.add(submodel);
    }

    return AasResponse(assetAdministrationShells: [aas], submodels: submodels);
  }

  @override
  Future<Uint8List?> fetchThumbnail(ShellDescriptor shell) async {
    final uri = Uri.parse(
      '$_baseUrl/shells/${_encodeId(shell.id)}/asset-information/thumbnail',
    );
    final response = await _get(uri, 'thumbnail for ${shell.idShort}');
    // 404 here just means no thumbnail, not an error
    if (response.statusCode == 404) {
      basyxLog('  no thumbnail for ${shell.idShort}');
      return null;
    }
    _checkOk(response, 'GET /shells/{id}/asset-information/thumbnail');
    return response.bodyBytes;
  }

  void _checkOk(http.Response response, String what) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BasyxRequestException(
        '$what failed: HTTP ${response.statusCode}',
      );
    }
  }
}

class BasyxRequestException implements Exception {
  BasyxRequestException(this.message);
  final String message;

  @override
  String toString() => 'BasyxRequestException: $message';
}
