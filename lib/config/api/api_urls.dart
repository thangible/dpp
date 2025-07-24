class ApiURLs {
  static const String lookupServiceBaseUrl = 'http://localhost:8084';
  static const String registryServiceBaseUrl = 'http://localhost:8082';
  static const String submodelRegistryBaseUrl = 'http://localhost:8083';
  static const String aasServiceBaseUrl = 'http://localhost:8081';
}

enum ApiEndpoint {
  // Lookup Service
  lookupShells('${ApiURLs.lookupServiceBaseUrl}/lookup/shells'),

  // Registry Service
  shellDescriptors('${ApiURLs.registryServiceBaseUrl}/shell-descriptors'),

  // Submodel Registry
  submodelDescriptors(
    '${ApiURLs.submodelRegistryBaseUrl}/submodel-descriptors',
  ),

  // AAS Service
  shells('${ApiURLs.aasServiceBaseUrl}/shells'),
  submodels('${ApiURLs.aasServiceBaseUrl}/submodels'),
  conceptDescriptions('${ApiURLs.aasServiceBaseUrl}/concept-descriptions');

  const ApiEndpoint(this.url);

  final String url;
}
