
import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/patch.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/coop_list_response.dart';
import 'package:model/response/monitoring_performance_response.dart';
import 'package:model/response/monitoring_response.dart';
import 'package:model/response/date_monitoring_response.dart';
import 'package:model/response/monitoring_detail_response.dart';
import 'package:model/response/realization_response.dart';
import 'package:model/response/left_over_response.dart';
import 'package:model/response/adjusment_mortality_response.dart';
import 'package:model/response/farm_info_response.dart';
import 'package:model/response/farm_day_history_response.dart';
import 'package:model/response/farm_actual_response.dart';
import 'package:model/response/farm_projection_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 09/10/2023

@Rest
class FarmMonitoringApi {

    /// The function "farmList" makes a GET request to retrieve a list of active
    /// farming cycles.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to authenticate the user making the request.
    ///   xId (String): The "X-ID" header parameter is typically used to pass a
    /// unique identifier for the request. It can be any string value that helps
    /// identify the request or the user making the request.
    @GET(value: "v2/farms/active-farming-cycle", as: CoopListResponse, error: ErrorResponse)
    void farmList(@Header("Authorization") String authorization, @Header("X-ID") String xId) {}

    /// The function "farmInfo" is a GET request that retrieves farm information
    /// using the provided authorization, X-ID, and path parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity and
    /// permissions of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   path (String): The `path` parameter is a placeholder for the specific path
    /// or identifier of the farm that you want to retrieve information for. It is
    /// typically used in the URL of the API endpoint.
    @GET(value: GET.PATH_PARAMETER, as: FarmInfoResponse, error: ErrorResponse)
    void farmInfo(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function `getPerformHistory` is a GET request that retrieves the
    /// performance history for a farming cycle with the specified parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header that
    /// contains the authorization token for the API request. This token is used to
    /// authenticate the user and ensure that they have the necessary permissions to
    /// access the requested resource.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID value. It is used for authentication or identification purposes in
    /// the API request.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve performance
    /// history.
    ///   page (int): The "page" parameter is used to specify the page number of the
    /// results you want to retrieve. It is typically used for pagination purposes,
    /// allowing you to retrieve a specific subset of results from a larger set of
    /// data.
    ///   limit (int): The "limit" parameter is used to specify the maximum number
    /// of items to be returned in the response. It determines the number of items
    /// per page in the pagination.
    ///   order (String): The "order" parameter is used to specify the order in
    /// which the results should be returned. It can have the following values:
    @GET(value: "v2/performance/history", as: FarmDayHistoryResponse, error: ErrorResponse)
    void getPerformHistory(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("\$page") int page,
                           @Query("\$limit") int limit, @Query("\$order") String order) {}

    /// The function `getFarmActual` is a GET request that retrieves actual farm
    /// performance data using the provided authorization, X-ID, and farmingCycleId.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to authenticate the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve the actual
    /// performance data.
    @GET(value: "v2/performance/actual", as: FarmActualResponse, error: ErrorResponse)
    void getFarmActual(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId) {}

    /// The function `getFarmProjection` is a GET request that retrieves farm
    /// projections based on the provided authorization, X-ID, and farmingCycleId.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to verify the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID value. It is used to identify a specific entity or resource in the
    /// API request.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve the farm
    /// projection data.
    @GET(value: "v2/performance/projection", as: FarmProjectionResponse, error: ErrorResponse)
    void getFarmProjection(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId) {}

    /// The function `getPerformanceMonitoring` is a GET request that retrieves
    /// performance monitoring data with authorization, X-ID, and a path parameter.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity and
    /// permissions of the user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that you want to retrieve or interact with. It is typically used in
    /// combination with the base URL of the API to form the complete URL for the
    /// request.
    @GET(value: GET.PATH_PARAMETER, as: MonitoringPerformanceResponse, error: ErrorResponse)
    void getPerformanceMonitoring(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function `getMonitoringByVariable` is a GET request that retrieves
    /// monitoring data based on a variable, with authorization and ID headers.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   path (String): The `path` parameter is a placeholder for the actual value
    /// that will be passed in the URL path when making the GET request. It is used
    /// to specify a specific resource or endpoint that you want to retrieve
    /// monitoring data for.
    @GET(value: GET.PATH_PARAMETER, as: MonitorResponse, error: ErrorResponse)
    void getMonitoringByVariable(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function getAllDataMonitoring retrieves data for date monitoring using
    /// the specified headers and path.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for authentication
    /// purposes. It is typically used to verify the identity and permissions of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific request or user.
    ///   path (String): The `path` parameter is used to specify the path for the
    /// API endpoint. It is typically used to provide additional information or
    /// context for the request.
    @GET(value: GET.PATH_PARAMETER, as: DateMonitoringResponse, error: ErrorResponse)
    void getAllDataMonitoring(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function `getDateMonitoring` is a GET request that retrieves date
    /// monitoring data with authorization, X-ID, and a path parameter.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific request or user.
    ///   path (String): The `path` parameter is used to specify the path for the
    /// API endpoint. It is typically used to provide additional information or
    /// context for the request.
    @GET(value: GET.PATH_PARAMETER, as: DateMonitoringResponse, error: ErrorResponse)
    void getDateMonitoring(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function "getDetailMonitoring" is a GET request that retrieves
    /// monitoring details with authorization, X-ID, and a path parameter.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other information that proves the client's identity.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   path (String): The `path` parameter is a placeholder for the actual value
    /// that will be passed in the URL path when making the GET request. It is used
    /// to specify a specific resource or endpoint that the request is targeting.
    @GET(value: GET.PATH_PARAMETER, as: MonitoringDetailResponse, error: ErrorResponse)
    void getDetailMonitoring(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function getListHarvestRealization retrieves a list of harvest
    /// realizations using the provided authorization, X-ID, and farmingCycleId.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to verify the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve the harvest
    /// realizations.
    @GET(value: 'v2/harvest-realizations', as: RealizationResponse, error: ErrorResponse)
    void getListHarvestRealization(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId) {}

    /// The function "getLeftOver" is a GET request that retrieves leftover data
    /// using the provided authorization, X-ID, and path parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// the request. It is typically used to authenticate and authorize the user
    /// making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID header in the HTTP request. It is used to pass additional
    /// identification information in the request.
    ///   path (String): The `path` parameter is a placeholder for a dynamic value
    /// that will be included in the URL path of the GET request. It is typically
    /// used to specify a specific resource or endpoint that the client wants to
    /// retrieve.
    @GET(value: GET.PATH_PARAMETER, as: LeftOverResponse, error: ErrorResponse)
    void getLeftOver(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function is a GET request that retrieves adjustment mortality data using
    /// the provided authorization, X-ID, and path parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity and
    /// permissions of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific user or session.
    ///   path (String): The `path` parameter is a placeholder for the actual value
    /// that will be passed in the URL path when making the GET request. It is used
    /// to specify a specific resource or endpoint that the request is targeting.
    @GET(value: GET.PATH_PARAMETER, as: AdjustmentMortalityResponse, error: ErrorResponse)
    void getAdjustment(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function `adjustClosing` is a PATCH request that adjusts the closing
    /// with the given authorization, X-ID, path, and data.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// the request. It is typically used to authenticate the user or client making
    /// the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID header value.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that needs to be adjusted or modified. It is typically used in
    /// RESTful APIs to identify a specific resource or endpoint.
    ///   data (String): The "data" parameter is a string that represents the data
    /// that needs to be adjusted for closing.
    @PATCH(value: PATCH.PATH_PARAMETER, error: ErrorResponse)
    @JSON(isPlaint: true)
    void adjustClosing(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data) {}

    /// The function `closeFarm` is used to send a PATCH request to a specified path
    /// with authorization and ID headers, and a data parameter.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other form of identification to verify the user's identity.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID header value.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that needs to be closed. It is a string value that represents the
    /// path of the resource.
    ///   data (String): The "data" parameter is a string that represents the data
    /// to be passed in the request body. It is used to provide additional
    /// information or payload for the "closeFarm" operation.
    @PATCH(value: PATCH.PATH_PARAMETER,  error: ErrorResponse)
    @JSON(isPlaint: true)
    void closeFarm(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data) {}
}