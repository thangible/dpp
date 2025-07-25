import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dpp/app/data/base_aas_model.dart';
import 'package:dpp/app/data/generic_submodel.dart';
part 'basyx_api_client.g.dart';

// --- BaSyxApiClient (Retrofit Interface) ---
@RestApi(
  baseUrl: "http://localhost:8081",
) // Base URL for AAS Service (can be configured via Dio)
abstract class BaSyxApiClient {
  factory BaSyxApiClient(Dio dio, {String baseUrl}) = _BaSyxApiClient;

  // --- Registry and Discovery Interface ---
  @GET("/description")
  Future<String> getDescription();

  // --- Submodel Repository API ---

  // Using the generic PagingResponse for Submodels
  @GET("/submodels")
  Future<PagingResponse<Submodel>> getAllSubmodels();

  @POST("/submodels")
  Future<Submodel> createSubmodel(@Body() Submodel submodel);

  @GET("/submodels/{submodelIdentifier}")
  Future<Submodel> getSubmodel(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Query("level") String? level,
    @Query("extent") String? extent,
  );

  @PUT("/submodels/{submodelIdentifier}")
  Future<void> updateSubmodel(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Body() Submodel submodel,
  );

  @DELETE("/submodels/{submodelIdentifier}")
  Future<void> deleteSubmodel(
    @Path("submodelIdentifier") String submodelIdentifier,
  );

  // Fixed: Return raw Map instead of Response wrapper
  @GET("/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}")
  Future<Map<String, SubmodelElement>> getSubmodelElement(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
  );

  @PUT("/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}")
  Future<void> updateSubmodelElement(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
    @Body() Map<String, dynamic> elementData,
  );

  // Fixed: Return raw Map instead of Response wrapper
  @POST("/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}")
  Future<Map<String, SubmodelElement>> createSubmodelElementAtPath(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
    @Body() Map<String, dynamic> elementData,
  );

  @DELETE("/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}")
  Future<void> deleteSubmodelElement(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
  );

  // // Fixed: Return raw List instead of Response wrapper
  // @GET("/submodels/{submodelIdentifier}/submodel-elements")
  // Future<List<Map<String, SubmodelElement>>> getAllSubmodelElements(
  //   @Path("submodelIdentifier") String submodelIdentifier,
  // );

  // Fixed: Return raw Map instead of Response wrapper
  @POST("/submodels/{submodelIdentifier}/submodel-elements")
  Future<Map<String, SubmodelElement>> createSubmodelElement(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Body() Map<String, dynamic> elementData,
  );

  @POST(
    "/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}/invoke",
  )
  Future<OperationResponse> invokeOperation(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
    @Body() OperationRequest operationRequest,
  );

  // Fixed: Escaped dollar sign with double backslash
  @GET(
    r"/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}/\$value",
  )
  Future<SubmodelElement> getSubmodelElementValue(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
  );

  // Fixed: Escaped dollar sign with double backslash
  @PATCH(
    r"/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}/\$value",
  )
  Future<void> updateSubmodelElementValue(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
    @Body() dynamic value,
  );

  @GET(r"/submodels/{submodelIdentifier}/\$value")
  Future<Map<String, SubmodelElement>> getSubmodelValue(
    @Path("submodelIdentifier") String submodelIdentifier,
  );

  // Fixed: Escaped dollar sign with double backslash
  @PATCH(r"/submodels/{submodelIdentifier}/\$value")
  Future<void> updateSubmodelValue(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Body() Map<String, dynamic> values,
  );

  // Fixed: Return raw Map instead of Response wrapper
  @GET(r"/submodels/{submodelIdentifier}/\$metadata")
  Future<Map<String, SubmodelElement>> getSubmodelMetadata(
    @Path("submodelIdentifier") String submodelIdentifier,
  );

  // --- Asset Administration Shell API (File Operations related to Submodels) ---
  @GET(
    "/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}/attachment",
  )
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> downloadAttachment(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
  );

