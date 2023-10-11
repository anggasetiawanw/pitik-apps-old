
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

    @GET(value: "v2/purchase-requests", as: ProcurementListResponse, error: ErrorResponse)
    void getListPurchaseRequest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("isBeforeDoc") bool isBeforeDoc,
                                @Query("type") String type, @Query("fromDate") String fromDate, @Query("untilDate") String untilDate) {}

    @GET(value: "v2/purchase-requests", as: ProcurementListResponse, error: ErrorResponse)
    void getListPurchaseRequestForCoopRest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("coopId") String coopId, @Query("isBeforeDoc") bool isBeforeDoc,
                                           @Query("type") String type, @Query("fromDate") String fromDate, @Query("untilDate") String untilDate) {}

    @GET(value: "v2/purchase-orders", as: ProcurementListResponse, error: ErrorResponse)
    void getListPurchaseOrder(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("farmingCycleId") String farmingCycleId, @Query("isBeforeDoc") bool isBeforeDoc,
                              @Query("type") String type, @Query("fromDate") String fromDate, @Query("untilDate") String untilDate, @Query("status") String status) {}

    @GET(value: "v2/purchase-orders", as: ProcurementListResponse, error: ErrorResponse)
    void getListPurchaseOrderForCoopRest(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("coopId") String coopId, @Query("isBeforeDoc") bool isBeforeDoc,
                                         @Query("type") String type, @Query("fromDate") String fromDate, @Query("untilDate") String untilDate, @Query("status") String status) {}
}