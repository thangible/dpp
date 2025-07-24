import 'package:http/http.dart' as http;
import 'package:dpp/app/services/http_util.dart';


// Import your new modular services
import 'package:dpp/app/services/subservice/shell_api_service.dart';
import 'package:dpp/app/services/subservice/submodel_api_service.dart';
import 'package:dpp/app/services/subservice/concept_description_api_service.dart';

/// Central API client for Asset Administration Shell (AAS) operations.
/// This class orchestrates calls to more specific API services.
class AasClient {
  // Instances of your modular services
  late final ShellApiService shells;
  late final SubmodelApiService submodels;
  late final ConceptDescriptionApiService conceptDescriptions;

  /// Constructor for AasClient.
  /// Accepts an optional HTTP client for dependency injection (useful for testing).
  AasClient({http.Client? client}) {
    // Initialize the HttpUtil with the client
    HttpUtil.initialize(client: client);
    
    shells = ShellApiService();
    submodels = SubmodelApiService();
    conceptDescriptions = ConceptDescriptionApiService();
  }

  /// Disposes of the HTTP client.
  void dispose() {
    HttpUtil.dispose();
  }
}