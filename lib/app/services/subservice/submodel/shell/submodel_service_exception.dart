/// Custom exception for Submodel service errors.
class SubmodelServiceException implements Exception {
  /// The error message.
  final String message;

  /// The HTTP status code if applicable.
  final int? statusCode;

  /// The original exception that caused this error.
  final dynamic originalException;

  /// Constructor for SubmodelServiceException.
  SubmodelServiceException(
    this.message, {
    this.statusCode,
    this.originalException,
  });

  @override
  String toString() {
    return 'SubmodelServiceException: $message';
  }
}
