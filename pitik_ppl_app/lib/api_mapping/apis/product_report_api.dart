
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
import 'package:model/response/procurement_detail_response.dart';
import 'package:model/response/procurement_list_response.dart';
import 'package:model/response/request_chickin_response.dart';
import 'package:model/response/sapronak_response.dart';
import 'package:model/response/products_response.dart';
import 'package:model/response/stock_summary_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

@Rest
class ProductReportApi {

    /// The function `getSapronak` is a GET request that retrieves a
    /// SapronakResponse object, with an Authorization header, X-ID header, and a
    /// path parameter.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   path (String): The "path" parameter is a placeholder for the actual value
    /// that will be passed in the URL path when making the GET request. It is used
    /// to specify a specific resource or endpoint that the request is targeting.
    @GET(value: GET.PATH_PARAMETER, as: SapronakResponse, error: ErrorResponse)
    void getSapronak(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    /// The function getListPurchaseRequest retrieves a list of purchase requests
    /// with specified parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is used to pass the
    /// authentication token or credentials required to access the API endpoint. It
    /// is typically included in the request header for security purposes.
    ///   xId (String): The `xId` parameter is a unique identifier for the request.
    /// It is typically used for tracking or logging purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to filter
    /// the purchase requests based on the farming cycle ID. It is a string value.
    ///   isBeforeDoc (bool): The "isBeforeDoc" parameter is a boolean value that
    /// indicates whether the purchase requests should be filtered based on whether
    /// they were created before a certain document.
    ///   type (String): The "type" parameter is used to specify the type of
    /// purchase request to retrieve. It can be a string value that represents the
    /// type, such as "pending", "approved", "rejected", etc.
    ///   fromDate (String): The "fromDate" parameter is used to specify the
    /// starting date for filtering the purchase requests. It is a string that
    /// represents a date in a specific format.
    ///   untilDate (String): The "untilDate" parameter is used to specify the end
    /// date for filtering the purchase requests. It is a string that represents a
    /// date in a specific format.
    @GET(value: "v2/purchase-requests", as: ProcurementListResponse, error: ErrorResponse)
    void getListPurchaseRequest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("isBeforeDoc") bool isBeforeDoc,
                                @Query("type") String type, @Query("fromDate") String fromDate, @Query("untilDate") String untilDate) {}

