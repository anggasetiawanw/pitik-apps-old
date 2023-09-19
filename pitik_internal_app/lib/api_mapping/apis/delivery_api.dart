

import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:model/response/internal_app/transfer_list_response.dart';

@Rest
class DeliveryApi {
    @GET(value: "v2/sales/sales-orders", as: SalesOrderListResponse, error: ErrorResponse)
    void getDeliveryListSO(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("\$page") int page, @Query("\$limit") int limit,@Query("driverId") String driverId, @Query("status") String readyToDeliver, @Query("status") String onDelivery, @Query("status") String delivered, @Query("status") String rejected ) {}

    @GET(value: "v2/sales/internal-transfers", as: ListTransferResponse, error: ErrorResponse)
    void getDeliveryListTransfer(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Header("X-APP-ID") String xAppId, @Query("\$page") int page, @Query("\$limit") int limit,@Query("driverId") String driverId,@Query("status") String readyToDeliver, @Query("status") String onDelivery, @Query("status") String delivered, @Query("status") String received) {}

    @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
    void deliveryPickupSO(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path,@Parameter("params") String params){}

    @JSON(isPlaint: true)
    @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
    void deliveryConfirmSO(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path,@Parameter("params") String params){}

}