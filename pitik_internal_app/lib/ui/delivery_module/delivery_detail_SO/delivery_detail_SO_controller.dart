import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/response/internal_app/order_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
class DeliveryDetailSOController extends GetxController {
    BuildContext context;
    DeliveryDetailSOController({required this.context});

    var isLoading = false.obs;
    var sumChick = 0.obs;
    var sumKg =0.0.obs;
    var sumPrice = 0.0.obs;
    late ButtonFill confirmButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("confirmButton"),
      label: "Terkirim",
      onClick: (){
        Get.toNamed(RoutePage.deliveryConfirmSO, arguments: order)!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
                getDetailOrder();
            });
        });
      }
    );

    late ButtonFill yesSendItem = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesSendItem"),
      label: "Ya",
      onClick: (){
        Get.back();
        isLoading.value =true;
        sendItem();
      }
    );

    ButtonOutline noSendItem = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("noSendItem"),
      label: "Tidak",
      onClick: (){
        Get.back();
      }
    );

    late ButtonFill yesRejectItem = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesRejectItem"),
      label: "Ya",
      onClick: (){
        Get.back();
        Get.toNamed(RoutePage.deliveryRejectSO, arguments: order)!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
                getDetailOrder();
            });
        });
      }
    );

    ButtonOutline noRejectItem = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("noRejectItem"),
      label: "Tidak",
      onClick: (){
        Get.back();
      }
    );

    late Order order;
    late DateTime createdDate;
    @override
    void onInit() {
        super.onInit();
        order = Get.arguments;
        createdDate = Convert.getDatetime(order.createdDate!);
    }
    @override
    void onReady() {
        super.onReady();
        getTotalQuantity(order);
    }

    void getDetailOrder(){
    Service.push(
        service: ListApi.detailOrderById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!,
          ListApi.pathDetailOrderById(order.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet){
              order = (body as OrderResponse).data!;
              getTotalQuantity(order);
              isLoading.value = false;
            },
            onResponseFail: (code, message, body, id, packet){
              isLoading.value = false;
              Get.snackbar(
                "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoading.value = false;
              
            }, onTokenInvalid: Constant.invalidResponse())
    );
  }
    void getTotalQuantity(Order? data){
        sumChick.value =0;
        sumKg.value =0;
        sumPrice.value =0;
        for(var product in data!.products!) {
            if(product!.returnWeight == null ) {
                if (product.category!.name! == AppStrings.LIVE_BIRD ||product.category!.name! == AppStrings.AYAM_UTUH ||product.category!.name! == AppStrings.BRANGKAS){
                    sumChick.value += product.quantity!;
                    sumKg.value += product.weight!;
                    sumPrice.value += product.weight! * product.price!;
                    } else {
                    sumKg.value += product.weight!;
                    sumPrice.value += product.weight! * product.price!;
                }
            } else {
                if (product.category!.name! == AppStrings.LIVE_BIRD ||product.category!.name! == AppStrings.AYAM_UTUH ||product.category!.name! == AppStrings.BRANGKAS){
                    sumChick.value += product.quantity! - product.returnQuantity!;
                    sumKg.value += (product.weight! - product.returnWeight!);
                    sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
                    } else {
                    sumKg.value += (product.weight! - product.returnWeight!);
                    sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
                }
            }
        }
  }

    void sendItem(){
        Service.push(
            service: ListApi.deliveryPickupSO,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathDeliverySOPickup(order.id!),""],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Get.back();
                    isLoading.value =false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value =false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value =false;
                },
                onTokenInvalid: Constant.invalidResponse()));
    }
}

class DeliveryDetailSOBindings extends Bindings {
    BuildContext context;
    DeliveryDetailSOBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DeliveryDetailSOController(context: context));
    }
}