///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/response/internal_app/purchase_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class PurchaseController extends GetxController{
  BuildContext context;
  PurchaseController({required this.context});

  var page = 1.obs;
  var limit = 10.obs;
  Rx<List<Purchase?>> purchaseList = Rx<List<Purchase>>([]);

  var isLoading = false.obs;
  var isLoadMore = false.obs;

  ScrollController scrollController = ScrollController();

  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        page++;
        getListPurchase();
      }
    });
  }

  void getListPurchase(){
    Service.push(
        service: ListApi.getPurchaseOrderList,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet){
          if ((body as ListPurchaseResponse).data.isNotEmpty){
            for (var result in body.data){
              purchaseList.value.add(result as Purchase);
            }
            if(isLoadMore.isTrue){
              isLoadMore.value = false;
            }
          } else {
            if(isLoadMore.isTrue){
              page.value = (purchaseList.value.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
            } else {
              isLoading.value = false;
            }
          }
          isLoading.value  = false;
        }, onResponseFail: (code, message, body, id, packet){
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          isLoading.value  = false;
        }, onResponseError: (exception, stacktrace, id, packet){
            Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
            );
            isLoading.value = false;

        },  onTokenInvalid: Constant.invalidResponse()));
  }

  @override
  void onInit() {
    super.onInit();
    scrollListener();
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    getListPurchase();
  }

}

class PurchasePageBindings extends Bindings {
  BuildContext context;
  PurchasePageBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseController(context: context));
  }
}