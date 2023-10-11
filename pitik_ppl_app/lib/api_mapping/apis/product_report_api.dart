
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/procurement_list_response.dart';
import 'package:model/response/sapronak_response.dart';

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
}