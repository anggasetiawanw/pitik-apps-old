import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/terminate_model.dart';
import 'package:model/response/internal_app/list_terminate_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class TerminateHomeController extends GetxController {
  BuildContext context;
  TerminateHomeController({required this.context});

  ScrollController scrollController = ScrollController();

  var page = 1.obs;
  var limit = 10.obs;

  Rx<List<TerminateModel?>> listTerminate = Rx<List<TerminateModel>>([]);
  var isLoading = false.obs;
  var isLoadMore = false.obs;

  late ButtonFill createTerminate = ButtonFill(
      controller: GetXCreator.putButtonFillController("createTerminate"),
      label: "Buat Pemusnahan",
      onClick: () {
        GlobalVar.track("Click_Buat_Pemusnahan");
        Get.toNamed(RoutePage.terminateForm, arguments: [null, false])!.then((value) {
          isLoading.value = true;
          listTerminate.value.clear();
          page.value = 0;
          Timer(const Duration(milliseconds: 500), () {
            getListTerminate();
          });
        });
      });

  DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    scrollListener();
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    getListTerminate();
  }

  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        page++;
        getListTerminate();
      }
    });
  }

  void pullRefresh(){
    isLoading.value = true;
    listTerminate.value.clear();
    page.value = 1;
    getListTerminate();
  }

  void getListTerminate() {
    Service.push(
        service: ListApi.getListTerminate,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListTerminateResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listTerminate.value.add(result as TerminateModel);
                }
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
                isLoading.value = false;
              } else {
                if (isLoadMore.isTrue) {
                  page.value = (listTerminate.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoading.value = false;
                }
              }
              timeEnd = DateTime.now();
              Duration totalTime = timeEnd.difference(timeStart);
              GlobalVar.trackRenderTime("Data_Pemusnahan", totalTime);
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

class TerminateHomeBindings extends Bindings {
  BuildContext context;
  TerminateHomeBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => TerminateHomeController(context: context));
  }
}
