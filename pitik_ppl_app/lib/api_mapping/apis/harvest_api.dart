
import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/patch.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/annotation/request/put.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/harvest_list_response.dart';
import 'package:model/response/realization_response.dart';
import 'package:model/response/harvest_detail_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 16/11/2023

@Rest
class HarvestApi {

    /// The function `getSubmitsHarvest` is a GET request that retrieves a list of
    /// harvest requests with the specified farming cycle ID.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to authenticate the user making the request.
    ///   xId (String): The "X-ID" header is a custom header that is used to pass an
    /// identifier value. It is typically used for authentication or tracking
    /// purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve harvest requests.
    @GET(value: "v2/harvest-requests", as: HarvestListResponse, error: ErrorResponse)
    void getSubmitsHarvest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId) {}

    /// The function `getDealsHarvest` is a GET request that retrieves a list of
    /// harvest deals with the specified authorization, X-ID, and farmingCycleId.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to provide
    /// authentication credentials for the request. It typically contains a token or
    /// other form of authentication that allows the server to verify the identity
    /// of the client making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve the harvest
    /// deals.
    @GET(value: "v2/harvest-deals", as: HarvestListResponse, error: ErrorResponse)
    void getDealsHarvest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId) {}

    /// The function `getRealizationHarvest` is a GET request that retrieves harvest
    /// realizations with the specified authorization, X-ID, and farmingCycleId.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to authenticate the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve the realization
    /// harvest data.
    @GET(value: "v2/harvest-realizations", as: RealizationResponse, error: ErrorResponse)
    void getRealizationHarvest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId) {}

    /// The function `getDetailHarvest` is a GET request that retrieves detailed
    /// information about a harvest, using the provided authorization, X-ID, and
    /// path parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   path (String): The `path` parameter is a placeholder for the specific path
    /// or identifier of the resource you want to retrieve. It is typically used in
    /// the URL of the API endpoint to specify which resource you want to get the
    /// details for.
    @GET(value: GET.PATH_PARAMETER, as: HarvestDetailResponse, error: ErrorResponse)
    void getDetailHarvest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function `approveHarvest` is used to send a PATCH request with
    /// authorization, ID, path, and approval remarks as parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for authentication
    /// purposes. It is typically used to verify the identity and permissions of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for authentication
    /// or tracking purposes.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that needs to be updated or modified. It is typically used in PATCH
    /// requests to identify the specific resource that needs to be modified.
    ///   approvalRemarks (String): The "approvalRemarks" parameter is a string that
    /// represents any remarks or comments related to the approval of a harvest.
    @PATCH(value: PATCH.PATH_PARAMETER, error: ErrorResponse)
    @JSON()
    void approveOrRejectHarvest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("approvalRemarks") String approvalRemarks) {}

    /// The function `addHarvestRequest` sends a POST request to the
    /// "v2/harvest-requests" endpoint with authorization and data parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   data (String): The "data" parameter is a string that represents the
    /// payload or data that you want to send in the request body. It could be any
    /// valid JSON string or plain text data that you want to include in the
    /// request.
    @POST(value: "v2/harvest-requests", error: ErrorResponse)
    @JSON(isPlaint: true)
    void addHarvestRequest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Parameter("data") String data) {}

    /// The function harvestDealCancelled is a PATCH request that takes in
    /// authorization, xId, path, and emptyBody as parameters.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send a token
    /// or credentials to authenticate the request. It is typically used to verify
    /// the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that needs to be updated or modified. It is typically used in PATCH
    /// requests to identify the specific resource that needs to be updated.
    ///   emptyBody (String): The `emptyBody` parameter is a string that represents
    /// the body of the request. In this case, it is expected to be empty.
    @PATCH(value: PATCH.PATH_PARAMETER, error: ErrorResponse)
    @JSON(isPlaint: true)
    void harvestDealCancelled(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("emptyBody") String emptyBody) {}

    /// The function `saveHarvestRealization` is a POST request that saves harvest
    /// realizations with authorization, X-ID, and data as parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   data (String): The "data" parameter is a string that represents the
    /// payload or data that needs to be sent in the request body. It is typically
    /// used to send information or data to be saved or processed by the server.
    @POST(value: "v2/harvest-realizations", error: ErrorResponse)
    @JSON(isPlaint: true)
    void saveHarvestRealization(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Parameter("data") String data) {}

    /// The function `updateHarvestRealization` is a PUT request that updates a
    /// harvest realization with the provided authorization, X-ID, path, and data.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for authentication
    /// purposes. It is typically used to verify the identity and permissions of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents the
    /// X-ID value. It is used to identify a specific resource or entity in the
    /// request.
    ///   path (String): The "path" parameter is a string that represents the path
    /// of the resource that needs to be updated. It is used to specify the specific
    /// resource that the update operation should be applied to.
    ///   data (String): The "data" parameter is a string that represents the
    /// payload or body of the request. It contains the information that needs to be
    /// sent to the server for updating the harvest realization.
    @PUT(value: PUT.PATH_PARAMETER, error: ErrorResponse)
    @JSON(isPlaint: true)
    void updateHarvestRealization(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data) {}
}