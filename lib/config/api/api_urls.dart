class ApiURLs {
  static const String lookupServiceBaseUrl8084 = 'http://localhost:8084';
  static const String registryServiceBaseUrl8082 = 'http://localhost:8082';
  static const String submodelRegistryBaseUrl8083 = 'http://localhost:8083';
  static const String aasServiceBaseUrl8081 = 'http://localhost:8081';
}

enum ApiEndpoint {
  // Lookup Service
  lookupShells('${ApiURLs.lookupServiceBaseUrl8084}/lookup/shells'),

  // Registry Service
  shellDescriptors('${ApiURLs.registryServiceBaseUrl8082}/shell-descriptors'),

  // Submodel Registry
  submodelDescriptors(
    '${ApiURLs.submodelRegistryBaseUrl8083}/submodel-descriptors',
  ),

  // AAS Service
  shells('${ApiURLs.aasServiceBaseUrl8081}/shells'),
  submodels('${ApiURLs.aasServiceBaseUrl8081}/submodels'),
  conceptDescriptions('${ApiURLs.aasServiceBaseUrl8081}/concept-descriptions');

  const ApiEndpoint(this.url);

  final String url;
}
