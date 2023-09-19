
import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/annotation/request/put.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/auth_response.dart';
import 'package:model/response/internal_app/customer_list_response.dart';
import 'package:model/response/internal_app/customer_response.dart';
import 'package:model/response/internal_app/profile_response.dart';

@Rest
class UserApi {

    /// `loginWithgoogle` is a `POST` request to `v2/auth/google/login` that returns an `AuthResponse` or an
    /// `Error`
    ///
    /// Args:
    ///   credentials (String): The credentials object that you get from the google sign in.
    @JSON()
    @POST(value: "v2/auth/google/login", as: AuthResponse, error: ErrorResponse)
    void loginWithgoogle(@Parameter("credentials") String credentials) {}

    /// This function will make a POST request to the URL `v2/auth` with the
    /// parameters `username` and `password` and return an `AuthResponse` object or
    /// an `Error` object.
    ///
    /// Args:
    ///   username (String): The username of the user
    ///   password (String): The password of the user
    @POST(value: "v2/auth", as: AuthResponse, error: ErrorResponse)
    @JSON()
    void login(@Parameter("username") String username, @Parameter("password") String password) {}

    /// This function will make a GET request to the URL `v2/fms-users/me` and
    /// return a `ProfileResponse` object or an `Error` object.
    ///
    /// Args:
    ///   authorization (String): The authorization header that you get from the
    /// login API.
    ///   xId (String): The unique identifier for the user.
    @GET(value: "v2/fms-users/me", as: ProfileResponse, error: ErrorResponse)
    void profile(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId) {}

    /// `createCustomer` is a POST request to `/sales/customers` with a `Authorization` header and a `X-ID`
    /// header, and a `params` parameter
    ///
    /// Args:
    ///   authorization (String): The authorization header
    ///   xid (String): The ID of the customer to be created.
    ///   params (String): The parameters to be sent to the server.
    @JSON(isPlaint: true)
    @POST(value: "v2/sales/customers", as: CustomerResponse, error: ErrorResponse)
    void createCustomer(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}

    /// It updates a customer by id.
    ///
    /// Args:
    ///   authorization (String): The value of the Authorization header.
    ///   xId (String): The header value of X-ID
    ///   path (String): The path of the request.
    ///   params (String): The parameters to be sent to the server.
    @JSON(isPlaint: true)
    @PUT(value: PUT.PATH_PARAMETER, as : CustomerResponse, error: ErrorResponse)
    void updateCustomerById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

    /// `getListCustomer` is a GET request to `/sales/customers` that returns a `ListCustomerResponse` or an
    /// `Error` and has two headers and two parameters
    ///
    /// Args:
    ///   authorization (String): The authorization token
    ///   xId (String): The ID of the user who is making the request.
    ///   page (String): The page number of the list.
    ///   limit (String): The number of items to return.
    ///
    @GET(value: "v2/sales/customers", as: ListCustomerResponse, error: ErrorResponse)
    void getListCustomer(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("\$page") int page, @Query("\$limit") int limit,) {}

    /// This function is a GET request to retrieve a list of customers without
    /// pagination.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send a token
    /// or credentials to authenticate the user making the request. It is typically
    /// used to verify the identity of the user and ensure that they have the
    /// necessary permissions to access the requested resource.
    ///   xId (String): The xId parameter is a custom header that is used to
    /// identify a specific client or user making the API request. It is typically
    /// used for tracking or auditing purposes.
    @GET(value: "v2/sales/customers", as: ListCustomerResponse, error: ErrorResponse)
    void getListCustomerWithoutPage(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId) {}

    /// `searchCustomer` is a GET request to `v2/sales/customers` that returns a `ListCustomerResponse` or
    /// an `Error` and takes a `String` `authorization` header, a `String` `xId` header, and a `String`
    /// `businessName` parameter
    ///
    /// Args:
    ///   authorization (String): The authorization token
    ///   xId (String): The ID of the business you want to search for customers in.
    ///   businessName (String): The name of the business to search for.
    @GET(value: "v2/sales/customers", as: ListCustomerResponse, error: ErrorResponse)
    void searchCustomer(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("businessName") String businessName, @Query("\$page") int page,
                        @Query("\$limit") int limit,) {}

    /// The function `searchCustomerVisit` is a GET request that searches for
    /// customer visits based on various parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header that
    /// contains the authorization token for the API request. It is used to
    /// authenticate the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the ID of the customer. It is used for authentication and authorization
    /// purposes.
    ///   xAppId (String): The `xAppId` parameter is a header parameter that
    /// represents the ID of the application making the API request. It is used for
    /// authentication and authorization purposes.
    ///   provinceId (int): The provinceId parameter is used to specify the ID of
    /// the province for which you want to search customers.
    ///   cityId (int): The `cityId` parameter is used to specify the ID of the city
    /// for which you want to search customer visits.
    ///   districtId (int): The `districtId` parameter is used to specify the ID of
    /// the district for which you want to search customer visits.
    ///   page (int): The "page" parameter is used to specify the page number of the
    /// results you want to retrieve. It is typically used for pagination purposes,
    /// where the API returns a large set of results and you want to retrieve them
    /// in smaller chunks. By specifying the page number, you can retrieve different
    /// sets of results
    ///   limit (int): The "limit" parameter is used to specify the maximum number
    /// of results to be returned per page. It determines the number of items that
    /// will be displayed on each page of the search results.
    @GET(value: "v2/sales/customers", as: ListCustomerResponse, error: ErrorResponse)
    void searchCustomerVisit(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("provinceId") int provinceId, @Query("cityId") int cityId,
                             @Query("districId") int districtId, @Query("\$page") int page, @Query("\$limit") int limit,) {}

    /// `detailCustomerById` is a `GET` request that returns a `CustomerResponse` object or an `Error`
    /// object
    ///
    /// Args:
    ///   authorization (String): The authorization header
    ///   xId (String): The header value of X-ID
    ///   path (String): The path of the request.
    @GET(value: GET.PATH_PARAMETER, as: CustomerResponse, error: ErrorResponse)
    void detailCustomerById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// `archiveCustomer` is a `PUT` request that takes a `String` path parameter, a `String` header
    /// parameter, and a `String` header parameter
    ///
    /// Args:
    ///   authorization (String): The authorization header
    ///   xId (String): The X-ID header value
    ///   path (String): The path to the resource.
    @JSON()
    @PUT(value: PUT.PATH_PARAMETER, error: ErrorResponse)
    void archiveCustomer(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

    /// `unarchiveCustomer` is a `PUT` request that takes a `String` as a path parameter, and returns a
    /// `void`
    ///
    /// Args:
    ///   authorization (String): The authorization header
    ///   xId (String): The ID of the customer to be unarchived.
    ///   path (String): The path to the resource.
    @JSON()
    @PUT(value: PUT.PATH_PARAMETER, error: ErrorResponse)
    void unarchiveCustomer(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

}