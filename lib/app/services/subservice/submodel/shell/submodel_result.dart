import 'package:dpp/app/data/submodel.dart'; // Assuming Submodel is here

/// Result wrapper for submodel fetch operations.
class SubmodelResult {
  /// The submodel data if successful.
  final Submodel? submodel;

  /// The submodel ID that was requested.
  final String submodelId;

  /// Error message if the operation failed.
  final String? error;

  /// Whether the operation was successful.
  final bool isSuccess;

  /// Private constructor for SubmodelResult.
  SubmodelResult._({
    required this.submodelId,
    this.submodel,
    this.error,
    required this.isSuccess,
  });

  /// Factory constructor for successful result.
  factory SubmodelResult.success(Submodel submodel) {
    return SubmodelResult._(
      submodelId: submodel.id,
      submodel: submodel,
      isSuccess: true,
    );
  }

  /// Factory constructor for error result.
  factory SubmodelResult.error(String submodelId, String error) {
    return SubmodelResult._(
      submodelId: submodelId,
      error: error,
      isSuccess: false,
    );
  }
}
