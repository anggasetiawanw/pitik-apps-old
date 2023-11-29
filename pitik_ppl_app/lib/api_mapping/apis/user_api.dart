

import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/patch.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/auth_response.dart';
import 'package:model/response/profile_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

@Rest
class UserApi {

    /// The `auth` function is a POST request to the "/v2/auth" endpoint that takes
    /// a JSON string as a parameter and expects an `AuthResponse` object as a
    /// response, or an `ErrorResponse` object in case of an error.
    ///
    /// Args:
    ///   params (String): The "params" parameter is a string that contains the
    /// authentication parameters required for the authentication process.
    @JSON()
    @POST(value: "v2/auth", as: AuthResponse, error: ErrorResponse)
    void auth(@Parameter("username") String username, @Parameter("password") String password) {}

    @POST(value: "v2/devices", error: ErrorResponse)
    @JSON()
    void addDevice(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Parameter("token") String token, @Parameter("type") String type, @Parameter("os") String os,
                   @Parameter("model") String model) {}

    /// The function "profile" is a GET request that retrieves member information
    /// with the specified headers and parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is used to pass the
    /// authentication token or credentials required to access the API endpoint. It
    /// is typically included in the request header.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the ID of the user making the request. It is typically used for
    /// authentication or identification purposes.
    ///   xAppId (String): The xAppId parameter is a header parameter that
    /// represents the application ID. It is used to identify the application making
    /// the API request.
    ///   params (String): The "params" parameter is a string that contains
    /// additional parameters for the API request. It is used to pass any extra
    /// information or filters that are required for the "profile" API endpoint.
    @GET(value: "v2/fms-users/me", as: ProfileResponse, error: ErrorResponse)
    void profile(@Header("Authorization") String authorization, @Header("X-ID") String xId) {}

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

    @GET(value: "v2/notifications/unread/count", error: ErrorResponse)
    void countUnreadNotifications(@Header("Authorization") String authorization, @Header("X-ID") String xId) {}
}