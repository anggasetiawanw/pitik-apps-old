import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:model/response/internal_app/transfer_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class DeliveryHomeController extends GetxController {
  BuildContext context;
  DeliveryHomeController({required this.context});

  var pageSales = 1.obs;
  var limitSales = 10.obs;
  Rx<List<Order?>> listSalesOrder = Rx<List<Order>>([]);

  var isLoadingSales = false.obs;
  var isLoadMoreSales = false.obs;
  ScrollController scrollControllerSales = ScrollController();

  var pageTransfer = 1.obs;
  var limitTransfer = 10.obs;
  Rx<List<TransferModel?>> listTransfer = Rx<List<TransferModel>>([]);

  var isLoadingTransfer = false.obs;
  var isLoadMoreTransfer = false.obs;
  ScrollController scrollControllerTransfer = ScrollController();


  @override
  void onReady() {
    super.onReady();
    isLoadingTransfer.value = true;
    isLoadingSales.value = true;
    getListOrders();
    getListTransfer();
    salesScrollListener();
    transferScrollListener();
  }


  salesScrollListener() async {
    scrollControllerSales.addListener(() {
      if (scrollControllerSales.position.maxScrollExtent ==
          scrollControllerSales.position.pixels) {
        isLoadMoreSales.value = true;
        pageSales++;
        getListOrders();
      }
    });
  }

  void getListOrders() {
    Service.push(
        service: ListApi.getDeliveryListSO,
        context: Get.context!,
        body: [
          Constant.auth!.token!,
          Constant.auth!.id,
          Constant.xAppId!,
          pageSales.value,
          limitSales.value,
          Constant.profileUser!.id,
          "READY_TO_DELIVER",
          "ON_DELIVERY",
          "DELIVERED",
          "REJECTED",
        ],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as SalesOrderListResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listSalesOrder.value.add(result as Order);
                }
                isLoadingSales.value = false;
                if (isLoadMoreSales.isTrue) {
                  isLoadMoreSales.value = false;
                }
              } else {
                if (isLoadMoreSales.isTrue) {
                  pageSales.value =
                      (listSalesOrder.value.length ~/ 10).toInt() + 1;
                  isLoadMoreSales.value = false;
                } else {
                  isLoadingSales.value = false;
                }
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoadingSales.value = false;
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
            Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
            );
            isLoadingSales.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

    transferScrollListener() async {
    scrollControllerTransfer.addListener(() {
      if (scrollControllerTransfer.position.maxScrollExtent ==
          scrollControllerTransfer.position.pixels) {
        isLoadMoreTransfer.value = true;
        pageTransfer++;
        getListTransfer();
      }
    });
  }

  void getListTransfer() {
    Service.push(
        service: ListApi.getDeliveryListTransfer,
        context: Get.context!,
        body: [
          Constant.auth!.token!,
          Constant.auth!.id,
          Constant.xAppId!,
          pageTransfer.value,
          limitTransfer.value,
          Constant.profileUser!.id,
          "READY_TO_DELIVER",
          "ON_DELIVERY",
          "DELIVERED",
          "RECEIVED"
        ],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListTransferResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listTransfer.value.add(result as TransferModel);
                }
                isLoadingTransfer.value = false;
                if (isLoadMoreTransfer.isTrue) {
                  isLoadMoreTransfer.value = false;
                }
              } else {
                if (isLoadMoreTransfer.isTrue) {
                  pageTransfer.value =
                      (listTransfer.value.length ~/ 10).toInt() + 1;
                  isLoadMoreTransfer.value = false;
                } else {
                  isLoadingTransfer.value = false;
                }
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoadingSales.value = false;
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );             
                isLoadingSales.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}

class DeliveryHomeBindings extends Bindings {
  BuildContext context;
  DeliveryHomeBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => DeliveryHomeController(context: context));
  }
}
