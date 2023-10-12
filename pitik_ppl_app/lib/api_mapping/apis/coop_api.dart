import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/coop_list_response.dart';

@Rest
class CoopApi{
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
}