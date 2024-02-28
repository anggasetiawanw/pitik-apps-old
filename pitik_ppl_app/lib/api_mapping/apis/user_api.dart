import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/request/delete.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/patch.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/auth_response.dart';
import 'package:model/response/profile_list_response.dart';
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
  @POST(value: 'v2/auth', as: AuthResponse, error: ErrorResponse)
  void auth(@Parameter('username') String username, @Parameter('password') String password) {}

  /// The function `register` sends a POST request to the "v2/auth/register"
  /// endpoint with various parameters for user registration.
  ///
  /// Args:
  ///   fullName (String): The `fullName` parameter is a String type representing
  /// the full name of the user registering for the authentication process.
  ///   email (String): The `email` parameter in the `register` method is used to
  /// capture the email address of the user during the registration process. This
  /// email address will be used for communication and identification purposes
  /// within the application.
  ///   phoneNumber (String): The parameters for the `register` method are as
  /// follows:
  ///   lamaUsaha (double): The parameter `lamaUsaha` represents the number of
  /// years the business has been operating.
  ///   tipeKandang (int): The parameter "tipeKandang" represents the type of
  /// coop. It is expected to be an integer value.
  ///   capacity (double): The `capacity` parameter in the `register` method
  /// represents the capacity of the coop (presumably a cooperative or a similar
  /// entity). It is of type `double`, which means it can hold a decimal value.
  /// This parameter likely indicates the maximum number of individuals or units
  /// that the coop can accommodate or
  ///   location (String): The parameters for the `register` method are as
  /// follows:
  ///   address (String): The parameters for the `register` method are as follows:
  ///   city (String): The parameter "city" refers to the region or city where the
  /// user is located. It is typically used to specify the city or town where the
  /// user's business or residence is situated.
  ///   province (String): The parameters in the `register` method are as follows:
  ///   district (String): The parameters in the `register` method are as follows:
  @POST(value: 'v2/auth/register', error: ErrorResponse)
  @JSON()
  void register(@Parameter('fullName') String fullName, @Parameter('email') String email, @Parameter('phoneNumber') String phoneNumber, @Parameter('businessYear') double businessYear, @Parameter('coopType') int coopType,
      @Parameter('coopCapacity') double capacity, @Parameter('coopLocation') String location, @Parameter('address') String address, @Parameter('region') String city, @Parameter('province') String province, @Parameter('district') String district) {}

  /// The `addDevice` function sends a POST request to add a new device with
  /// specified parameters.
  ///
  /// Args:
  ///   authorization (String): The `authorization` parameter typically contains
  /// the authentication token or credentials required to authorize the request.
  /// It is used to verify the identity of the user making the request.
  ///   xId (String): The `xId` parameter in the `addDevice` method represents the
  /// X-ID header value that is passed in the HTTP request when adding a new
  /// device. It is a unique identifier associated with the request or the device
  /// being added.
  ///   token (String): The `token` parameter is typically used to pass an
  /// authentication token or access token for authorization purposes. It is a
  /// string value that represents the token required to authenticate the request
  /// and access protected resources on the server.
  ///   type (String): The `type` parameter in the `addDevice` method represents
  /// the type of the device being added, such as "smartphone", "tablet",
  /// "laptop", etc.
  ///   os (String): The "os" parameter in the method addDevice represents the
  /// operating system of the device being added. It could be the name or version
  /// of the operating system such as "iOS", "Android", "Windows", etc.
  ///   model (String): The `model` parameter in the `addDevice` method represents
  /// the model of the device being added. This could be the specific name or
  /// number that identifies the device model, such as "iPhone X" or "Samsung
  /// Galaxy S10".
  @POST(value: 'v2/devices', error: ErrorResponse)
  @JSON()
  void addDevice(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Parameter('token') String token, @Parameter('type') String type, @Parameter('os') String os, @Parameter('model') String model) {}

  /// This function is a DELETE request to delete a device with specified headers
  /// and path parameter.
  ///
  /// Args:
  ///   authorization (String): The `authorization` parameter typically contains
  /// the authentication token or credentials required to authorize the request.
  /// This header is commonly used to authenticate the user or client making the
  /// API request.
  ///   xId (String): The `xId` parameter in the `deleteDevice` method is a header
  /// parameter with the key "X-ID". It is used to pass a specific identifier
  /// associated with the request.
  ///   path (String): The `path` parameter in the `deleteDevice` method is used
  /// as a path parameter. This means that it is a placeholder in the URL path of
  /// the API endpoint that needs to be replaced with a specific value when making
  /// the API call. The value of the `path` parameter will be provided
  @DELETE(value: DELETE.PATH_PARAMETER, error: ErrorResponse)
  void deleteDevice(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Path() String path) {}

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
  @GET(value: 'v2/fms-users/me', as: ProfileResponse, error: ErrorResponse)
  void profile(@Header('Authorization') String authorization, @Header('X-ID') String xId) {}

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
  void changePassword(@Header('Authorization') String authorization, @Header('X-ID') String xid, @Header('X-APP-ID') String xAppId, @Path() String path, @Parameter('params') String params) {}

  /// A GET request with a path parameter. The response is of type PPLInfoReponse and the error
  /// response is of type ErrorResponse.
  ///
  /// @param authorization The authorization header
  /// @param xId The unique identifier for the request.
  /// @param path The path of the API.
  @GET(value: GET.PATH_PARAMETER, as: ProfileListResponse, error: ErrorResponse)
  void pplInfo(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Path() String path) {}
}