  // Fixed: Return raw Response for file uploads
  @PUT(
    "/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}/attachment",
  )
  Future<UploadResponse> uploadAttachment(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
    @Body() FormData formData,
  );

  @DELETE(
    "/submodels/{submodelIdentifier}/submodel-elements/{idShortPath}/attachment",
  )
  Future<void> deleteAttachment(
    @Path("submodelIdentifier") String submodelIdentifier,
    @Path("idShortPath") String idShortPath,
  );

  // --- Asset Administration Shell Repository API ---
  @GET("/shells/{aasIdentifier}")
  Future<AssetAdministrationShell> getShell(
    @Path("aasIdentifier") String aasIdentifier,
  );

  @PUT("/shells/{aasIdentifier}")
  Future<void> updateShell(
    @Path("aasIdentifier") String aasIdentifier,
    @Body() AssetAdministrationShell shell,
  );

  @DELETE("/shells/{aasIdentifier}")
  Future<void> deleteShell(@Path("aasIdentifier") String aasIdentifier);

  @GET("/shells/{aasIdentifier}/asset-information")
  Future<AssetInformation> getAssetInformation(
    @Path("aasIdentifier") String aasIdentifier,
  );

  @PUT("/shells/{aasIdentifier}/asset-information")
  Future<void> updateAssetInformation(
    @Path("aasIdentifier") String aasIdentifier,
    @Body() AssetInformation assetInformation,
  );

  @GET("/shells/{aasIdentifier}/asset-information/thumbnail")
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getThumbnail(@Path("aasIdentifier") String aasIdentifier);

  // Fixed: Return raw Response for file uploads
  @PUT("/shells/{aasIdentifier}/asset-information/thumbnail")
  Future<UploadResponse> uploadThumbnail(
    @Path("aasIdentifier") String aasIdentifier,
    @Body() FormData formData,
  );

  @DELETE("/shells/{aasIdentifier}/asset-information/thumbnail")
  Future<void> deleteThumbnail(@Path("aasIdentifier") String aasIdentifier);

  @GET("/shells")
  Future<List<AssetAdministrationShell>> getAllShells();

  @POST("/shells")
  Future<AssetAdministrationShell> createShell(
    @Body() AssetAdministrationShell shell,
  );

  @GET("/shells/{aasIdentifier}/submodel-refs")
  Future<List<String>> getSubmodelReferences(
    @Path("aasIdentifier") String aasIdentifier,
  );

  @POST("/shells/{aasIdentifier}/submodel-refs")
  Future<void> createSubmodelReference(
    @Path("aasIdentifier") String aasIdentifier,
    @Body() String submodelIdentifier,
  );

  @DELETE("/shells/{aasIdentifier}/submodel-refs/{submodelIdentifier}")
  Future<void> deleteSubmodelReference(
    @Path("aasIdentifier") String aasIdentifier,
    @Path("submodelIdentifier") String submodelIdentifier,
  );

  // --- Concept Description Repository API ---
  @GET("/concept-descriptions")
  Future<PagingResponse<ConceptDescription>> getAllConceptDescriptions();

  @POST("/concept-descriptions")
  Future<ConceptDescription> createConceptDescription(
    @Body() ConceptDescription conceptDescription,
  );

  @GET("/concept-descriptions/{cdIdentifier}")
  Future<ConceptDescription> getConceptDescription(
    @Path("cdIdentifier") String cdIdentifier,
  );

  @PUT("/concept-descriptions/{cdIdentifier}")
  Future<void> updateConceptDescription(
    @Path("cdIdentifier") String cdIdentifier,
    @Body() ConceptDescription conceptDescription,
  );

  @DELETE("/concept-descriptions/{cdIdentifier}")
  Future<void> deleteConceptDescription(
    @Path("cdIdentifier") String cdIdentifier,
  );

  // --- Environment API ---
  @POST("/upload")
  Future<void> uploadEnvironmentFile(@Body() FormData formData);

  // --- Serialization API ---
  @GET("/serialization")
  Future<String> getSerialization(@Query("format") String format);
}
