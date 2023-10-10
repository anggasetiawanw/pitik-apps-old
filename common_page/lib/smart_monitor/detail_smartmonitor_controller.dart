
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_summary_model.dart';
import 'package:model/error/error.dart';
import 'package:model/graph_line.dart';
import 'package:model/response/latest_condition_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class DetailSmartMonitorController extends GetxController {
    BuildContext context;
    Coop? coop;
    Device? device;
    DetailSmartMonitorController({required this.context, this.coop, this.device});


    ScrollController scrollController = ScrollController();
    Rx<List<GraphLine>> historicalList = Rx<List<GraphLine>>([]);
    var deviceUpdatedName = "".obs;

    var isLoadMore = false.obs;
    var pageSmartMonitor = 1.obs;
    var limit = 10.obs;

    DeviceSummary? deviceSummary;

    ScrollController scrollMonitorController = ScrollController();

    scrollPurchaseListener() async {
        scrollMonitorController.addListener(() {
            if (scrollMonitorController.position.maxScrollExtent == scrollMonitorController.position.pixels) {
                isLoadMore.value = true;
                pageSmartMonitor++;
            }
        });
    }

    var isLoading = false.obs;

    @override
    void onInit() {
        super.onInit();
        if (Get.arguments != null) {
            coop = Get.arguments[0];

            if (Get.arguments.length > 1) {
                device = Get.arguments[1];
            }
        }

        isLoading.value = true;
        getLatestDataSmartMonitor();
    }

    /// The function `getLatestDataSmartMonitor` retrieves the latest data from a
    /// smart monitor device and updates the device summary.
    void getLatestDataSmartMonitor() {
        isLoading.value = true;
        List request = [];

        if (device == null) {
            request = [
                GlobalVar.auth!.token,
                GlobalVar.auth!.id,
                coop!.farmingCycleId,
                null
            ];
        } else {
            request = [
                GlobalVar.auth!.token,
                GlobalVar.auth!.id,
                GlobalVar.xAppId,
                ListApi.pathLatestCondition(device!.deviceId!)
            ];
        }

        Service.push(
            apiKey: 'smartMonitoringApi',
            service: ListApi.getLatestCondition,
            context: context,
            body: request,
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    if (!(body as LatestConditionResponse).data!.isNullObject()) {
                        deviceSummary = (body).data;
                    }
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
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

                }, onTokenInvalid: () => GlobalVar.invalidResponse()
            )
        );
    }
}

class DetailSmartMonitorBindings extends Bindings {
    BuildContext context;
    DetailSmartMonitorBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => DetailSmartMonitorController(context: context));
    }
}
