
import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/patch.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/cooler_response.dart';
import 'package:model/response/detail_controller_response.dart';
import 'package:model/response/device_detail_response.dart';
import 'package:model/response/fan_detail_response.dart';
import 'package:model/response/fan_list_response.dart';
import 'package:model/response/growth_day_response.dart';
import 'package:model/response/floor_list_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 01/11/2023

@Rest
class SmartControllerApi {

    @GET(value: "v2/controller/coop", as: FloorListResponse, error: ErrorResponse)
    void getFloor(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("id") String id) {}

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
    @PATCH(value: PATCH.PATH_PARAMETER, as: DeviceDetailResponse, error: ErrorResponse)
    @JSON(isPlaint: true)
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

    /// The function "getFanDetail" is a GET request that retrieves fan details
    /// using the provided headers and path parameter.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other form of authentication that allows the server to verify the identity
    /// of the client making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used to track or identify
    /// a specific request or user.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request. It is typically
    /// used for authentication and identification purposes.
    ///   path (String): The "path" parameter is a placeholder for the specific path
    /// or identifier of the fan detail that you want to retrieve. It is typically
    /// used in the URL of the API endpoint to specify the resource you want to
    /// access.
    @GET(value: GET.PATH_PARAMETER, as: FanDetailResponse, error: ErrorResponse)
    void getFanDetail(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

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