import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/convert.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/terminate_model.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class TerminateDetailController extends GetxController {
  BuildContext context;
  TerminateDetailController({required this.context});
  late ButtonFill yesCancelButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesButton"),
      label: "Ya",
      onClick: () {
        Get.back();
        if (terminateModel.status == "FINISHED") {
          updateTerminate("BOOKED");
        } else {
          updateTerminate("CANCELLED");
        }
      });
  ButtonOutline noCancelButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("No Button"),
      label: "Tidak",
      onClick: () {
        Get.back();
      });

  late ButtonFill yesTerminateButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesSendButton"),
      label: "Ya",
      onClick: () {
        Get.back();
        updateTerminate("FINISHED");
      });
  ButtonOutline noTerminateButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("NoSendButton"),
      label: "Tidak",
      onClick: () {
        Get.back();
      });

  late ButtonFill yesOrderStockButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesSendButton"),
      label: "Ya",
      onClick: () {
        Get.back();
        updateTerminate("BOOKED");
      });
  ButtonOutline noOrderStockButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("NoSendButton"),
      label: "Tidak",
      onClick: () {
        Get.back();
      });
  late ButtonFill btSetujui = ButtonFill(
      controller: GetXCreator.putButtonFillController("btSetujui"),
      label: "Setujui",
      onClick: () {
        Get.toNamed(RoutePage.terminateApprove, arguments: terminateModel)!.then((value) {
          isLoading.value = true;
          Timer(const Duration(milliseconds: 500), () {
            getDetailTerminate();
          });
        });
      });
  late ButtonOutline btTolak = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("btTolak"),
      label: "Tolak",
      onClick: () {
        Get.toNamed(RoutePage.terminateRejected, arguments: terminateModel)!.then((value) {
          isLoading.value = true;
          Timer(const Duration(milliseconds: 500), () {
            getDetailTerminate();
          });
        });
      });
  var isLoading = false.obs;
  late TerminateModel terminateModel;
  late DateTime createdDate;
  @override
  void onInit() {
    super.onInit();
    terminateModel = Get.arguments;
    createdDate = Convert.getDatetime(terminateModel.createdDate!);

    initializeDateFormatting();
  }

  void updateTerminate(String status) {
    isLoading.value = true;
    Service.push(
        service: ListApi.updateTerminateById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateTerminateById(terminateModel.id!), Mapper.asJsonString(generatePayload(status))],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Get.back();
              isLoading.value = false;
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body).error!.message}",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
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
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  TerminateModel generatePayload(String status) {
    return TerminateModel(operationUnitId: terminateModel.operationUnit!.id, status: status, imageLink: terminateModel.imageLink, product: Products(productItemId: terminateModel.product!.productItem!.id, quantity: terminateModel.product!.productItem!.quantity, weight: terminateModel.product!.productItem!.weight));
  }

  void getDetailTerminate() {
    Service.push(
        service: ListApi.detailTerminateById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetDetailTerminateById(terminateModel.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              terminateModel = body.data;
              isLoading.value = false;
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = true;
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
              isLoading.value = true;
              Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}

class TerminateDetailBindings extends Bindings {
  BuildContext context;
  TerminateDetailBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => TerminateDetailController(context: context));
  }
}
