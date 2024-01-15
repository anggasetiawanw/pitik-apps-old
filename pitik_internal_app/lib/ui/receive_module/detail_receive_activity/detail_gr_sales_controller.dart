import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/order_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23


class DetailGrOrderController extends GetxController {
    BuildContext context;
    DetailGrOrderController({required this.context});

    Rxn<Order> orderDetail = Rxn<Order>();
    var sumChick = 0.obs;
    var sumKg =0.0.obs;
    var sumPrice = 0.0.obs;
    ScrollController scrollController = ScrollController();

    var isLoading = false.obs;
    late ButtonFill createGr = ButtonFill(
        controller: GetXCreator.putButtonFillController("createGrOrder"),
        label: "Buat Penerimaan",
        onClick: () => Get.toNamed(RoutePage.createGrOrderPage, arguments: orderDetail.value)!.then((value) {
            isLoading.value =true;
            Timer(const Duration(milliseconds: 500), () {
            getDetailOrder();
            });
        })
    );
    late ButtonFill bookStockButton = ButtonFill(
        controller: GetXCreator.putButtonFillController("bookStock"),
        label: "Pesan Stock",
        onClick: () => Get.toNamed(RoutePage.newBookStock, arguments: orderDetail.value)!.then((value) {
            isLoading.value =true;
            Timer(const Duration(milliseconds: 500), () {
            getDetailOrder();
            });
        })
    );
    late ButtonFill sendButton = ButtonFill(
        controller: GetXCreator.putButtonFillController("sent"),
        label: "Kirim",
        onClick: () => Get.toNamed(RoutePage.assignToDriver, arguments: orderDetail.value)!.then((value) {
            isLoading.value =true;
            Timer(const Duration(milliseconds: 500), () {
            getDetailOrder();
            });
        })
    );
    late ButtonFill editDriver = ButtonFill(
        controller: GetXCreator.putButtonFillController("editDriver"),
        label: "Edit",
        onClick: () => Get.toNamed(RoutePage.assignToDriver, arguments: orderDetail.value)!.then((value) {
            isLoading.value =true;
            Timer(const Duration(milliseconds: 500), () {
            getDetailOrder();
            });
        })
    );
    late ButtonOutline cancelButton = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("cancelOrder"),
        label: "Batal",
        onClick: () => null,
    );

    late ButtonFill bfYesCancel;
    late ButtonOutline boNoCancel;

    @override
    void onInit() {
        super.onInit();
        orderDetail.value = Get.arguments as Order;
        getDetailOrder();
        boNoCancel = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("tidakVisit"),
        label: "Tidak",
        onClick: () {
            Get.back();
        },
        );
    }


    @override
    void onReady() {
        super.onReady();
        bfYesCancel = ButtonFill(
        controller: GetXCreator.putButtonFillController("yesCancel"),
        label: "Ya",
        onClick: () {
            cancelOrder(context);
        },
        );
    }

    void getTotalQuantity(Order? data){
        sumChick.value =0;
        sumKg.value =0;
        sumPrice.value =0;
        for(var product in data!.products!) {
            if(product!.returnWeight != null ) {
                if (product.category!.name! == AppStrings.LIVE_BIRD ||product.category!.name! == AppStrings.AYAM_UTUH ||product.category!.name! == AppStrings.BRANGKAS){
                    sumChick.value += product.returnQuantity!;
                    sumKg.value += product.returnWeight!;
                    sumPrice.value += product.returnWeight! * product.price!;
                    } else {
                    sumKg.value += product.returnWeight!;
                    sumPrice.value += product.returnWeight! * product.price!;
                }
            }
        }
    }

    void getDetailOrder(){
        isLoading.value = true;
        Service.push(
            service: ListApi.detailOrderById,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathDetailOrderById(orderDetail.value!.id!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                List <Products?> product=[];
                for (var result in (body as OrderResponse).data!.products!){
                    if(result!.returnQuantity != null || result.returnWeight != null){
                    product.add(result);
                    }
                }
                orderDetail.value = (body).data;
                orderDetail.value!.products!.clear();
                orderDetail.value!.products = product;
                isLoading.value = false;
                getTotalQuantity(body.data);
                },
                onResponseFail: (code, message, body, id, packet){
                isLoading.value = false;
                Get.snackbar(
                    "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                    );
                },  onTokenInvalid: Constant.invalidResponse())
        );
    }

    void cancelOrder(BuildContext context) {
        String orderId = orderDetail.value!.id!;
        isLoading.value = true;
        Service.push(
            service: ListApi.cancelOrder,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathCancelOrder(orderId),""],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.back();
                },
                onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.snackbar(
                    "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                    );
                },
                onTokenInvalid: () {
                Constant.invalidResponse();
                }
            )
        );
        Get.back();
    }
}

class DetailGrOrderBindings extends Bindings {
  BuildContext context;
  DetailGrOrderBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => DetailGrOrderController(context: context));
  }


}