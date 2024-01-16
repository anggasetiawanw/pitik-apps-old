import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/order_request.dart';
import 'package:model/response/internal_app/order_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/so_status.dart';
import 'package:pitik_internal_app/utils/route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23

class DetailSalesOrderController extends GetxController {
  BuildContext context;
  DetailSalesOrderController({required this.context});

  Rxn<Order> orderDetail = Rxn<Order>();
  ScrollController scrollController = ScrollController();

  var isShopkeeper = false.obs;
  var isScRelation = false.obs;
  var sumChick = 0.obs;
  var sumNeededMin = 0.0.obs;
  var sumNeededMax = 0.0.obs;
  var sumPriceMin = 0.0.obs;
  var sumPriceMax = 0.0.obs;
  var sumKg = 0.0.obs;
  var sumPrice = 0.0.obs;
  var isLoading = false.obs;
  var isDeliveryPrice = false.obs;
  var priceDelivery = 0.obs;
  late ButtonFill editButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("OrderEdit"),
      label: "Edit",
      onClick: () => Get.toNamed(RoutePage.editDataSalesOrder, arguments: orderDetail.value)!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
              getDetailOrder();
            });
          }));
  late ButtonFill bookStockButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("bookStock"),
      label: "Pesan Stock",
      onClick: () => Get.toNamed(RoutePage.newBookStock, arguments: [orderDetail.value, false])!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
              getDetailOrder();
            });
          }));
  late ButtonFill sendButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("sent"),
      label: "Kirim",
      onClick: () => Get.toNamed(RoutePage.assignToDriver, arguments: orderDetail.value)!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
              getDetailOrder();
            });
          }));
  late ButtonFill editDriver = ButtonFill(
      controller: GetXCreator.putButtonFillController("editDriver"),
      label: "Edit",
      onClick: () => Get.toNamed(RoutePage.assignToDriver, arguments: orderDetail.value)!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
              getDetailOrder();
            });
          }));
  late ButtonOutline cancelButton = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController("cancelOrder"),
    label: "Batal",
    onClick: () => null,
  );

  late ButtonFill bfYesCancel;
  late ButtonOutline boNoCancel;

  late ButtonFill alocatedButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("alocatedButton"),
      label: "Alokasikan",
      onClick: () => Get.toNamed(RoutePage.newBookStock, arguments: [orderDetail.value,true])!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
              getDetailOrder();
            });
          }));

  late ButtonFill konfirmasiButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("konfirmasiButton"),
      label: "Konfirmasi",
      onClick: () => Get.toNamed(RoutePage.assignToDriver, arguments: orderDetail.value)!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
              getDetailOrder();
            });
          }));

    DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
    orderDetail.value = Get.arguments as Order;
    isShopkeeper.value = Constant.isShopKepper.value;
    isScRelation.value = Constant.isScRelation.value;
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

  void getDetailOrder() {
    isLoading.value = true;
    Service.push(
        service: ListApi.detailOrderById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathDetailOrderById(orderDetail.value!.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              orderDetail.value = (body as OrderResponse).data;
              getTotalQuantity((body).data);
              isLoading.value = false;
                timeEnd = DateTime.now();
                Duration totalTime = timeEnd.difference(timeStart);
                GlobalVar.trackRenderTime("Detail_Penjualan", totalTime);
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = false;
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
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void cancelOrder(BuildContext context) {
    String orderId = orderDetail.value!.id!;
    isLoading.value = true;
    Service.push(
        service: ListApi.cancelOrder,
        context: context,
        body: [
          Constant.auth!.token,
          Constant.auth!.id,
          Constant.xAppId,
          orderDetail.value!.status! == EnumSO.booked
              ? ListApi.pathCancelBookedOrder(orderId)
              : orderDetail.value!.status! == EnumSO.readyToDeliver
                  ? ListApi.pathCancelDeliveryOrder(orderId)
              : orderDetail.value!.status! == EnumSO.allocated
                  ? ListApi.pathCancelAllocated(orderId)
                  : ListApi.pathCancelOrder(orderId),
          ""
        ],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
          isLoading.value = false;
          GlobalVar.trackWithMap("Click_Button_Batal_Penjualan", {"Category_Penjualan": orderDetail.value?.category, "Before Status" : orderDetail.value?.status, "After Status" : body.data?.status});
          Get.back();
        }, onResponseFail: (code, message, body, id, packet) {
          isLoading.value = false;
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          GlobalVar.trackWithMap("Click_Button_Batal_Penjualan", {"Category_Penjualan": orderDetail.value?.category, "Before Status" : orderDetail.value?.status, "Error" : message});
        }, onResponseError: (exception, stacktrace, id, packet) {
          isLoading.value = false;
          Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
          GlobalVar.trackWithMap("Click_Button_Batal_Penjualan", {"Category_Penjualan": orderDetail.value?.category, "Before Status" : orderDetail.value?.status, "Error" : exception});
        }, onTokenInvalid: () {
          Constant.invalidResponse();
        }));
    Get.back();
  }

  void getTotalQuantity(Order? data) {
    sumNeededMin.value = 0;
    sumNeededMax.value = 0;
    sumChick.value = 0;
    sumPriceMax.value = 0;
    sumPriceMin.value = 0;
    sumKg.value = 0;
    sumPrice.value = 0;
    isDeliveryPrice.value = data!.deliveryFee != null && data.deliveryFee != 0;
    priceDelivery.value = data.deliveryFee?? 0;
    if (orderDetail.value!.status == EnumSO.booked || orderDetail.value!.status == EnumSO.readyToDeliver|| orderDetail.value!.status == EnumSO.onDelivery || orderDetail.value!.status == EnumSO.delivered|| orderDetail.value!.status == EnumSO.received|| orderDetail.value!.status == EnumSO.rejected) {
      for (var product in data.products!) {
        if (product!.returnWeight == null) {
          if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
            sumChick.value += product.quantity!;
            sumKg.value += product.weight!;
            sumPrice.value += product.weight! * product.price!;
          } else {
            sumKg.value += product.weight!;
            sumPrice.value += product.weight! * product.price!;
          }
        } else {
          if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
            sumChick.value += product.quantity! - product.returnQuantity!;
            sumKg.value += (product.weight! - product.returnWeight!);
            sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
          } else {
            sumKg.value += (product.weight! - product.returnWeight!);
            sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
          }
        }
      }
    } else {
      for (var product in data.products!) {
        if (product!.returnWeight == null) {
          if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
            sumNeededMin.value += product.quantity! * product.minValue!;
            sumNeededMax.value += product.quantity! * product.maxValue!;
            sumChick.value += product.quantity!;
            sumPriceMin.value += product.price! * (product.minValue! * product.quantity!);
            sumPriceMax.value += product.price! * (product.maxValue! * product.quantity!);
          } else {
            sumNeededMin.value += product.weight!;
            sumNeededMax.value += product.weight!;
            sumPriceMin.value += product.weight! * product.price!;
            sumPriceMax.value += product.weight! * product.price!;
          }
        } else {
          if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
            sumNeededMin.value += (product.quantity! - product.returnQuantity!) * product.minValue!;
            sumNeededMax.value += (product.quantity! - product.returnQuantity!) * product.maxValue!;
            sumChick.value += product.quantity! - product.returnQuantity!;
            sumPriceMin.value += product.price! * (product.minValue! * (product.quantity! - product.returnQuantity!));
            sumPriceMax.value += product.price! * (product.maxValue! * (product.quantity! - product.returnQuantity!));
          } else {
            sumNeededMin.value += (product.weight! - product.returnWeight!);
            sumNeededMax.value += (product.weight! - product.returnWeight!);
            sumPriceMin.value += (product.weight! - product.returnWeight!) * product.price!;
            sumPriceMax.value += (product.weight! - product.returnWeight!) * product.price!;
          }
        }
      }
    }
  }

  void cancelBooked() {
    isLoading.value = true;
    OrderRequest orderPayload = generatePayload();
    Service.push(
      service: ListApi.editSalesOrder,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathEditSalesOrder(orderDetail.value!.id!), Mapper.asJsonString(orderPayload)],
      listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
        isLoading.value = false;
        Get.back();
        Get.back();
      }, onResponseFail: (code, message, body, id, packet) {
        isLoading.value = false;
        Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
      }, onResponseError: (exception, stacktrace, id, packet) {
        isLoading.value = false;
        Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
      }, onTokenInvalid: () {
        Constant.invalidResponse();
      }),
    );
  }

  OrderRequest generatePayload() {
    return OrderRequest(
      customerId: orderDetail.value!.customerId!,
      operationUnitId: orderDetail.value!.operationUnitId,
      products: orderDetail.value!.products,
      status: orderDetail.value!.status,
    );
  }
}

class DetailSalesOrderBindings extends Bindings {
  BuildContext context;
  DetailSalesOrderBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => DetailSalesOrderController(context: context));
  }
}
