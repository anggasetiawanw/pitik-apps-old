/// @author [Angga Setiawan Wahyudin]
/// @email [anggasetiaw@gmail.com]
/// @create date 2023-11-15 11:45:06
/// @modify date 2023-11-15 11:45:06
/// @desc [description]
// ignore_for_file: non_constant_identifier_names

import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/report.dart';
import 'package:model/response/dailly_report_response.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';

class DailyReportHomeController extends GetxController {
  BuildContext context;
  DailyReportHomeController({required this.context});

  var isLoadingList = false.obs;
  ScrollController scrollController = ScrollController();



  Coop? coop;
  RxBool isLoading = false.obs;
  RxList<Report?> reportList = <Report?>[].obs;
  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
    getDailyReport();
  }
  // @override
  // void onClose() {
  //     super.onClose();
  // }

  void getDailyReport() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              Service.push(
                  apiKey: ApiMapping.taskApi,
                  service: ListApi.getDailyReport,
                  context: context,
                  body: [
                    'Bearer ${auth.token}',
                    auth.id,
                    ListApi.pathDailyReport(coop!.farmingCycleId!)
                  ],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        reportList.clear();
                        reportList.addAll((body as DailyReportResponse).data);
                        isLoadingList.value = false;
                      },
                      onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        isLoading.value = false;
                      },
                      onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan Internal",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        isLoading.value = false;
                      },
                      onTokenInvalid: () => GlobalVar.invalidResponse()))
            }
          else
            {GlobalVar.invalidResponse()}
        });
  }
}

class DailyReportHomeBindings extends Bindings {
  BuildContext context;
  DailyReportHomeBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => DailyReportHomeController(context: context));
  }
}
