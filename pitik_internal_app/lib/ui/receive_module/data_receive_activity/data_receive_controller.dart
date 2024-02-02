import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:model/response/internal_app/purchase_list_response.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:model/response/internal_app/transfer_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/04/23

class ReceiveController extends GetxController{
  BuildContext context;

  ReceiveController({required this.context});

  var pagePurchase = 1.obs;
  var pageTransfer = 1.obs;
  var pageOrder = 1.obs;
  var limit = 10.obs;
  Rx<List<Purchase?>> listPurchase = Rx<List<Purchase>>([]);
  Rx<List<TransferModel?>> listTransfer = Rx<List<TransferModel>>([]);
  Rx<List<Order?>> listReturn = Rx<List<Order>>([]);
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

  var isLoadingPurchase = false.obs;
  var isLoadingTransfer = false.obs;
  var isLoadingOrder = false.obs;
  var isLoadMore = false.obs;

  ScrollController scrollPurchaseController = ScrollController();
  ScrollController scrollTransferController = ScrollController();
  ScrollController scrollOrderController = ScrollController();

  scrollPurchaseListener() async {
    scrollPurchaseController.addListener(() {
      if (scrollPurchaseController.position.maxScrollExtent == scrollPurchaseController.position.pixels) {
        isLoadMore.value = true;
        pagePurchase++;
        getListPurchase();
      }
    });
  }

  scrollTransferListener() async {
    scrollTransferController.addListener(() {
      if (scrollTransferController.position.maxScrollExtent == scrollTransferController.position.pixels) {
        isLoadMore.value = true;
        pageTransfer++;
        getListTransfer();
      }
    });
  }
  scrollOrderListener() async {
    scrollOrderController.addListener(() {
      if (scrollOrderController.position.maxScrollExtent == scrollOrderController.position.pixels) {
        isLoadMore.value = true;
        pageOrder++;
        getListReturn();
      }
    });
  }


  void getListPurchase(){
    Service.push(
        service: ListApi.getGoodReceiptPOList,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, pagePurchase.value, limit.value,"CONFIRMED","RECEIVED",AppStrings.TRUE_LOWERCASE],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet){
          if ((body as ListPurchaseResponse).data.isNotEmpty){
            for (var result in body.data){
              listPurchase.value.add(result as Purchase);
            }
            isLoadingPurchase.value  = false;
            if(isLoadMore.isTrue){
              isLoadMore.value = false;
            }
          } else {
            if(isLoadMore.isTrue){
              pagePurchase.value = (listPurchase.value.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
            } else {
              isLoadingPurchase.value = false;
            }
          }
          countingApi();
        }, onResponseFail: (code, message, body, id, packet){
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          isLoadingPurchase.value = false;
          countingApi();
        }, onResponseError: (exception, stacktrace, id, packet){
                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
            isLoadingPurchase.value = false;
          countingApi();
        },  onTokenInvalid: Constant.invalidResponse()));
  }

  void getListTransfer(){
    Service.push(
        service: ListApi.getGoodReceiptTransferList,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, pageTransfer.value, limit.value,"RECEIVED", "DELIVERED", AppStrings.TRUE_LOWERCASE],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet){
          if ((body as ListTransferResponse).data.isNotEmpty){
            for (var result in body.data){
              listTransfer.value.add(result as TransferModel);
            }
            isLoadingTransfer.value  = false;
            if(isLoadMore.isTrue){
              isLoadMore.value = false;
            }
          } else {
            if(isLoadMore.isTrue){
              pageTransfer.value = (listTransfer.value.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
            } else {
              isLoadingTransfer.value = false;
            }
          }
          countingApi();
        }, onResponseFail: (code, message, body, id, packet){
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          countingApi();
        }, onResponseError: (exception, stacktrace, id, packet){
                          Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
          countingApi();

        },  onTokenInvalid: Constant.invalidResponse()));
  }

  void getListReturn(){
    Service.push(
        service: ListApi.getGoodReceiptsOrderList,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, pageOrder.value, limit.value,"RECEIVED","REJECTED"],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet){
          if ((body as SalesOrderListResponse).data.isNotEmpty){
            for (var result in body.data){
              if(result!.grStatus! == "REJECTED" || result.grStatus == "RECEIVED") {
                listReturn.value.add(result);
              }
            }
            Map<String, bool> mapListRemark = {};
            for (var product in body.data) {
              mapListRemark[product!.status!] = false;
            }
            mapListRemark.removeWhere((key, value) => key == "REJECTED");
            isLoadingOrder.value  = false;
            if(isLoadMore.isTrue){
              isLoadMore.value = false;
            }
          } else {
            if(isLoadMore.isTrue){
              pageOrder.value = (listReturn.value.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
            } else {
              isLoadingOrder.value = false;
            }
          }
          countingApi();
        }, onResponseFail: (code, message, body, id, packet){
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          countingApi();
        }, onResponseError: (exception, stacktrace, id, packet){
            Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                countingApi();

        },  onTokenInvalid: Constant.invalidResponse()));
  }


  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  int countApi =0;

  @override
  void onInit() {
    super.onInit();
    scrollPurchaseListener();
    scrollTransferListener();
    scrollOrderListener();
  }

  @override
  void onReady() {
    super.onReady();
    isLoadingPurchase.value = true;
    getListPurchase();
    getListTransfer();
    getListReturn();
  }

  void countingApi(){
    countApi++;
    if(countApi == 3){
      timeEnd = DateTime.now();
      Duration duration = timeEnd.difference(timeStart);
      Constant.trackRenderTime("Penerimaan", duration);
    }
  }


}

class ReceiveBindings extends Bindings {
  BuildContext context;
  ReceiveBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => ReceiveController(context: context));
  }
}