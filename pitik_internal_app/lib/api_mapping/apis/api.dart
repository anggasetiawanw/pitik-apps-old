// ignore_for_file: unused_import

import 'dart:io';

import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/mediatype/multipart.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/annotation/request/put.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/manufacture_output_model.dart';
import 'package:model/response/branch_response.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/checkin_response.dart';
import 'package:model/response/internal_app/good_receive_response.dart';
import 'package:model/response/internal_app/list_driver_response.dart';
import 'package:model/response/internal_app/list_opnames_response.dart';
import 'package:model/response/internal_app/list_terminate_response.dart';
import 'package:model/response/internal_app/location_list_response.dart';
import 'package:model/response/internal_app/manufacture_list_response.dart';
import 'package:model/response/internal_app/manufacture_output_list_response.dart';
import 'package:model/response/internal_app/manufacture_response.dart';
import 'package:model/response/internal_app/media_upload_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/opname_response.dart';
import 'package:model/response/internal_app/order_issue_response.dart';
import 'package:model/response/internal_app/order_response.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:model/response/internal_app/purchase_list_response.dart';
import 'package:model/response/internal_app/purchase_response.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:model/response/internal_app/salesperson_list_response.dart';
import 'package:model/response/internal_app/stock_aggregate_list_response.dart';
import 'package:model/response/internal_app/terminate_response.dart';
import 'package:model/response/internal_app/transfer_list_response.dart';
import 'package:model/response/internal_app/transfer_response.dart';
import 'package:model/response/internal_app/vendor_list_response.dart';
import 'package:model/response/internal_app/visit_customer_response.dart';
import 'package:model/response/internal_app/visit_list_customer_response.dart';

@Rest
class API {
  // static const String BASE_URL = "https://api.pitik.dev/";

