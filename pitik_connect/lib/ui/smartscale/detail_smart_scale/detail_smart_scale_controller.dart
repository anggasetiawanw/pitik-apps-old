// ignore_for_file: slash_for_doc_comments

import 'package:components/custom_dialog.dart';
import 'package:components/global_var.dart';
import 'package:components/listener/custom_dialog_listener.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/smart_scale_response.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

import '../../../route.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 08/09/2023
 */

class DetailSmartScaleController extends GetxController {
    BuildContext context;
    DetailSmartScaleController({required this.context});

    late String id;
    late Coop coop;
    late CustomDialog dialog;

    Rx<SmartScale> smartScale = (SmartScale()).obs;
    var isLoading = false.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        id = Get.arguments[1];
        dialog = CustomDialog(Get.context!, Dialogs.YES_OPTION);

        getSmartScaleWeighingDetail();
        isLoading.value = true;
    }

    int getTotalChicken() {
        int count = 0;
        for (var element in smartScale.value.records) {
            count += element!.count!;
        }
        return count;
    }

    double getTonase() {
        double count = 0.0;
        for (var element in smartScale.value.records) {
            count += element!.weight!;
        }
        return count;
    }

    double getAverageWeight() {
        int i;
        double sumWeight = 0;
        int sumChicken = 0;
        for (i = 0; i < smartScale.value.records.length ; i++) {
            sumWeight = sumWeight + smartScale.value.records[i]!.weight!;
            sumChicken = sumChicken + smartScale.value.records[i]!.count!;
        }

        return sumWeight / sumChicken;
    }

    String getStartWeighing() {
        DateTime startWeighingTime = Convert.getDatetime(smartScale.value.startDate!);
        return "${Convert.getYear(startWeighingTime)}/${Convert.getMonthNumber(startWeighingTime)}/${Convert.getDay(startWeighingTime)} - ${Convert.getHour(startWeighingTime)}.${Convert.getMinute(startWeighingTime)}";
    }

    String getEndWeighing() {
        DateTime endWeighingTime = Convert.getDatetime(smartScale.value.executionDate!);
        return "${Convert.getYear(endWeighingTime)}/${Convert.getMonthNumber(endWeighingTime)}/${Convert.getDay(endWeighingTime)} - ${Convert.getHour(endWeighingTime)}.${Convert.getMinute(endWeighingTime)}";
    }

    /// The function `rescale()` displays a dialog box with a message asking the
    /// user if they want to replace the existing weighing data with a new one.
    void rescale() {
        dialog.listener(CustomDialogListener(
            onDialogOk: (BuildContext context, int id, List<dynamic> packet) {
                GlobalVar.track("Click_smart_rescale");
                Get.offNamed(RoutePage.weighingSmartScalePage, arguments: [coop, smartScale.value]);
            },
            onDialogCancel: (BuildContext context, int id, List<dynamic> packet) {}
        ))
        .barrierDismiss(true)
        .title('Informasi!')
        .message('Penimbangan harian hari ini sudah dilakukan. Timbang kembali akan mengganti data hasil penimbangan yang sudah ada. Apakah anda ingin mengganti hasil penimbangan yang telah dilakukan?')
        .show();
    }

    /// The function `getSmartScaleWeighingDetail` retrieves smart scale weighing
    /// details based on a boolean flag indicating whether it is a new request or
    /// not.
    ///
    /// Args:
    ///   isNew (bool): isNew is a boolean parameter that indicates whether the
    /// weighing detail is new or not. If isNew is true, it means that the weighing
    /// detail is new and needs to be fetched. If isNew is false, it means that the
    /// weighing detail already exists and does not need to be fetched again.
    void getSmartScaleWeighingDetail() => AuthImpl().get().then((auth) => {
        if (auth != null) {
            Service.push(
                apiKey: "smartScaleApi",
                service: ListApi.getSmartScaleDetail,
                context: context,
                body: [auth.token, auth.id, ListApi.pathSmartScaleForDetailAndUpdate(id)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        smartScale.value = SmartScale();
                        smartScale.value = (body as SmartScaleResponse).data!;
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
                    onResponseError: (exception, stacktrace, id, packet) => isLoading.value = false,
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            )
        } else {
            GlobalVar.invalidResponse()
        }
    });

    /// The function checks if the execution date of a SmartScale object is the same
    /// as the current date.
    ///
    /// Args:
    ///   smartScale (SmartScale): The `smartScale` parameter is an instance of the
    /// `SmartScale` class. It is used to access the `executionDate` property, which
    /// represents the date when the smart scale is executed.
    ///
    /// Returns:
    ///   a boolean value.
    bool isThisDay() {
        DateTime executionDateTime = Convert.getDatetime(smartScale.value.executionDate!);
        String executionDate = '${Convert.getYear(executionDateTime)}/${Convert.getMonthNumber(executionDateTime)}/${Convert.getDay(executionDateTime)}';

        DateTime now = DateTime.now();
        String nowDate = '${Convert.getYear(now)}/${Convert.getMonthNumber(now)}/${Convert.getDay(now)}';

        return executionDate == nowDate;
    }
}

class DetailSmartScaleBinding extends Bindings {
    BuildContext context;
    DetailSmartScaleBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<DetailSmartScaleController>(() => DetailSmartScaleController(context: context));
    }
}