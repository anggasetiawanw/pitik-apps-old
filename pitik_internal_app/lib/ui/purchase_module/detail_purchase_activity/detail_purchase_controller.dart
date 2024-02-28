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
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/response/internal_app/purchase_response.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';
import '../../../utils/route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 12/04/23

class DetailPurchaseController extends GetxController {
  BuildContext context;
  DetailPurchaseController({required this.context});

  Rxn<Purchase> purchaseDetail = Rxn<Purchase>();
  ScrollController scrollController = ScrollController();

  var isLoading = false.obs;
  var sumChick = 0.obs;
  var sumNeededMin = 0.0.obs;
  var sumNeededMax = 0.0.obs;
  var sumPriceMin = 0.0.obs;
  var sumPriceMax = 0.0.obs;
  late ButtonFill editButton = ButtonFill(
      controller: GetXCreator.putButtonFillController('editPurchase'),
      label: 'Edit',
      onClick: () {
        Constant.track('Click_Edit_Pembelian');
        Get.toNamed(RoutePage.purchaseEditPage, arguments: purchaseDetail.value)!.then((value) {
          isLoading.value = true;
          Timer(const Duration(milliseconds: 500), () {
            getDetailPurchase();
          });
        });
      });
  late ButtonOutline cancelButton = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController('cancelPurchase'),
    label: 'Batal',
    onClick: () => null,
  );

  late ButtonFill bfYesCancel;
  late ButtonOutline boNoCancel;
  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  @override
  void onInit() {
    timeStart = DateTime.now();
    super.onInit();
    purchaseDetail.value = Get.arguments as Purchase;
    getDetailPurchase();
    boNoCancel = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController('tidakVisit'),
      label: 'Tidak',
      onClick: () {
        Get.back();
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    bfYesCancel = ButtonFill(
      controller: GetXCreator.putButtonFillController('yesCancel'),
      label: 'Ya',
      onClick: () {
        cancelPurchase(context);
      },
    );
  }

  void getDetailPurchase() {
    isLoading.value = true;
    Service.push(
        service: ListApi.detailPurchaseById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathDetailPurchaseById(purchaseDetail.value!.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              purchaseDetail.value = (body as PurchaseResponse).data;
              getTotalQuantity(body.data);
              purchaseDetail.value!.status == 'CONFIRMED' ? editButton.controller.disable() : editButton.controller.enable();
              isLoading.value = false;
              timeEnd = DateTime.now();
              final Duration totalTime = timeEnd.difference(timeStart);
              Constant.trackWithMap('Render_Time', {'Page': 'Detail_Pembelian', 'value': '${totalTime.inHours} hours : ${totalTime.inMinutes} minutes : ${totalTime.inSeconds} seconds : ${totalTime.inMilliseconds} miliseconds'});
            },
            onResponseFail: (code, message, body, id, packet) {},
            onResponseError: (exception, stacktrace, id, packet) {},
            onTokenInvalid: () {
              Constant.invalidResponse();
            }));
  }

  void getTotalQuantity(Purchase? data) {
    sumNeededMin.value = 0;
    sumNeededMax.value = 0;
    sumChick.value = 0;
    sumPriceMax.value = 0;
    sumPriceMin.value = 0;
    for (var product in data!.products!) {
      if (product!.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS) {
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
    }
  }

  void cancelPurchase(BuildContext context) {
    final String purchaseid = purchaseDetail.value!.id!;
    isLoading.value = true;
    Constant.trackWithMap('Click_Batal_Pembelian', {'Status': '${purchaseDetail.value!.status}'});
    Service.push(
        service: ListApi.cancelPurchase,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathCancelPurchase(purchaseid)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Get.back();
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
              Constant.trackWithMap('Click_Batal_Pembelian', {'error': '${body.error!.message}'});
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi kesalahan internal',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );

              Constant.trackWithMap('Click_Batal_Pembelian', {'error': exception});
              //  isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
    Get.back();
  }
}

class DetailPurchaseBindings extends Bindings {
  BuildContext context;
  DetailPurchaseBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => DetailPurchaseController(context: context));
  }
}
