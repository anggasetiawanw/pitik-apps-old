
import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/camera_detail_response.dart';
import 'package:model/response/sensor_position_response.dart';
import 'package:model/response/smart_camera_day_list_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

@Rest
class SmartCameraApi {

    @GET(value: GET.PATH_PARAMETER, as: SmartCameraDayListResponse, error: ErrorResponse)
    void getSmartCameraListDay(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function `getRecordImages` is a GET request that retrieves camera detail
    /// images with the specified authorization, X-ID, X-APP-ID, path, page, and
    /// limit parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header that
    /// typically contains a token or credentials to authenticate the request. It is
    /// used to verify the identity of the user or application making the request.
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
    /// items that will be displayed per page.
    @GET(value: GET.PATH_PARAMETER, as: CameraDetailResponse, error: ErrorResponse)
    void getRecordImages(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Query("roomId") String roomId,
                         @Query("\$page") int page, @Query("\$limit") int limit) {}

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
    /// the client making the request.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the ID of the application making the request. It is typically
    /// used for authentication and identification purposes.
    ///   path (String): The "path" parameter is a placeholder for the specific path
    /// or endpoint that you want to access in your API. It is typically used to
    /// specify a resource or a specific action that you want to perform on that
    /// resource.
    @GET(value: GET.PATH_PARAMETER, as: SensorPositionResponse, error: ErrorResponse)
    void getListDataCamera(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// The function `takePictureSmartCamera` is a POST request that takes in
    /// authorization, xid, xAppId, params, and path as headers and parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user or application making the request.
    ///   xid (String): The "xid" parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the application ID. It is used to identify the application making
    /// the request.
    ///   params (String): The "params" parameter is a string that contains
    /// additional parameters or data that you want to pass to the
    /// "takePictureSmartCamera" method. It can be used to provide any extra
    /// information that is required for taking a picture with a smart camera.
    ///   path (String): The "path" parameter is a placeholder for the path of the
    /// camera detail endpoint. It is used to specify the specific camera for which
    /// the picture needs to be taken.
    @POST(value: POST.PATH_PARAMETER, as: CameraDetailResponse, error: ErrorResponse)
    @JSON(isPlaint: true)
    void takePictureSmartCamera(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}
}