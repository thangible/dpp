import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dpp/app/data_model/api/base_aas_model.dart';
import 'package:dpp/app/data_model/api/generic_submodel.dart';
import 'basyx_config.dart';
import 'basyx_models.dart';
import 'basyx_repository.dart';

/// Talks to a real BaSyx AAS/Submodel Repository over the IDTA "Part 2:
/// APIs" REST interface (the same one BaSyx itself implements). Not yet
/// exercised against a live server — [BasyxConfig.useMockData] is what
/// decides whether this class or [BasyxMockRepository] is used, and it's
/// still true, so this is the "prepare for later" half of the integration.
/// The endpoints below are the standard ones; if the actual deployment at
/// [BasyxConfig.baseUrl] differs, this is the one file that needs to change
/// — [BasyxSyncService] and everything above it stays the same either way.
class BasyxRemoteRepository implements BasyxRepository {
  BasyxRemoteRepository({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? BasyxConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  /// AAS API identifiers go in the URL Base64Url-encoded (IDTA Part 2,
  /// "Interface OpenAPI" — every {aasIdentifier}/{submodelIdentifier} path
  /// segment is the actual id, not the idShort).
  String _encodeId(String id) => base64Url.encode(utf8.encode(id));

  @override
  Future<List<ShellDescriptor>> fetchShellList() async {
    // GET /shells — paginated list of Asset Administration Shells.
    final uri = Uri.parse('$_baseUrl/shells');
    final response = await _client.get(uri);
    _checkOk(response, 'GET /shells');

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final paging = PagingResponse<AssetAdministrationShell>.fromJson(
      decoded,
      (json) => AssetAdministrationShell.fromJson(json as Map<String, dynamic>),
    );
    return paging.result
        .map((aas) => ShellDescriptor(id: aas.id, idShort: aas.idShort))
        .toList();
  }

  @override
  Future<AasResponse> fetchShellPackage(ShellDescriptor shell) async {
    // GET /shells/{aasIdentifier} — shell + its submodel *references*; the
    // submodels' actual content lives in the Submodel Repository and has
    // to be fetched separately, one call per referenced submodel.
    final shellUri = Uri.parse('$_baseUrl/shells/${_encodeId(shell.id)}');
    final shellResponse = await _client.get(shellUri);
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

    final submodels = <Submodel>[];
    for (final submodelId in submodelIds) {
      final submodelUri = Uri.parse(
        '$_baseUrl/submodels/${_encodeId(submodelId)}',
      );
      final submodelResponse = await _client.get(submodelUri);
      _checkOk(submodelResponse, 'GET /submodels/{id}');
      submodels.add(
        Submodel.fromJson(
          jsonDecode(submodelResponse.body) as Map<String, dynamic>,
        ),
      );
    }

    return AasResponse(assetAdministrationShells: [aas], submodels: submodels);
  }

  @override
  Future<Uint8List?> fetchThumbnail(ShellDescriptor shell) async {
    // GET /shells/{aasIdentifier}/asset-information/thumbnail — the
    // dedicated endpoint for a shell's thumbnail. A 404 just means this
    // shell doesn't have one, which is a normal, expected outcome here.
    final uri = Uri.parse(
      '$_baseUrl/shells/${_encodeId(shell.id)}/asset-information/thumbnail',
    );
    final response = await _client.get(uri);
    if (response.statusCode == 404) return null;
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
