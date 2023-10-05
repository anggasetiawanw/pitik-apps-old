

import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/patch.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/camera_detail_response.dart';
import 'package:model/response/camera_list_response.dart';
import 'package:model/response/cooler_response.dart';
import 'package:model/response/detail_controller_response.dart';
import 'package:model/response/device_detail_response.dart';
import 'package:model/response/fan_list_response.dart';
import 'package:model/response/growth_day_response.dart';
import 'package:model/response/historical_data_response.dart';
import 'package:model/response/latest_condition_response.dart';
import 'package:model/response/profile_response.dart';
// ignore: unused_import
import 'package:model/password_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

@Rest
class API {

    /// The function "getDetailSmartMonitoring" is a GET request that retrieves
    /// device details for smart monitoring, with authorization, X-ID, X-APP-ID
    /// headers, and a path parameter.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other form of authentication that allows the server to verify the identity
    /// of the client making the request.
    ///   xId (String): The "xId" parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the application ID. It is used to identify the application making
    /// the API request.
    ///   path (String): The "path" parameter is a placeholder for the specific path
    /// or endpoint that you want to access in your API. It is typically used to
    /// specify a resource or entity that you want to retrieve or interact with.
    @GET(value: GET.PATH_PARAMETER, as: DeviceDetailResponse, error: ErrorResponse)
    void getDetailSmartMonitoring(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// The function modifies a device using the provided authorization, xid,
    /// xAppId, path, and params.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user or application making the request.
    ///   xid (String): The `xid` parameter is a header parameter that represents
    /// the X-ID value. It is typically used for identification or authentication
    /// purposes in an API request.
    ///   xAppId (String): The `xAppId` parameter is a header parameter that
    /// represents the X-APP-ID header. It is used to pass an identifier for the
    /// application making the request.
    ///   path (String): The "path" parameter in the "modifyDevice" method is a
    /// string that represents the path of the device to be modified. It is used to
    /// specify the specific device that needs to be modified.
    ///   params (String): The "params" parameter is a string that represents
    /// additional parameters or data that you want to send with the PATCH request.
    /// It can be used to provide specific instructions or information related to
    /// modifying the device.
    @JSON(isPlaint: true)
    @PATCH(value: PATCH.PATH_PARAMETER, as: DeviceDetailResponse, error: ErrorResponse)
    void modifyDevice(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

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

    /// The function `getRecordImages` is a GET request that retrieves camera detail
    /// images with the specified authorization, X-ID, X-APP-ID, path, page, and
    /// limit parameters.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other form of authentication that allows the server to verify the identity
    /// of the client making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for authentication
    /// or tracking purposes.
    ///   xAppId (String): The `xAppId` parameter is a header parameter that
    /// represents the ID of the application making the request. It is typically
    /// used for authentication and authorization purposes.
    ///   path (String): The `path` parameter is a string that represents the path
    /// to the camera record images. It is used to specify the specific camera
    /// record images that you want to retrieve.
    ///   page (int): The "page" parameter is used to specify the page number of the
    /// results you want to retrieve. It is typically used for pagination purposes,
    /// allowing you to retrieve a specific page of results from a larger set of
    /// data.
    ///   limit (int): The "limit" parameter is used to specify the maximum number
    /// of records to be returned in a single response. It determines the number of
    /// items to be displayed per page or request.
    @GET(value: GET.PATH_PARAMETER, as: CameraDetailResponse, error: ErrorResponse)
    void getRecordImages(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Query("\$page") int page, @Query("\$limit") int limit) {}

    /// This function is a GET request that retrieves a list of camera data with the
    /// specified headers and path parameter.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is used to pass the
    /// authentication token or credentials required to access the API endpoint. It
    /// is typically included in the request headers and is used to verify the
    /// identity of the user making the request.
    ///   xId (String): The "xId" parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific user or device making the request.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request. It is typically
    /// used for authentication and identification purposes.
    ///   path (String): The "path" parameter is a placeholder for the specific path
    /// or endpoint that you want to access in your API. It is typically used in
    /// combination with the base URL of the API to form the complete URL for the
    /// request.
    @GET(value: GET.PATH_PARAMETER, as: CameraListResponse, error: ErrorResponse)
    void getListDataCamera(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// The function "takePictureSmartCamera" is a POST request that takes in
    /// authorization, xid, xAppId, params, and path as parameters and returns a
    /// CameraDetailResponse or an ErrorResponse.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is used to pass the
    /// authentication token or credentials required to access the API. It is
    /// typically included in the request header.
    ///   xid (String): The "xid" parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   xAppId (String): The `xAppId` parameter is a header parameter that
    /// represents the X-APP-ID value. It is used to identify the application making
    /// the request.
    ///   params (String): The "params" parameter is a string that contains
    /// additional parameters or data that you want to pass to the API endpoint. It
    /// can be used to provide specific instructions or configuration options for
    /// the "takePictureSmartCamera" method.
    ///   path (String): The "path" parameter is a placeholder for the path of the
    /// camera detail endpoint. It is used to specify the specific camera for which
    /// the picture needs to be taken.
    @JSON(isPlaint: true)
    @POST(value: POST.PATH_PARAMETER, as: CameraDetailResponse, error: ErrorResponse)
    void takePictureSmartCamera(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params, @Path() String path) {}

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

    /// The function "getDetailSmartController" is a GET request that retrieves
    /// detailed information using the provided headers and path parameter.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other information that proves the client's identity.
    ///   xId (String): The "X-ID" header is used to pass a unique identifier for
    /// the request. It can be used to track or identify the request in some way.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request.
    ///   path (String): The "path" parameter is a placeholder for the dynamic part
    /// of the URL path. It is used to specify a specific resource or entity that
    /// the client wants to retrieve or interact with.
    @GET(value: GET.PATH_PARAMETER, as: DetailControllerResponse, error: ErrorResponse)
    void getDetailSmartController(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// The function `getDataGrowthDay` is a GET request that retrieves data related
    /// to growth day, with authorization, ID, and app ID headers, and a path
    /// parameter.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is typically used to
    /// send authentication credentials, such as a token or API key, to the server.
    /// It is used to verify the identity of the client making the request.
    ///   xId (String): The "xId" parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific user or session.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request.
    ///   path (String): The "path" parameter is a placeholder for the specific path
    /// or endpoint that you want to access in your API. It is typically used in
    /// combination with the base URL of the API to form the complete URL for the
    /// request.
    @GET(value: GET.PATH_PARAMETER, as: GrowthDayResponse, error: ErrorResponse)
    void getDataGrowthDay(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// The function sets a controller using the provided authorization, xid,
    /// xAppId, path, and params.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for authentication
    /// purposes. It is typically used to verify the identity and permissions of the
    /// user making the request.
    ///   xid (String): The `xid` parameter is a header parameter that represents
    /// the X-ID value. It is used to provide additional identification or context
    /// information in the request.
    ///   xAppId (String): The `xAppId` parameter is a header parameter that
    /// represents the X-APP-ID value. It is used to provide an identifier for the
    /// application making the request.
    ///   path (String): The "path" parameter is a string that represents the path
    /// of the resource you want to update. It is typically used in PATCH requests
    /// to specify the specific resource that needs to be updated.
    ///   params (String): The "params" parameter is a string that represents
    /// additional parameters or data that you want to send with the PATCH request.
    /// It can be used to provide any additional information that is required for
    /// the operation.
    @JSON(isPlaint: true)
    @PATCH(value: PATCH.PATH_PARAMETER, as: DeviceDetailResponse, error: ErrorResponse)
    void setController(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

    /// The function "getFanData" is a GET request that retrieves fan data using the
    /// provided authorization, xId, xAppId, and path parameters.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other form of authentication that allows the server to verify the identity
    /// of the client making the request.
    ///   xId (String): The "xId" parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific user or entity making the request.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request. It is typically
    /// used for authentication and identification purposes.
    ///   path (String): The "path" parameter is a placeholder for the specific path
    /// or endpoint that you want to access in your API. It is typically used in
    /// combination with the base URL of the API to form the complete URL for the
    /// request.
    @GET(value: GET.PATH_PARAMETER, as: FanListResponse, error: ErrorResponse)
    void getFanData(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// The getCoolerData function is a GET request that retrieves cooler data using
    /// the provided headers and path parameter.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is typically used to
    /// send a token or credentials to authenticate the request. It is used to
    /// verify the identity of the client making the request.
    ///   xId (String): The "xId" parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific request or user.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request. It is typically
    /// used for authentication and identification purposes.
    ///   path (String): The "path" parameter is a placeholder for the actual path
    /// value that you want to include in the GET request. It is typically used to
    /// specify a specific resource or endpoint on the server that you want to
    /// retrieve data from.
    @GET(value: GET.PATH_PARAMETER, as: CoolerResponse, error: ErrorResponse)
    void getCoolerData(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}


}
