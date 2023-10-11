
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/historical_data_response.dart';
import 'package:model/response/latest_condition_response.dart';
import 'package:model/response/building_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

@Rest
class SmartMonitoringApi {

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
    @GET(value: 'v2/sensor/latest-condition', as: LatestConditionResponse, error: ErrorResponse)
    void getLatestCondition(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("roomId") String roomId) {}

    /// The function "realTime" is a GET request that retrieves historical data
    /// based on various parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is used to pass the
    /// authorization token for authentication purposes. It is typically included in
    /// the request header.
    ///   xId (String): The `xId` parameter is a unique identifier for the request.
    /// It is typically used for tracking or logging purposes.
    ///   sensorType (String): The sensorType parameter is used to specify the type
    /// of sensor for which you want to retrieve historical data.
    ///   farmingCycleId (int): The farmingCycleId parameter is an integer that
    /// represents the ID of the farming cycle. It is used to identify a specific
    /// farming cycle in the system.
    ///   days (String): The "days" parameter is used to specify the number of days
    /// of historical data you want to retrieve.
    ///   farmId (String): The `farmId` parameter is used to specify the ID of the
    /// farm for which you want to retrieve historical data.
    ///   coopId (String): The `coopId` parameter is used to specify the ID of the
    /// cooperative or farming cooperative associated with the request.
    ///   roomId (String): The "roomId" parameter is used to specify the ID of a
    /// room. It is likely used to retrieve historical data for a specific room
    /// within a farm or coop.
    @GET(value: "v2/historical", as: HistoricalDataResponse, error: ErrorResponse)
    void realTime(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("sensorType") String sensorType, @Query("farmingCycleId") int farmingCycleId,
                  @Query("days") String days, @Query("farmId") String farmId, @Query("coopId") String coopId, @Query("roomId") String roomId) {}

    /// The function `realTimeSmartController` is a GET request that retrieves
    /// historical data for a smart controller in a cooperative.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is used to pass the
    /// authorization token for authentication purposes. It is typically included in
    /// the request header to verify the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a unique identifier for the request.
    /// It is typically used for tracking or logging purposes.
    ///   type (String): The "type" parameter is used to specify the type of data to
    /// be retrieved from the API.
    ///   deviceId (String): The `deviceId` parameter is used to specify the ID of
    /// the device for which you want to retrieve historical data.
    ///   day (String): The "day" parameter in the above code is used to specify the
    /// date for which historical data is requested. It should be provided in the
    /// format "YYYY-MM-DD".
    ///   coopId (String): The `coopId` parameter is used to specify the ID of the
    /// cooperative for which historical data is being requested.
    ///   order (String): The "order" parameter is used to specify the order in
    /// which the historical data should be returned. It can have two possible
    /// values: "asc" for ascending order and "desc" for descending order.
    @GET(value: "v2/controller/coop/historical", as: HistoricalDataResponse, error: ErrorResponse)
    void realTimeSmartController(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("type") String type, @Query("deviceId") String deviceId,
                                 @Query("day") String day, @Query("coopId") String coopId, @Query("\$order") String order) {}

    /// The function `getListBuilding` is a GET request that retrieves a list of
    /// buildings, with authorization and ID headers, and a path parameter.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity and
    /// permissions of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific request or user.
    ///   path (String): The `path` parameter is used to specify the path of the API
    /// endpoint that you want to access. It is typically a string value that
    /// represents the specific resource or action you want to perform on the
    /// server.
    @GET(value: GET.PATH_PARAMETER, as: BuildingResponse, error: ErrorResponse)
    void getListBuilding(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}
}