import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:model/response/internal_app/transfer_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class TransferHomeController extends GetxController {
  BuildContext context;
  TransferHomeController({required this.context});

  late ButtonFill createTransfer = ButtonFill(
      controller: GetXCreator.putButtonFillController("createTransfer"),
      label: "Buat Transfer",
      onClick: () {
        GlobalVar.track("Click_Buat_Transfer");
        Get.toNamed(RoutePage.transferForm, arguments: [null, false])!.then((value) {
          isLoading.value = true;
          listTransfer.value.clear();
          page.value = 0;
          Timer(const Duration(milliseconds: 500), () {
            getListTransfer();
          });
        });
      });

  ScrollController scrollController = ScrollController();

  var page = 1.obs;
  var limit = 10.obs;

  Rx<List<TransferModel?>> listTransfer = Rx<List<TransferModel>>([]);
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();
  @override
  void onReady() {
    super.onReady();

    isLoading.value = true;
    getListTransfer();
    scrollListener();
  }

  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        page++;
        getListTransfer();
      }
    });
  }

  void pullRefresh(){
    isLoading.value = true;
    listTransfer.value.clear();
    page.value = 1;
    getListTransfer();
  }

  void getListTransfer() {
    timeStart = DateTime.now();
    Service.push(
        service: ListApi.getListInternalTransfer,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListTransferResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listTransfer.value.add(result as TransferModel);
                }
                isLoading.value = false;
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  page.value = (listTransfer.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoading.value = false;
                }
              }
                timeEnd = DateTime.now();
                Duration totalTime = timeEnd.difference(timeStart);
                GlobalVar.trackRenderTime("Data_Transfer", totalTime);
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
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
                "Terjadi Kesalahan, $stacktrace",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );

              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}

class TransferHomeBindings extends Bindings {
  BuildContext context;
  TransferHomeBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => TransferHomeController(context: context));
  }
}
