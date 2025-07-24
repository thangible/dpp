import 'dart:convert';
import 'package:dpp/app/data/submodel.dart';
import 'package:dpp/app/services/subservice/submodel/shell/submodel_service_exception.dart';

class SubmodelParser {
  /// Parses a JSON string containing a single submodel.
  Submodel parseSubmodel(String jsonString) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return Submodel.fromJson(json);
    } on FormatException catch (e) {
      throw SubmodelServiceException(
        'Invalid JSON format while parsing submodel: ${e.message}',
        originalException: e,
      );
    } on TypeError catch (e) {
      throw SubmodelServiceException(
        'Invalid data structure while parsing submodel: ${e.toString()}',
        originalException: e,
      );
    } catch (e) {
      throw SubmodelServiceException(
        'Unexpected error while parsing submodel: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Parses a JSON string containing multiple submodels.
  List<Submodel> parseSubmodels(String jsonString) {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => Submodel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e) {
      throw SubmodelServiceException(
        'Invalid JSON format while parsing submodels: ${e.message}',
        originalException: e,
      );
    } on TypeError catch (e) {
      throw SubmodelServiceException(
        'Invalid data structure while parsing submodels: ${e.toString()}',
        originalException: e,
      );
    } catch (e) {
      throw SubmodelServiceException(
        'Unexpected error while parsing submodels: ${e.toString()}',
        originalException: e,
      );
    }
  }
}
