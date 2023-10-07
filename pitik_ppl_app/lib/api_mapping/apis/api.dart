

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
import 'package:model/response/historical_data_response.dart';
import 'package:model/response/latest_condition_response.dart';
import 'package:model/response/profile_response.dart';
import 'package:model/response/monitoring_performance_response.dart';
// ignore: unused_import
import 'package:model/password_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

@Rest
class API {

    /// The function `getCoopActive` is a GET request that retrieves a list of
    /// active coops, with the required headers `Authorization` and `X-ID`.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header that
    /// typically contains a token or credentials to authenticate the request. It is
    /// used to verify the identity of the user making the request and determine if
    /// they have the necessary permissions to access the requested resource.
    ///   xId (String): The xId parameter is a unique identifier that is used to
    /// identify a specific user or entity in the system. It is typically used for
    /// authentication or authorization purposes.
    @GET(value: 'v2/coops/active?ignoreCache=true', as: CoopListResponse, error: ErrorResponse)
    void getCoopActive(@Header("Authorization") String authorization, @Header("X-ID") String xId) {}

    /// The function `getCoopIdle` is a GET request that retrieves a list of idle
    /// coops, with the authorization and X-ID headers provided.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header field
    /// that is used to send the authorization token or credentials required to
    /// access the API endpoint. It is typically used for authentication purposes
    /// and ensures that only authorized users can make requests to the API.
    ///   xId (String): The "X-ID" header is a custom header that is used to
    /// identify the user or client making the request. It can be any unique
    /// identifier that you want to associate with the request.
    @GET(value: 'v2/coops/idle?ignoreCache=true', as: CoopListResponse, error: ErrorResponse)
    void getCoopIdle(@Header("Authorization") String authorization, @Header("X-ID") String xId) {}

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

    /// The function "getLatestCondition" is a GET request that retrieves the latest
    /// condition with the specified headers and path parameter.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other form of authentication that allows the client to access protected
    /// resources.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific user or entity making the request.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request. It is typically
    /// used for authentication and identification purposes.
    ///   path (String): The "path" parameter is a placeholder for the specific path
    /// or endpoint that you want to access in your API. It is typically used to
    /// specify a resource or a specific action that you want to perform.
    @GET(value: GET.PATH_PARAMETER, as: LatestConditionResponse, error: ErrorResponse)
    void getLatestCondition(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// The function `getHistoricalData` is a GET request that retrieves historical
    /// data based on the provided parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is used to pass the
    /// authorization token for authentication purposes. It is typically used to
    /// verify the identity and permissions of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the ID of the user or device making the request. It is typically used for
    /// authentication or identification purposes.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request. It is typically
    /// used for authentication and identification purposes.
    ///   sensorType (String): The "sensorType" parameter is used to specify the
    /// type of sensor for which historical data is requested. It is a string value
    /// that can be used to filter the data based on the sensor type.
    ///   day (int): The "day" parameter is an integer that represents the number of
    /// days of historical data to retrieve.
    ///   path (String): The "path" parameter is not specified in the code snippet
    /// you provided. It seems to be missing or incomplete. Could you please provide
    /// more information about the "path" parameter?
    @GET(value: GET.PATH_PARAMETER, as: HistoricalDataResponse, error: ErrorResponse)
    void getHistoricalData(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("sensorType") String sensorType, @Query("days") int day ,@Path() String path) {}

    /// The function "changePassword" is used to send a PATCH request to update the
    /// password with the provided headers and parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for the request. It
    /// is typically used for authentication purposes and is used to verify the
    /// identity of the user making the request.
    ///   xid (String): The `xid` parameter is a header parameter that represents
    /// the X-ID value. It is typically used for identification purposes in the API
    /// request.
    ///   xAppId (String): The `xAppId` parameter is a header parameter that
    /// represents the X-APP-ID value. It is used to identify the application making
    /// the request.
    ///   path (String): The `path` parameter is a string that represents the path
    /// of the resource you want to update. It is typically used in PATCH requests
    /// to specify the specific resource that needs to be modified.
    ///   params (String): The "params" parameter is a string that contains the new
    /// password to be changed.
    @JSON(isPlaint: true)
    @PATCH(value: PATCH.PATH_PARAMETER, as: ProfileResponse, error: ErrorResponse)
    void changePassword(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

}