  /// A POST request with a path parameter.
  ///
  /// Args:
  ///   authorization (String): The authorization header
  ///   xid (String): The unique id of the user.
  ///   path (String): The path of the request.
  ///   params (String): The parameters to be sent to the server.
  @JSON(isPlaint: true)
  @POST(value: POST.PATH_PARAMETER, as: CheckInResponse, error: ErrorResponse)
  void visitCheckin(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  /// It creates a new visit.
  ///
  /// Args:
  ///   authorization (String): The authorization header
  ///   xId (String): The ID of the user.
  ///   path (String): The path of the request.
  ///   params (String): The parameters to be sent to the server.
  @JSON(isPlaint: true)
  @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
  void createNewVisit(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  /// `getListVisitById` is a `GET` request that returns a `VisitCustomerResponse` object or an `Error` object
  ///
  /// Args:
  ///   authorization (String): The authorization header
  ///   xId (String): The ID of the user
  ///   path (String): The path of the request.
  @GET(value: GET.PATH_PARAMETER, as: VisitCustomerResponse, error: ErrorResponse)
  void getListVisitById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  /// `getListVisit` is a GET request that returns a `ListVisitCustomerResponse` object or an `Error`
  /// object
  ///
  /// Args:
  ///   authorization (String): The authorization header
  ///   xId (String): The ID of the user who is making the request.
  ///   path (String): The path of the API.
  @GET(value: GET.PATH_PARAMETER, as: ListVisitCustomerResponse, error: ErrorResponse)
  void getListVisit(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("\$page") int page, @Query("\$limit") int limit, @Path() String path) {}

  /// This is a Dart function that sends a GET request to retrieve a list of
  /// provinces, with authorization and X-ID headers.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send
  /// authentication credentials to the server. It typically contains a token or
  /// other form of authentication that allows the client to access protected
  /// resources on the server.
  ///   xId (String): The xId parameter is a custom header that is being passed in
  /// the GET request. It is likely used to identify a specific user or device
  /// making the request. The purpose of this header may vary depending on the
  /// specific implementation of the API.
  @GET(value: "v2/provinces", as: LocationListResponse, error: ErrorResponse)
  void getProvince(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
  ) {}

  /// `getCity` is a GET request to `v2/cities` with a query parameter `provinceId` and returns a
  /// `CityListResponse` or an `Error`
  ///
  /// Args:
  ///   provinceId (String): The province ID.
  @GET(value: "v2/cities", as: LocationListResponse, error: ErrorResponse)
  void getCity(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("provinceId") String provinceId) {}

  /// `getDistrict` is a GET request to `v2/districts` that returns a `DistrictListResponse` or an `Error`
  /// object
  ///
  /// Args:
  ///   cityId (String): The city ID for which you want to get the districts.
  @GET(value: "v2/districts", as: LocationListResponse, error: ErrorResponse)
  void getDistrict(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("cityId") String cityId) {}

  /// This function sends a GET request to retrieve order issue categories with
  /// authorization and X-ID headers.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send
  /// authentication credentials to the server. It typically contains a token or a
  /// username and password combination that the server uses to verify the
  /// identity of the client making the request. In this case, it is likely that
  /// the "Authorization" header contains a token that is used
  ///   xId (String): The xId parameter is a custom header that is used to
  /// identify a specific request or transaction. It is typically used for
  /// tracking purposes or to provide additional context for the request.
  @GET(value: "v2/sales/order-issue-categories/", as: OrderIssueResponse, error: ErrorResponse)
  void getOrderIssueCategories(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
  ) {}

  /// This function sends a GET request to retrieve a list of product categories
  /// with authorization and X-ID headers.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a token
  /// or credentials to authenticate the user making the API request. This header
  /// is commonly used in APIs that require authentication or authorization to
  /// access protected resources.
  ///   xId (String): The "X-ID" header is a custom header that is used to
  /// identify a specific client or user making the API request. It is likely that
  /// this value is generated by the client or user and is used by the server to
  /// track and manage requests from different clients or users.
  @GET(value: "v2/sales/product-categories/", as: CategoryListResponse, error: ErrorResponse)
  void getCategories(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId) {}

  /// This function sends a GET request to retrieve a list of products based on a
  /// specified category ID, with authorization and X-ID headers.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a token
  /// or credentials to authenticate the user making the API request. It is
  /// typically used to ensure that only authorized users can access the protected
  /// resources of the API.
  ///   String: The String parameters in this method are:
  ///   categoryId (String): The "categoryId" parameter is a query parameter that
  /// is used to filter the products by their category. It is an optional
  /// parameter that can be passed in the request URL to retrieve a list of
  /// products that belong to a specific category.
  @GET(value: "v2/sales/products/", as: ProductListResponse, error: ErrorResponse)
  void getProductById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("categoryId") String categoryId) {}

  /// This function sends a GET request to retrieve a list of salespeople with the
  /// specified user type, page number, and limit.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that allow the server to verify the user's identity and
  /// permissions.
  ///   xId (String): "xId" is a custom header parameter that is used to identify
  /// a specific user or client making the API request. It is usually a unique
  /// identifier that is assigned to each user or client by the server.
  ///   userType (String): The userType parameter is a query parameter that
  /// specifies the type of user for which the salesperson list is being
  /// requested. It is likely an enum or string value that can take on different
  /// values such as "salesperson", "manager", "admin", etc.
  ///   page (int): The "page" parameter is used to specify the page number of the
  /// results to be returned. It is typically used in conjunction with the "limit"
  /// parameter to paginate through a large set of results.
  ///   limit (int): The "limit" parameter is used to specify the maximum number
  /// of results to be returned in a single page of the response. It is used for
  /// pagination purposes.
  @GET(value: "v2/fms-users", as: SalespersonListResponse, error: ErrorResponse)
  void getSalesList(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("userTypes") String userType, @Query("\$page") int page, @Query("\$limit") int limit) {}

  /// This is a Dart function that sends a GET request to retrieve a list of
  /// purchase orders with authorization and pagination parameters.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that allow the server to verify the user's identity and
  /// permissions.
  ///   xId (String): The xId parameter is a custom header that is used to
  /// identify a specific client or user making the API request. It is often used
  /// for tracking or auditing purposes.
  ///   page (int): The "page" parameter is used to specify the page number of the
  /// results to be returned. It is typically used in conjunction with the "limit"
  /// parameter to paginate through a large set of results. For example, if there
  /// are 100 results and the limit is set to 10, then there
  ///   limit (int): The "limit" parameter is used to specify the maximum number
  /// of items to be returned in a single page of the response. It is used for
  /// pagination purposes.
  @GET(value: "v2/sales/purchase-orders", as: ListPurchaseResponse, error: ErrorResponse)
  void getPurchaseOrderList(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
    @Query("code") String code,
    @Query("createdDate") String createdDate,
    @Query("productCategoryId") String productCategoryId,
    @Query("productItemId") String productItemId,
    @Query("operationUnitId") String operationUnitId,
    @Query("vendorId") String vendorId,
    @Query("jagalId") String jagalId,
    @Query("status") String status,
    @Query("source") String source,
  ) {}

  /// This is a Dart function that sends a GET request to retrieve a list of
  /// purchase orders for good receipts, with authorization and pagination
  /// parameters.
  ///
  /// Args:
  ///   authorization (String): This is a header parameter that is used for
  /// authentication purposes. It is likely a token or key that is used to verify
  /// the identity of the user making the API request.
  ///   xId (String): The xId parameter is a header parameter that is used to
  /// identify a specific resource or entity in the system. It is usually a unique
  /// identifier that is assigned to the resource or entity when it is created.
  ///   page (int): The page parameter is used to specify the page number of the
  /// results to be returned. It is typically used in conjunction with the limit
  /// parameter to paginate through a large set of results.
  ///   limit (int): The "limit" parameter is used to specify the maximum number
  /// of items to be returned in a single page of the response. It is used for
  /// pagination purposes.
  ///   status (String): The "status" parameter is used to filter the purchase
  /// orders based on their status. It is a string parameter that can take values
  /// like "draft", "open", "closed", "cancelled", etc. depending on the possible
  /// status values defined in the API documentation.
  @GET(value: "v2/sales/purchase-orders", as: ListPurchaseResponse, error: ErrorResponse)
  void getGoodReceiptPOList(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
    @Query("status") String statusConfirmed,
    @Query("status") String statusReceived,
    @Query("withinProductionTeam") String withinProductionTeam,
    @Query("createdDate") String createdDate,
    @Query("productCategoryId") String productCategoryId,
    @Query("productItemId") String productItemId,
    @Query("operationUnitId") String operationUnitId,
    @Query("vendorId") String vendorId,
    @Query("jagalId") String jagalId,
    @Query("status") String status,
    @Query("source") String source,
    @Query("code") String code,
  ) {}

  /// This is a Dart function that retrieves details of a purchase by its ID, with
  /// authorization and error handling.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that are used to verify the user's identity and permissions.
  ///   String: The "String" data type is used to represent a sequence of
  /// characters (text) in Java. In this case, the method parameter
  /// "authorization" and "path" are both of type String. "authorization" is used
  /// to pass the authorization token in the header of the HTTP request, while "
  ///   path (String): The "path" parameter in this method is a placeholder for a
  /// path parameter in the URL. Path parameters are used to identify a specific
  /// resource in a RESTful API. For example, if the URL is "/purchases/123",
  /// "123" would be the path parameter that identifies the specific purchase
  @GET(value: GET.PATH_PARAMETER, as: PurchaseResponse, error: ErrorResponse)
  void detailPurchaseById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  /// This function cancels a purchase with the given authorization, xId, and path
  /// parameters.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to send a token
  /// or credentials to authenticate the user making the request. It is typically
  /// used to ensure that only authorized users can access the protected resources
  /// on the server.
  ///   xId (String): The xId parameter is a custom header that is being passed in
  /// the cancelPurchase() method. It is used to identify a specific transaction
  /// or request and can be used for tracking or auditing purposes.
  ///   path (String): The "path" parameter is a placeholder for a specific value
  /// that will be passed in the URL path of the API endpoint. It is annotated
  /// with the "@Path" annotation, which indicates that the value will be
  /// extracted from the URL path and passed as an argument to the method.
  @JSON()
  @PUT(value: PUT.PATH_PARAMETER, error: ErrorResponse)
  void cancelPurchase(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  /// This function sends a GET request to retrieve a list of vendors with a
  /// specified status, using authorization and X-ID headers.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a
  /// token or credentials to authenticate the user making the API request. This
  /// header is typically used to authenticate the user with the server and grant
  /// access to protected resources.
  ///   xId (String): "xId" is a custom header parameter that is used to identify
  /// a specific client or user making the API request. It is likely that this
  /// value is generated by the client application and passed along with the API
  /// request to help the server identify the source of the request.
  ///   status (String): The "status" parameter is a query parameter that can be
  /// passed in the URL to filter the list of vendors based on their status. The
  /// value of this parameter can be "active", "inactive", or "all" to retrieve
  /// vendors with the corresponding status.
  @GET(value: "v2/sales/vendors", as: VendorListResponse, error: ErrorResponse)
  void getListVendors(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("status") String status) {}

  /// This is a Dart function that makes a GET request to retrieve a list of
  /// customer responses and error responses related to sales operations.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a token
  /// or credentials to authenticate the user making the request. It is typically
  /// used to verify the identity of the user and ensure that they have the
  /// necessary permissions to access the requested resource.
  ///   xId (String): The xId parameter is a header parameter that is used to
  /// identify a specific resource or operation in the API. It is usually a unique
  /// identifier that is assigned to a particular request or session. In this
  /// case, it is being used as a header parameter for authentication purposes.
  @GET(value: "v2/sales/operation-units", as: ListOperationUnitsResponse, error: ErrorResponse)
  void getListJagalExternal(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("status") String status, @Query("type") String type, @Query("category") String category) {}

  /// This function creates a purchase order with authorization, x-id, and
  /// parameters.
  ///
  /// Args:
  ///   authorization (String): The authorization parameter is a header that is
  /// used to authenticate the user making the API request. It typically contains
  /// a token or other credentials that are used to verify the user's identity and
  /// permissions.
  ///   xid (String): The "X-ID" header is a custom header that is used to pass a
  /// unique identifier for the request. It can be used for tracking purposes or
  /// to correlate requests and responses.
  ///   params (String): The "params" parameter is a string that contains the
  /// necessary data to create a purchase order. It could include information such
  /// as the customer's name and address, the items being purchased, the quantity
  /// of each item, and the total cost of the order. The format of the string may
  /// depend on the
  @JSON(isPlaint: true)
  @POST(value: "v2/sales/purchase-orders", as: PurchaseResponse, error: ErrorResponse)
  void createPurchase(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}

  /// This is a Dart function for editing a purchase with JSON data and
  /// authorization headers.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to send a token
  /// or credentials to authenticate the user making the request.
  ///   xid (String): The "X-ID" header is a custom header that may be used to
  /// pass an identifier or token for the request. It is likely used for
  /// authentication or authorization purposes.
  ///   path (String): The "path" parameter in this method is a string variable
  /// that represents the path of the resource being edited. It is used as a
  /// parameter in the PUT request to specify the location of the resource that
  /// needs to be updated.
  ///   params (String): The "params" parameter is a string that contains the data
  /// to be edited for a purchase. It is likely in JSON format and includes
  /// information such as the purchase ID, the new purchase details, and any other
  /// relevant information needed to update the purchase.
  @JSON(isPlaint: true)
  @PUT(value: PUT.PATH_PARAMETER, error: ErrorResponse)
  void editPurchase(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  /// This is a Dart function that sends a GET request to retrieve a list of sales
  /// orders with authorization, X-ID, page, and limit parameters.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that are used to verify the user's identity and permissions.
  ///   xId (String): "xId" is a custom header parameter that is used to identify
  /// a specific user or client making the API request. It is usually used for
  /// tracking and auditing purposes.
  ///   page (int): The "page" parameter is used to specify the page number of the
  /// results to be returned. This is typically used in conjunction with the
  /// "limit" parameter to paginate through a large set of results.
  ///   limit (int): The "limit" parameter is used to specify the maximum number
  /// of results that should be returned in a single page of the sales order list.
  @GET(value: "v2/sales/sales-orders", as: SalesOrderListResponse, error: ErrorResponse)
  void getListOrders(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("\$page") int page, @Query("\$limit") int limit, @Query("status") String statusDraft, @Query("status") String statusConfirmed, @Query("status") String statusBooked, @Query("status") String statusReadyDeliver, @Query("status") String statusDelivered, @Query("status") String statusCancel, @Query("status") String statusRejected,
      @Query("status") String statusOnDelivery, @Query("status") String statusAllocated) {}

  /// This is a Dart function that sends a GET request to retrieve a list of sales
  /// orders with authorization, X-ID, page, and limit parameters.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that are used to verify the user's identity and permissions.
  ///   xId (String): "xId" is a custom header parameter that is used to identify
  /// a specific user or client making the API request. It is usually used for
  /// tracking and auditing purposes.
  ///   page (int): The "page" parameter is used to specify the page number of the
  /// results to be returned. This is typically used in conjunction with the
  /// "limit" parameter to paginate through a large set of results.
  ///   limit (int): The "limit" parameter is used to specify the maximum number
  /// of results that should be returned in a single page of the sales order list.
  @GET(value: "v2/sales/sales-orders", as: SalesOrderListResponse, error: ErrorResponse)
  void getListOrdersFilter(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
    @Query("customerId") String customerId,
    @Query("salespersonId") String salesPersonId,
    @Query("driverId") String driverId,
    @Query("status") String status,
    @Query("code") String code,
    @Query("sameBranch") bool sameBranch,
    @Query("withinProductionTeam") bool withinProductionTeam,
    @Query("customerCityId") int customerCityId,
    @Query("customerProvinceId") int customerProvinceId,
    @Query("customerName") String customerName,
    @Query("date") String date,
    @Query("minQuantityRange") int minQuantityRange,
    @Query("maxQuantityRange") int maxRangeQuantity,
    @Query("createdBy") String createdBy,
    @Query("category") String category,
    @Query("withinSalesTeam") String withinSalesTeam,
    @Query("operationUnitId") String operationUnitId,
    @Query("productItemId") String productItemId,
    @Query("productCategoryId") String productCategoryId,
    @Query("status") String statusDraft,
    @Query("status") String statusConfirmed,
    @Query("status") String statusBooked,
    @Query("status") String statusReadyDeliver,
    @Query("status") String statusDelivered,
    @Query("status") String statusCancel,
    @Query("status") String statusRejected,
    @Query("status") String statusOnDelivery,
    @Query("status") String statusAllocated,
    @Query("branchId") String branchId,
    @Query("minDeliveryTime") String minDeliveryTime,
    @Query("maxDeliveryTime") String maxDeliveryTime,
  ) {}

  /// This is a Dart function that makes a GET request to retrieve a list of
  /// customer responses and error responses related to sales operations.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a token
  /// or credentials to authenticate the user making the request. It is typically
  /// used to verify the identity of the user and ensure that they have the
  /// necessary permissions to access the requested resource.
  ///   xId (String): The xId parameter is a header parameter that is used to
  /// identify a specific resource or operation in the API. It is usually a unique
  /// identifier that is assigned to a particular request or session. In this
  /// case, it is being used as a header parameter for authentication purposes.
  @GET(value: "v2/sales/operation-units", as: ListOperationUnitsResponse, error: ErrorResponse)
  void getListOperationUnits(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("status") String status, @Query("category") String category, @Query("withinProductionTeam") String withinProductionTeam, @Query("\$limit") int limit) {}

  /// This is a Dart function that makes a GET request to retrieve a list of
  /// customer responses and error responses related to sales operations.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a token
  /// or credentials to authenticate the user making the request. It is typically
  /// used to verify the identity of the user and ensure that they have the
  /// necessary permissions to access the requested resource.
  ///   xId (String): The xId parameter is a header parameter that is used to
  /// identify a specific resource or operation in the API. It is usually a unique
  /// identifier that is assigned to a particular request or session. In this
  /// case, it is being used as a header parameter for authentication purposes.
  @GET(value: "v2/sales/operation-units", as: ListOperationUnitsResponse, error: ErrorResponse)
  void getListDestionTransfer(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("status") String status, @Query("category") String category) {}

  /// This is a Dart function that makes a GET request to retrieve a list of sales
  /// orders with specific parameters.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that allow the server to verify the user's identity and
  /// permissions.
  ///   xId (String): The xId parameter is a header parameter that is used to
  /// identify a specific user or client making the API request. It is often used
  /// for tracking and auditing purposes.
  ///   page (int): The "page" parameter is used to specify the page number of the
  /// results to be returned. It is typically used in conjunction with the "limit"
  /// parameter to paginate through a large set of results.
  ///   limit (int): The "limit" parameter is used to specify the maximum number
  /// of results that should be returned in a single response page. It is used in
  /// conjunction with the "page" parameter to paginate the results of the API
  /// call.
  ///   status (String): The "status" parameter is used to filter the sales orders
  /// based on their status. It is passed as a query parameter in the GET request
  /// to the endpoint "v2/sales/sales-orders". The value of this parameter is a
  /// string that represents the status of the sales orders that need to be
  ///   statusReceived (String): The "statusReceived" parameter is not a valid
  /// parameter in this API call. It seems to be a duplicate of the "status"
  /// parameter. You may want to remove it or use a different parameter name if
  /// you need to pass additional information related to the status of the sales
  /// orders.
  @GET(value: "v2/sales/sales-orders", as: SalesOrderListResponse, error: ErrorResponse)
  void getGoodReceiptsOrderList(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
    @Query("grStatus") String grStatusReceived,
    @Query("grStatus") String grStatusRejected,
    @Query("category") String category,
    @Query("withinProductionTeam") bool withinProductionTeam,
    @Query("date") String date,
    @Query("productCategoryId") String productCategoryId,
    @Query("productItemId") String productItemId,
    @Query("operationUnitId") String operationUnitId,
    @Query("status") String status,
    @Query("returnStatus") String returnStatus,
    @Query("code") String code,


  ) {}

  /// This is a Dart function that cancels an order using HTTP PUT method with
  /// authorization and path parameters.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to send a token
  /// or credentials to authenticate the user making the request. It is typically
  /// used to ensure that only authorized users can access the protected resources
  /// on the server.
  ///   xId (String): The xId parameter is a custom header that is used to
  /// identify a specific request or transaction. It is usually generated by the
  /// client and sent along with the request to the server. In this case, it is
  /// being passed as a parameter to the cancelOrder() method along with the
  /// authorization header and a
  ///   path (String): The "path" parameter is a placeholder for a specific value
  /// that will be passed in the URL path of the API endpoint. It is annotated
  /// with the "@Path" annotation, which indicates that the value will be
  /// extracted from the URL path and passed as an argument to the method.
  // @JSON(isPlaint: true)
  @POST(value: PUT.PATH_PARAMETER, error: ErrorResponse)
  void cancelOrder(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  /// `createCustomer` is a POST request to `/sales/customers` with a `Authorization` header and a `X-ID`
  /// header, and a `params` parameter
  ///
  /// Args:
  ///   authorization (String): The authorization header
  ///   xid (String): The ID of the customer to be created.
  ///   params (String): The parameters to be sent to the server.
  @JSON(isPlaint: true)
  @POST(value: "v2/sales/manufactures", as: ManufactureResponse, error: ErrorResponse)
  void createManufacture(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}

  /// It updates a customer by id.
  ///
  /// Args:
  ///   authorization (String): The value of the Authorization header.
  ///   xId (String): The header value of X-ID
  ///   path (String): The path of the request.
  ///   params (String): The parameters to be sent to the server.
  @JSON(isPlaint: true)
  @PUT(value: PUT.PATH_PARAMETER, as: ManufactureResponse, error: ErrorResponse)
  void updateManufactureById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  /// `getListCustomer` is a GET request to `/sales/customers` that returns a `ListCustomerResponse` or an
  /// `Error` and has two headers and two parameters
  ///
  /// Args:
  ///   authorization (String): The authorization token
  ///   xId (String): The ID of the user who is making the request.
  ///   page (String): The page number of the list.
  ///   limit (String): The number of items to return.
  ///
  @GET(value: "v2/sales/manufactures", as: ListManufactureResponse, error: ErrorResponse)
  void getListManufacture(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
  ) {}

  /// `detailCustomerById` is a `GET` request that returns a `CustomerResponse` object or an `Error`
  /// object
  ///
  /// Args:
  ///   authorization (String): The authorization header
  ///   xId (String): The header value of X-ID
  ///   path (String): The path of the request.
  @GET(value: GET.PATH_PARAMETER, as: ManufactureResponse, error: ErrorResponse)
  void detailManufactureById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  /// This is a Dart function that makes a GET request to retrieve a list of
  /// customer responses and error responses related to sales operations.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a token
  /// or credentials to authenticate the user making the request. It is typically
  /// used to verify the identity of the user and ensure that they have the
  /// necessary permissions to access the requested resource.
  ///   xId (String): The xId parameter is a header parameter that is used to
  /// identify a specific resource or operation in the API. It is usually a unique
  /// identifier that is assigned to a particular request or session. In this
  /// case, it is being used as a header parameter for authentication purposes.
  @GET(value: GET.PATH_PARAMETER, as: ListStockAggregateResponse, error: ErrorResponse)
  void getListStockAggregateByUnit(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  @GET(value: GET.PATH_PARAMETER, as: ListStockAggregateResponse, error: ErrorResponse)
  void getLatestStockOpname(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Query("productCategoryId") String productCategoryId) {}

  /// This is a Dart function that makes a GET request to retrieve a list of
  /// customer responses and error responses related to sales operations.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a token
  /// or credentials to authenticate the user making the request. It is typically
  /// used to verify the identity of the user and ensure that they have the
  /// necessary permissions to access the requested resource.
  ///   xId (String): The xId parameter is a header parameter that is used to
  /// identify a specific resource or operation in the API. It is usually a unique
  /// identifier that is assigned to a particular request or session. In this
  /// case, it is being used as a header parameter for authentication purposes.
  @GET(value: GET.PATH_PARAMETER, as: ListManufactureOutputResponse, error: ErrorResponse)
  void getListManufactureOutput(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  /// This function creates a sales order using authorization, X-ID, and
  /// parameters.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that are used to verify the user's identity and permissions.
  ///   xid (String): The "X-ID" header is a custom header that is used to pass a
  /// unique identifier for the request. It can be used for tracking and logging
  /// purposes.
  ///   params (String): The "params" parameter is a string that contains the
  /// necessary information to create a sales order. It could include details such
  /// as the customer information, product information, pricing, and shipping
  /// information. The format of the string may depend on the API's
  /// specifications.
  @JSON(isPlaint: true)
  @POST(value: "v2/sales/sales-orders", as: OrderResponse, error: ErrorResponse)
  void createSalesOrder(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}

  /// This function retrieves details of an order by its ID, with authorization
  /// and error handling.
  ///
  /// Args:
  ///   authorization (String): The "Authorization" header is used to send a token
  /// or credentials to authenticate the user making the request. This header is
  /// typically used in API requests that require authentication or authorization.
  ///   String: The "String" data type is used to represent a sequence of
  /// characters (text) in Java. In this case, the method parameter
  /// "authorization" and "path" are both of type String. "authorization" is used
  /// to pass the authorization token in the header of the HTTP request, while "
  ///   path (String): The "path" parameter in this method is a placeholder for a
  /// path variable that will be passed in the URL. It is used to specify the ID
  /// of the order that the user wants to retrieve details for. The actual value
  /// of the path variable will be passed as an argument when the method is called
  @GET(value: GET.PATH_PARAMETER, as: OrderResponse, error: ErrorResponse)
  void detailOrderById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  @POST(value: "v2/upload", as: MediaUploadResponse, error: ErrorResponse)
  @Multipart()
  void uploadImage(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("folder") String folder, @Parameter("file") File file) {}

  @JSON(isPlaint: true)
  @POST(value: "v2/sales/stock-disposals", as: TerminateResponse, error: ErrorResponse)
  void createTerminate(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}

  @JSON(isPlaint: true)
  @PUT(value: PUT.PATH_PARAMETER, as: TerminateResponse, error: ErrorResponse)
  void updateTerminateById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  @GET(value: "v2/sales/stock-disposals", as: ListTerminateResponse, error: ErrorResponse)
  void getListTerminate(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
  ) {}

  @GET(value: GET.PATH_PARAMETER, as: TerminateResponse, error: ErrorResponse)
  void detailTerminateById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  ///
  @GET(value: "v2/sales/internal-transfers", as: ListTransferResponse, error: ErrorResponse)
  void getListInternalTransfer(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
  ) {}

  /// This is a Dart function that makes a GET request to retrieve a list of
  /// internal transfers with pagination and filtering options.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that allow the server to verify the user's identity and
  /// permissions.
  ///   xId (String): "xId" is a custom header parameter that is used to identify
  /// the client making the request. It is usually a unique identifier assigned by
  /// the server to the client. In this case, it is being passed as a header
  /// parameter in the API request.
  ///   page (int): The "page" parameter is used to specify the page number of the
  /// results to be returned. It is typically used in conjunction with the "limit"
  /// parameter to paginate through a large set of results.
  ///   limit (int): The "limit" parameter in the above code is used to specify
  /// the maximum number of results to be returned in a single page of the
  /// response. It is used in conjunction with the "page" parameter to paginate
  /// the results.
  ///   status (String): The "status" parameter is a query parameter that can be
  /// passed in the API request to filter the results based on the status of the
  /// internal transfers. It is a string parameter that can have one of the
  /// following values: "draft", "submitted", "approved", "rejected", "canceled",
  @GET(value: "v2/sales/internal-transfers", as: ListTransferResponse, error: ErrorResponse)
  void getGoodReceiptTransferList(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
    @Query("status") String statusReceived,
    @Query("status") String statusDelivered,
    @Query("withinProductionTeam") String withinProductionTeam,
    @Query("createdDate") String createdDate,
    @Query("productCategoryId") String productCategoryId,
    @Query("productItemId") String productItemId,
    @Query("sourceOperationUnitId") String operationUnitId,
    @Query("targetOperationUnitId") String vendorId,
    @Query("status") String status,
    @Query("code") String code,
    @Query("source") String source,
  ) {}

  /// This function creates a goods received record using a POST request with
  /// authorization and parameter inputs.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the API request. It typically contains a token or other
  /// credentials that are used to verify the user's identity and permissions.
  ///   xid (String): The "X-ID" header is a custom header that is used to pass a
  /// unique identifier for the request. It can be used for tracking and logging
  /// purposes.
  ///   params (String): The "params" parameter is a string that contains the data
  /// needed to create a new goods received record. It likely includes information
  /// such as the date of receipt, the quantity and type of goods received, and
  /// any relevant purchase order or supplier information. The exact format and
  /// contents of the "params" string
  @JSON(isPlaint: true)
  @POST(value: "v2/sales/goods-received", error: ErrorResponse)
  void createGoodReceived(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}

  /// `detailCustomerById` is a `GET` request that returns a `CustomerResponse` object or an `Error`
  /// object
  ///
  /// Args:
  ///   authorization (String): The authorization header
  ///   xId (String): The header value of X-ID
  ///   path (String): The path of the request.
  @GET(value: GET.PATH_PARAMETER, as: TransferResponse, error: ErrorResponse)
  void getDetailTransfer(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  @JSON(isPlaint: true)
  @POST(value: "v2/sales/internal-transfers", error: ErrorResponse)
  void createTransfer(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}

  @JSON(isPlaint: true)
  @PUT(value: PUT.PATH_PARAMETER, as: TransferResponse, error: ErrorResponse)
  void updateTransferById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  @JSON(isPlaint: true)
  @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
  void transferEditStatus(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  @JSON(isPlaint: true)
  @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
  void transferStatusDriver(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  @GET(value: "v2/fms-users", as: ListDriverResponse, error: ErrorResponse)
  void getListDriver(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("userType") String userType, @Query("\$page") int page, @Query("\$limit") int limit) {}

  @JSON(isPlaint: true)
  @POST(value: "v2/sales/stock-opnames", as: OpnameResponse, error: ErrorResponse)
  void createStockOpname(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Parameter("params") String params) {}

  @JSON(isPlaint: true)
  @PUT(value: PUT.PATH_PARAMETER, as: OpnameResponse, error: ErrorResponse)
  void updateOpnameById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  @GET(value: "v2/sales/stock-opnames", as: ListOpnameResponse, error: ErrorResponse)
  void getListOpname(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("operationUnitId") String operationUnitId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
  ) {}

  @GET(value: GET.PATH_PARAMETER, as: OpnameResponse, error: ErrorResponse)
  void detailOpnameById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  /// This is a Dart function for booking stock sales orders with authorization,
  /// ID, path, and parameters as inputs.
  ///
  /// Args:
  ///   authorization (String): This is a header parameter that is used to pass
  /// the authorization token for the API request. It is typically used to
  /// authenticate the user making the request and ensure that they have the
  /// necessary permissions to access the requested resource.
  ///   xid (String): The "X-ID" header is a custom header that may be used to
  /// pass a unique identifier for the request. This can be useful for tracking or
  /// logging purposes.
  ///   path (String): The "path" parameter is a variable that represents a path
  /// parameter in the URL of the API endpoint. It is annotated with the "@Path"
  /// annotation, which indicates that the value of this parameter will be
  /// extracted from the URL path. The actual value of the path parameter will be
  /// determined by the value
  ///   params (String): The "params" parameter is a string that contains
  /// additional parameters needed for the "bookStockSalesOrder" method. The
  /// specific format and content of the "params" string would depend on the
  /// requirements of the method and the API it belongs to.
  @JSON(isPlaint: true)
  @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
  void bookStockSalesOrder(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  /// This function edits a sales order using the provided parameters and
  /// authorization headers.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to authenticate
  /// the user making the request. It typically contains a token or credentials
  /// that are used to verify the user's identity and permissions.
  ///   xid (String): The "X-ID" header parameter is a custom header that is used
  /// to pass a unique identifier for the request. It can be used for tracking or
  /// logging purposes.
  ///   path (String): The path parameter is not specified in the code snippet. It
  /// should be included in the @Path annotation. The @Path annotation is used to
  /// specify a placeholder in the endpoint URL that will be replaced with the
  /// actual value at runtime.
  ///   params (String): The "params" parameter is a string that contains the data
  /// to be used for editing a sales order. It is likely in JSON format and
  /// includes information such as the customer name, order items, and shipping
  /// address. The exact format and contents of the "params" string would depend
  /// on the specific requirements
  @JSON(isPlaint: true)
  @PUT(value: PUT.PATH_PARAMETER, error: ErrorResponse)
  void editSalesOrder(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  /// This is a Dart function for cancelling a purchase with authorization, ID,
  /// path, and parameters as inputs.
  ///
  /// Args:
  ///   authorization (String): This parameter is a header that contains an
  /// authorization token. It is used to authenticate the user making the request
  /// and ensure that they have the necessary permissions to perform the action.
  ///   xId (String): The "xId" parameter is a header parameter that represents a
  /// unique identifier for the request. It is used to track and identify the
  /// request throughout its lifecycle.
  ///   path (String): The "path" parameter is a placeholder for a specific value
  /// that will be passed in the URL path of the API endpoint. It is typically
  /// used to identify a specific resource or entity that the API is interacting
  /// with.
  ///   params (String): The "params" parameter is a string that contains
  /// additional parameters needed for the cancellation of a purchase. The
  /// specific format and content of this parameter would depend on the
  /// requirements of the API being used.
  @POST(value: PUT.PATH_PARAMETER, error: ErrorResponse)
  void cancelGr(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  /// This is a Dart function that retrieves details of a received item by its ID,
  /// with authorization and error handling.
  ///
  /// Args:
  ///   authorization (String): The authorization header is used to send a token
  /// or credentials to authenticate the user making the request. It is typically
  /// used to ensure that only authorized users can access the requested resource.
  ///   String: The "String" data type is used to represent a sequence of
  /// characters in Java. In this case, it is used to represent the values of the
  /// "authorization", "X-ID", and "path" parameters in the method signature.
  ///   path (String): The "path" parameter in this method is a placeholder for a
  /// path variable in the URL. It is used to specify a dynamic value in the URL
  /// that can be used to identify a specific resource. The value of this
  /// parameter will be extracted from the URL at runtime and passed as an
  /// argument to the
  @GET(value: GET.PATH_PARAMETER, as: GoodReceiveReponse, error: ErrorResponse)
  void detailReceivedById(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Path() String path) {}

  @GET(value: "v2/sales/sales-orders", as: SalesOrderListResponse, error: ErrorResponse)
  void getDeliveryListSO(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("\$page") int page, @Query("\$limit") int limit, @Query("driverId") String driverId, @Query("status") String readyToDeliver, @Query("status") String onDelivery, @Query("status") String delivered, @Query("status") String rejected) {}

  @GET(value: "v2/sales/internal-transfers", as: ListTransferResponse, error: ErrorResponse)
  void getDeliveryListTransfer(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("\$page") int page, @Query("\$limit") int limit, @Query("driverId") String driverId, @Query("status") String readyToDeliver, @Query("status") String onDelivery, @Query("status") String delivered, @Query("status") String received) {}

  @JSON(isPlaint: true)
  @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
  void deliveryPickupSO(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  @JSON(isPlaint: true)
  @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
  void deliveryConfirmSO(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}

  @GET(value: "v2/branches", as: ListBranchResponse, error: ErrorResponse)
  void getBranch(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xid,
    @Header("X-APP-ID") String xAppId,
  ) {}

  @GET(value: "v2/sales/stock-opnames", as: ListOpnameResponse, error: ErrorResponse)
  void getListOpnameJob(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
    @Query("status") String confirmed,
  ) {}

  @GET(value: "v2/sales/stock-disposals", as: ListTerminateResponse, error: ErrorResponse)
  void getListTerminateJob(
    @Header("Authorization") String authorization,
    @Header("X-ID") String xId,
    @Header("X-APP-ID") String xAppId,
    @Query("\$page") int page,
    @Query("\$limit") int limit,
    @Query("status") String booked,
  ) {}
}
