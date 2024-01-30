import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_request.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card_gr/sku_card_gr.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23

class CreateGrOrderController extends GetxController {
  BuildContext context;

  CreateGrOrderController({required this.context});

  late ButtonFill yesSendButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesSendGrSOButton"),
      label: "Ya",
      onClick: () {
        GlobalVar.track("Click_Konfirmasi_Penerimaan_Penjualan");
        saveGrOrder();
        Get.back();
      });
  ButtonOutline noSendButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("noSendGrSOButton"),
      label: "Tidak",
      onClick: () {
        Get.back();
      });

  EditField efChickReceived = EditField(
    controller: GetXCreator.putEditFieldController("sumChickReceived"),
    label: "Jumlah Ekor Diterima*",
    hint: "Ketik disini",
    alertText: "Jumlah Ekor harus diisi!",
    textUnit: "Ekor",
    maxInput: 20,
    onTyping: (value, controller) {},
    inputType: TextInputType.number,
  );
  EditField efWeightReceived = EditField(
    controller: GetXCreator.putEditFieldController("totalWeightReceived"),
    label: "Jumlah Kg Diterima*",
    hint: "Ketik disini",
    alertText: "Total Kg harus diisi!",
    textUnit: "Kg",
    maxInput: 20,
    onTyping: (value, controller) {},
    inputType: TextInputType.number,
  );

  var isLoading = false.obs;
  late Order orderDetail;
  late DateTime createdDate;
  late SkuCardGr skuCardGr;

  DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
    orderDetail = Get.arguments;
    createdDate = Convert.getDatetime(orderDetail.createdDate!);
    skuCardGr = SkuCardGr(
      controller: InternalControllerCreator.putSkuCardGrOrder("skuGr", orderDetail.products!),
    );
  }

  @override
  void onReady() {
    super.onReady();
    loadData(orderDetail);
  }

  void saveGrOrder() {
    isLoading.value = true;
    PurchaseRequest grPayload = generatePayload();
    Service.push(
      service: ListApi.createGoodReceived,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, Mapper.asJsonString(grPayload)],
      listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
        isLoading.value = false;
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

  bool isValid() {
    try {
      List ret = skuCardGr.controller.validation();
      if (ret[0]) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return true;
    }
  }

  PurchaseRequest generatePayload() {
    List<Products?> listProductPayload = [];
    for (int i = 0; i < orderDetail.products!.length; i++) {
      listProductPayload.add(Products(
        productItemId: orderDetail.products![i]!.productItemId!,
        quantity: skuCardGr.controller.efSumChickReceived.value[i].getInput().isEmpty ? 0 : skuCardGr.controller.efSumChickReceived.value[i].getInputNumber()!.toInt(),
        weight: skuCardGr.controller.efSumWeightReceived.value[i].getInputNumber(),
        price: orderDetail.products![i]!.price,
      ));
    }

    return PurchaseRequest(
      products: listProductPayload,
      salesOrderId: orderDetail.id!,
    );
  }

  void loadData(Order order) {
    if (order.products!.isNotEmpty && order.products != null) {
      Timer(const Duration(milliseconds: 500), () {
        for (int i = 0; i < order.products!.length - 1; i++) {
          skuCardGr.controller.addCard();
        }
      });
    }
    timeEnd = DateTime.now();
    Duration totalTime = timeEnd.difference(timeStart);
    GlobalVar.trackRenderTime("Buat_Penerimaan_Penjualan", totalTime);
  }
}

class CreateGrOrderBindings extends Bindings {
  BuildContext context;
  CreateGrOrderBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => CreateGrOrderController(context: context));
  }
}