    /// The function getListPurchaseRequestForCoopRest retrieves a list of purchase
    /// requests for a specific cooperative.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to authenticate the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the ID of the user making the request. It is typically used for
    /// authentication or authorization purposes.
    ///   coopId (String): The `coopId` parameter is used to specify the ID of the
    /// cooperative for which the purchase requests should be retrieved.
    ///   isBeforeDoc (bool): The "isBeforeDoc" parameter is a boolean value that
    /// indicates whether the purchase requests should be filtered based on whether
    /// they are before or after a certain document. If the value is true, it means
    /// that only purchase requests before the specified document should be included
    /// in the response. If the value is false
    ///   type (String): The "type" parameter is used to specify the type of
    /// purchase request to retrieve. It can be a string value that represents the
    /// type of purchase request, such as "pending", "approved", "rejected", etc.
    ///   fromDate (String): The "fromDate" parameter is used to specify the
    /// starting date for filtering the purchase requests.
    ///   untilDate (String): The "untilDate" parameter is used to specify the upper
    /// limit of the date range for filtering the purchase requests. It is a string
    /// that represents a date in a specific format.
    @GET(value: "v2/purchase-requests", as: ProcurementListResponse, error: ErrorResponse)
    void getListPurchaseRequestForCoopRest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("coopId") String coopId, @Query("isBeforeDoc") bool isBeforeDoc,
                                           @Query("type") String type, @Query("fromDate") String fromDate, @Query("untilDate") String untilDate) {}

    /// The function `getListPurchaseOrder` is a GET request that retrieves a list
    /// of purchase orders based on various query parameters.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to verify the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a unique identifier for the request.
    /// It is typically used for tracking or logging purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to filter
    /// the purchase orders based on the farming cycle ID. It allows you to retrieve
    /// purchase orders that are associated with a specific farming cycle.
    ///   isBeforeDoc (bool): The "isBeforeDoc" parameter is a boolean value that
    /// indicates whether the purchase orders should be filtered based on whether
    /// they were created before a certain document.
    ///   type (String): The "type" parameter is used to filter the purchase orders
    /// based on their type. It is a string value that can be used to specify the
    /// type of purchase orders you want to retrieve.
    ///   fromDate (String): The "fromDate" parameter is used to specify the
    /// starting date for filtering the purchase orders. It is a string that
    /// represents a date in a specific format.
    ///   untilDate (String): The "untilDate" parameter is used to specify the upper
    /// limit of the date range for filtering purchase orders. It is a string that
    /// represents a date.
    ///   status (String): The "status" parameter is used to filter the purchase
    /// orders based on their status. It is a string parameter that accepts values
    /// such as "pending", "approved", "rejected", etc.
    @GET(value: "v2/purchase-orders", as: ProcurementListResponse, error: ErrorResponse)
    void getListPurchaseOrder(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("isBeforeDoc") bool isBeforeDoc,
                              @Query("type") String type, @Query("fromDate") String fromDate, @Query("untilDate") String untilDate, @Query("status") String status) {}

    /// This function is a GET request to retrieve a list of purchase orders for a
    /// cooperative.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API. It is
    /// typically used to verify the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the ID of the request. It is typically used for tracking or identifying the
    /// request.
    ///   coopId (String): The `coopId` parameter is used to specify the ID of the
    /// cooperative for which you want to retrieve the purchase orders.
    ///   isBeforeDoc (bool): The "isBeforeDoc" parameter is a boolean value that
    /// indicates whether the purchase orders should be filtered based on whether
    /// they were created before a certain document.
    ///   type (String): The "type" parameter is used to specify the type of
    /// purchase orders to retrieve. It can be used to filter the purchase orders
    /// based on their type, such as "completed", "pending", "cancelled", etc.
    ///   fromDate (String): The "fromDate" parameter is used to specify the
    /// starting date for filtering the purchase orders. It is a string that
    /// represents a date in a specific format, such as "yyyy-MM-dd".
    ///   untilDate (String): The "untilDate" parameter is used to specify the upper
    /// limit of the date range for filtering purchase orders. It is a string that
    /// represents a date.
    ///   status (String): The "status" parameter is used to filter the purchase
    /// orders based on their status. It is a string parameter that accepts values
    /// such as "pending", "approved", "rejected", etc.
    @GET(value: "v2/purchase-orders", as: ProcurementListResponse, error: ErrorResponse)
    void getListPurchaseOrderForCoopRest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("coopId") String coopId, @Query("isBeforeDoc") bool isBeforeDoc,
                                         @Query("type") String type, @Query("fromDate") String fromDate, @Query("untilDate") String untilDate, @Query("status") String status) {}

    /// The function `getProducts` is a GET request that retrieves a list of
    /// products based on various query parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header that
    /// contains the authorization token required for authentication. It is used to
    /// verify the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   productName (String): The "productName" parameter is used to specify the
    /// name of the product you want to search for.
    ///   categoryName (String): The `categoryName` parameter is used to specify the
    /// name of the category for which you want to search products. It is a query
    /// parameter that can be passed in the URL when making a GET request to the
    /// "v2/products/search" endpoint.
    ///   subcategoryName (String): The "subcategoryName" parameter is used to
    /// specify the name of the subcategory for which you want to search products.
    /// It is a query parameter that can be passed in the URL when making a GET
    /// request to the "v2/products/search" endpoint.
    ///   page (int): The "page" parameter is used to specify the page number of the
    /// results you want to retrieve. It is typically used for pagination purposes,
    /// where the API returns a large number of results and you want to retrieve
    /// them in chunks or pages. By specifying the page number, you can retrieve
    /// different sets of
    ///   limit (int): The "limit" parameter is used to specify the maximum number
    /// of products to be returned in a single page of the search results.
    @GET(value: "v2/products/search", as: ProductsResponse, error: ErrorResponse)
    void getProducts(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("productName") String productName, @Query("categoryName") String categoryName, @Query("subcategoryName") String subcategoryName,
                     @Query("\$page") int page, @Query("\$limit") int limit) {}

    /// The function `searchOvkUnit` is a GET request that searches for products in
    /// a specific branch based on various parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for authentication
    /// purposes. It is typically used to verify the identity and permissions of the
    /// user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the ID of the user making the request. It is typically used for
    /// authentication or identification purposes.
    ///   productName (String): productName is a query parameter used to search for
    /// products by their name. It is a string value that represents the name of the
    /// product.
    ///   branchId (String): The `branchId` parameter is used to specify the ID of
    /// the branch for which you want to search for stocks.
    ///   type (String): The "type" parameter is used to specify the type of product
    /// you want to search for. It can be used to filter the search results based on
    /// the product type, such as "electronics", "clothing", "groceries", etc.
    ///   page (int): The "page" parameter is used to specify the page number of the
    /// results you want to retrieve. It is typically used in combination with the
    /// "limit" parameter to implement pagination.
    ///   limit (int): The "limit" parameter is used to specify the maximum number
    /// of results to be returned per page. It determines the number of items that
    /// will be displayed in the response.
    @GET(value: "v2/branch-sapronak-stocks", as: ProductsResponse, error: ErrorResponse)
    void searchOvkUnit(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("productName") String productName, @Query("branchId") String branchId, @Query("type") String type,
                       @Query("\$page") int page, @Query("\$limit") int limit) {}

    /// A GET request to the endpoint v2/purchase-orders with the following headers:
    /// Authorization: String
    /// X-ID: String
    /// The query parameters are:
    /// farmingCycleId: String
    /// type: String
    /// The response is of type ProcurementRequestResponse and the error response is of type
    /// ErrorResponse.
    ///
    /// @param authorization The authorization token
    /// @param xId This is the unique identifier for the user.
    /// @param farmingCycleId The ID of the farming cycle.
    /// @param type The type of procurement request.
    @GET(value: "v2/purchase-orders", as : ProcurementListResponse, error : ErrorResponse)
    void getReceiveProcurement(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("isBeforeDoc") bool isBeforeDoc, @Query("type") String type,
                               @Query("fromDate") String fromDate, @Query("untilDate") String untilDate, @Query("status") String status){}

    /// A GET request with a path parameter. The response is of type RequestChickinResponse and the
    /// error response is of type ErrorResponse.
    ///
    /// @param authorization Authorization header
    /// @param xId The unique ID of the request.
    /// @param path The path of the request.
    @GET(value : GET.PATH_PARAMETER, as : RequestChickinResponse, error : ErrorResponse)
    void getRequestDoc(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path){}

    /// A PATCH request with a path parameter. The response is in JSON format.
    ///
    /// @param authorization The authorization header
    /// @param xId The unique identifier for the request.
    /// @param path The path of the request.
    /// @param data The data to be sent to the server.
    @PATCH(value : PATCH.PATH_PARAMETER, error : ErrorResponse)
    @JSON(isPlaint: true)
    void updateRequestChickin(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data){}

    /// A PATCH request that returns an error response.
    ///
    /// @param authorization The authorization header
    /// @param xId The ID of the user who is making the request.
    /// @param path The path to the resource.
    /// @param data The data to be sent to the server.
    @PATCH(value : PATCH.PATH_PARAMETER, error : ErrorResponse)
    @JSON(isPlaint: true)
    void approveRequestChickin(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data){}

        /// A POST request to the endpoint "v2/chick-in-requests" with the header "Authorization" and "X-ID"
        /// and the parameter "data".
        ///
        /// @param authorization The authorization token
        /// @param xId The ID of the user who is making the request.
        /// @param data The data parameter is a JSON object that contains the following fields:
    @POST(value : "v2/chick-in-requests", error : ErrorResponse)
    @JSON(isPlaint: true)
    void saveRequestChickin(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Parameter("data") String data){}

    /// A GET request to the path /purchase-requests/{purchaseRequestId}/details.
    ///
    /// @param authorization Authorization header
    /// @param xId The ID of the user who is making the request.
    /// @param purchaseRequestId The ID of the purchase request that you want to get the details of.
    @GET(value : GET.PATH_PARAMETER, as : ProcurementDetailResponse, error : ErrorResponse)
    void getDetailRequest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String purchaseRequestId){}

    /// A GET request that returns a RequestChickinResponse object.
    ///
    /// @param authorization Authorization header
    /// @param xId The unique ID of the request.
    /// @param path The path of the request.
    @GET(value : GET.PATH_PARAMETER, as : RequestChickinResponse, error : ErrorResponse)
    void getRequestChickinDetail(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path){}

    /// The function `purchaseRequest` sends a POST request to the
    /// "v2/purchase-requests" endpoint with the provided authorization, X-ID, and
    /// data parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity and
    /// permissions of the user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   data (String): The "data" parameter is a string that represents the
    /// purchase request data. It could contain information such as the items being
    /// purchased, quantities, prices, and any other relevant details for the
    /// purchase request.
    @POST(value: "v2/purchase-requests", error: ErrorResponse)
    @JSON(isPlaint: true)
    void purchaseRequest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Parameter("data") String data) {}

    /// The function `transferRequest` sends a POST request to the
    /// "v2/transfer-requests" endpoint with the provided authorization, xId, and
    /// data parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity of the
    /// user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   data (String): The "data" parameter is a string that represents the
    /// transfer request data. It could contain information such as the amount to be
    /// transferred, the source and destination accounts, and any additional details
    /// related to the transfer.
    @POST(value: "v2/transfer-requests", error: ErrorResponse)
    @JSON(isPlaint: true)
    void transferRequest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Parameter("data") String data) {}

    /// The function `purchaseRequestForCoopRest` is a POST request that sends a
    /// purchase request to a specific endpoint with authorization and data
    /// parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header that
    /// typically contains an authentication token or credentials to authorize the
    /// request. It is used to authenticate the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID value. It is used to identify a specific request or transaction.
    ///   data (String): The "data" parameter is a string that represents the
    /// purchase request data. It is typically in JSON format and contains
    /// information such as the items to be purchased, quantities, prices, and any
    /// other relevant details.
    @POST(value: "v2/purchase-requests/sapronak-doc-in", error: ErrorResponse)
    @JSON(isPlaint: true)
    void purchaseRequestForCoopRest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Parameter("data") String data) {}

    /// The function `purchaseOrTransferRequestUpdate` is used to update a purchase
    /// or transfer request with the given authorization, X-ID, path, and data.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send a token
    /// or credentials to authenticate the request. It is typically used to verify
    /// the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID value. It is used to provide additional identification or context
    /// information for the request.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that needs to be updated in the PATCH request. It is a string value
    /// that represents the path of the resource.
    ///   data (String): The "data" parameter is a string that represents the data
    /// for the purchase or transfer request update. It is used to pass information
    /// related to the update operation.
    @PATCH(value: PATCH.PATH_PARAMETER, error: ErrorResponse)
    @JSON(isPlaint: true)
    void purchaseOrTransferRequestUpdate(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data) {}

    /// The function `cancelOrder` is used to send a PATCH request to cancel an
    /// order with the provided authorization, X-ID, path, and data.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the protected
    /// resource. It is typically used to authenticate the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID header value.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that needs to be modified or updated. It is typically used in
    /// combination with the HTTP PATCH method to partially update an existing
    /// resource.
    ///   data (String): The "data" parameter is a string that represents the data
    /// associated with the request. It is typically used to pass additional
    /// information or payload to the server.
    @PATCH(value: PATCH.PATH_PARAMETER, error: ErrorResponse)
    @JSON(isPlaint: true)
    void cancelOrder(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data) {}

    /// The function `rejectOrder` is used to send a PATCH request with path
    /// parameters and headers, and it expects a JSON response.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for the request. It
    /// is typically used to authenticate the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID header value.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that needs to be updated or modified. It is typically used in PATCH
    /// requests to identify the specific resource that needs to be modified.
    ///   data (String): The "data" parameter is a string that represents the data
    /// to be used for the PATCH request.
    @PATCH(value: PATCH.PATH_PARAMETER, error: ErrorResponse)
    @JSON(isPlaint: true)
    void rejectOrder(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data) {}

    /// The function `approvalOrder` is a PATCH request that requires authorization
    /// and an ID header, and it takes a path parameter and an empty body.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for the request. It
    /// is typically used to authenticate the user making the request.
    ///   xId (String): The `xId` parameter is a header parameter that represents
    /// the X-ID value. It is typically used for identification or authentication
    /// purposes.
    ///   path (String): The `path` parameter is used to specify the path of the
    /// resource that needs to be updated or modified. It is typically used in PATCH
    /// requests to identify the specific resource that needs to be updated.
    ///   emptyBody (String): The `emptyBody` parameter is a string that represents
    /// the body of the request. It is used to send an empty body in the request.
    @PATCH(value: PATCH.PATH_PARAMETER, error: ErrorResponse)
    @JSON(isPlaint: true)
    void approvalOrder(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("emptyBody") String emptyBody) {}

    /// The function `getTransferSend` is a GET request that retrieves a list of
    /// transfer requests for exiting a procurement, with various query parameters.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API endpoint. It
    /// is typically used for authentication purposes.
    ///   xId (String): The `xId` parameter is a unique identifier for the request.
    /// It is typically used for tracking and logging purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve transfer
    /// requests.
    ///   type (String): The "type" parameter is used to specify the type of
    /// transfer request. It could be used to filter the transfer requests based on
    /// their type, such as "exit" in this case.
    ///   fromDate (String): The "fromDate" parameter is used to specify the
    /// starting date for the transfer requests. It is a string that represents a
    /// date in a specific format.
    ///   untilDate (String): The "untilDate" parameter is used to specify the end
    /// date for the transfer requests. It is a string that represents a date in a
    /// specific format.
    @GET(value:"v2/transfer-requests/exit", as:  ProcurementListResponse, error: ErrorResponse)
    void getTransferSend(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("type") String type, @Query("fromDate") String fromDate,
                         @Query("untilDate") String untilDate) {}

    /// The function `getTransferReceived` is a GET request that retrieves transfer
    /// requests for procurement, with various query parameters.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send the
    /// authentication token or credentials required to access the API endpoint. It
    /// is typically used to verify the identity of the user making the request.
    ///   xId (String): The `xId` parameter is a unique identifier for the request.
    /// It is typically used for tracking and logging purposes.
    ///   farmingCycleId (String): The farmingCycleId parameter is used to specify
    /// the ID of the farming cycle for which you want to retrieve transfer
    /// requests.
    ///   type (String): The "type" parameter is used to specify the type of
    /// transfer request. It could be used to filter the transfer requests based on
    /// their type, such as "received" or "sent".
    ///   fromDate (String): The "fromDate" parameter is used to specify the
    /// starting date for the transfer requests. It is a string that represents a
    /// date in a specific format, such as "yyyy-MM-dd".
    ///   untilDate (String): The "untilDate" parameter is used to specify the end
    /// date for the transfer requests. It is a string that represents a date in a
    /// specific format.
    @GET(value: "v2/transfer-requests/enter", as: ProcurementListResponse, error: ErrorResponse)
    void getTransferReceived(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("type") String type, @Query("fromDate") String fromDate,
                             @Query("untilDate") String untilDate) {}

    /// The function "getTransferDetail" is a GET request that retrieves the details
    /// of a transfer request using the provided authorization, X-ID, and
    /// transferRequestId.
    ///
    /// Args:
    ///   authorization (String): The "Authorization" header is used to send
    /// authentication credentials to the server. It typically contains a token or
    /// other form of authentication that allows the client to access protected
    /// resources.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   transferRequestId (String): The transferRequestId parameter is a path
    /// parameter that represents the unique identifier of a transfer request. It is
    /// used to retrieve the details of a specific transfer request.
    @GET(value: GET.PATH_PARAMETER, as: ProcurementDetailResponse, error: ErrorResponse)
    void getTransferDetail(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String transferRequestId) {}

    /// The function "getStocks" is a GET request that retrieves stock information
    /// with authorization and ID headers, and a path parameter.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token or credentials for
    /// authentication purposes. It is typically used to verify the identity and
    /// permissions of the user making the request.
    ///   xId (String): The xId parameter is a header parameter that represents a
    /// unique identifier for the request. It is typically used for tracking or
    /// logging purposes.
    ///   path (String): The `path` parameter is a placeholder for the specific path
    /// or endpoint that you want to access in your API. It is typically used to
    /// specify a dynamic value in the URL, such as an ID or a variable.
    @GET(value: GET.PATH_PARAMETER, as: ProductsResponse, error: ErrorResponse)
    void getStocks(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

    @GET(value: GET.PATH_PARAMETER, as: StockSummaryResponse, error: ErrorResponse)
    void getStocksSummary(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

}