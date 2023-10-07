
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/historical_data_response.dart';
import 'package:model/response/latest_condition_response.dart';

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
}