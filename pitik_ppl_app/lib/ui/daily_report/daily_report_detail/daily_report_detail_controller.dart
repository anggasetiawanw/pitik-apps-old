import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
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
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';

class DailyReportDetailController extends GetxController {
  BuildContext context;
  DailyReportDetailController({required this.context});
  Coop? coop;
  Report? report;
  Report? reportDetail;

  RxBool isLoading = false.obs;

  ButtonFill btEdit = ButtonFill(controller: GetXCreator.putButtonFillController("editDailyReportDetail"), label: "Edit", onClick: () {});
  ButtonFill btDataBenar = ButtonFill(controller: GetXCreator.putButtonFillController("Data BenarDailyReportDetail"), label: "Data Benar", onClick: () {});
  ButtonOutline btEditOutline = ButtonOutline(controller: GetXCreator.putButtonOutlineController("editDailyReportDetailOutline "), label: "Edit", onClick: () {});
  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    report = Get.arguments[1];
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    getDetailReport();
  }
  // @override
  // void onClose() {
  //     super.onClose();
  // }

  void getDetailReport() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              Service.push(
                  apiKey: ApiMapping.taskApi,
                  service: ListApi.getDetailDailyReport,
                  context: context,
                  body: ['Bearer ${auth.token}', auth.id, ListApi.pathDailyReportDetail(coop!.farmingCycleId!, report!.taskTicketId!)],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        reportDetail = body.data as Report;
                        isLoading.value = false;
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
                        print(stacktrace);
                      },
                      onTokenInvalid: () => GlobalVar.invalidResponse()))
            }
          else
            {GlobalVar.invalidResponse()}
        });
  }
}

class DailyReportDetailBindings extends Bindings {
  BuildContext context;
  DailyReportDetailBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => DailyReportDetailController(context: context));
  }
}
