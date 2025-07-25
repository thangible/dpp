import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dpp/app/services/basyx_api_client.dart';

class BaSyxFileService {
  final BaSyxApiClient _apiClient;

  BaSyxFileService(this._apiClient);

  Future<void> uploadAttachment(
    String submodelIdentifier,
    String idShortPath,
    File file,
  ) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    await _apiClient.uploadAttachment(
      submodelIdentifier,
      idShortPath,
      formData,
    );
  }

  Future<void> uploadThumbnail(String aasIdentifier, File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    await _apiClient.uploadThumbnail(aasIdentifier, formData);
  }

  Future<void> uploadEnvironmentFile(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    await _apiClient.uploadEnvironmentFile(formData);
  }
}
