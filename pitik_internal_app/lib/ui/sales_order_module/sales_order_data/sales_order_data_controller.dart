///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class SalesOrderController extends GetxController{
  BuildContext context;
  SalesOrderController({required this.context});

  var page = 1.obs;
  var limit = 10.obs;
  Rx<List<Order?>> orderList = Rx<List<Order>>([]);

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  ScrollController scrollController = ScrollController();

  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        page++;
        getListOrders();
      }
    });
  }


  void getListOrders(){
    Service.push(
        service: ListApi.getListOrders,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value, "DRAFT","CONFIRMED","BOOKED","READY_TO_DELIVER","DELIVERED","CANCELLED", "REJECTED","ON_DELIVERY"],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet){
          if ((body as SalesOrderListResponse).data.isNotEmpty){
            for (var result in body.data){
                orderList.value.add(result as Order);
            }
            if(isLoadMore.isTrue){
                isLoading.value = false;
                isLoadMore.value = false;
            }else {
                isLoading.value = false;
            }

          } else {
            if(isLoadMore.isTrue){
              page.value = (orderList.value.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
              isLoading.value = false;
            } else {
              isLoading.value = false;
            }
          }
        }, onResponseFail: (code, message, body, id, packet){
          isLoading.value = false;
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        }, onResponseError: (exception, stacktrace, id, packet){
            Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
            ); 

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
    isLoading.value= true;
    getListOrders();
  }

}

class SalesOrderPageBindings extends Bindings {
  BuildContext context;
  SalesOrderPageBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => SalesOrderController(context: context));
  }
}