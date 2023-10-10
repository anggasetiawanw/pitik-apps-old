

import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/patch.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/coop_list_response.dart';
import 'package:model/response/profile_response.dart';
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
