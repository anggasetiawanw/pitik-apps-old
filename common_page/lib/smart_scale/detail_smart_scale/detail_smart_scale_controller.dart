// ignore_for_file: slash_for_doc_comments

import 'package:common_page/library/dao_impl_library.dart';
import 'package:common_page/smart_scale/bundle/smart_scale_weighing_bundle.dart';
import 'package:common_page/smart_scale/weighing_smart_scale/smart_scale_weighing.dart';
import 'package:components/custom_dialog.dart';
import 'package:components/global_var.dart';
import 'package:components/listener/custom_dialog_listener.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/smart_scale_response.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.idd>
/// @create date 08/09/2023

class DetailSmartScaleController extends GetxController {
  BuildContext context;
  DetailSmartScaleController({required this.context});

  late String id;
  late Coop coop;
  late SmartScaleWeighingBundle bundle;
  late CustomDialog dialog;

  Rx<SmartScale> smartScale = (SmartScale()).obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    id = Get.arguments[1];
    bundle = Get.arguments[2];
    dialog = CustomDialog(Get.context!, Dialogs.YES_OPTION);

    isLoading.value = true;
    _getSmartScaleWeighingDetail();
  }

  /// The function `rescale()` displays a dialog box with a message asking the
  /// user if they want to replace the existing weighing data with a new one.
  void rescale() {
    dialog
        .listener(CustomDialogListener(
            onDialogOk: (BuildContext context, int id, List<dynamic> packet) {
              GlobalVar.track("Click_smart_rescale");
              Get.off(SmartScaleWeighingActivity(), arguments: [coop, bundle, smartScale.value]);
            },
            onDialogCancel: (BuildContext context, int id, List<dynamic> packet) {}))
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
  void _getSmartScaleWeighingDetail() => AuthImpl().get().then((auth) {
        if (auth != null) {
          Service.push(
              apiKey: "smartScaleApi",
              service: bundle.routeDetail(),
              context: context,
              body: bundle.getBodyDetail(this, auth),
              listener: ResponseListener(
                  onResponseDone: (code, message, body, id, packet) {
                    smartScale.value = SmartScale();
                    smartScale.value = (body as SmartScaleResponse).data!;
                    isLoading.value = false;
                  },
                  onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                      "Pesan",
                      "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      backgroundColor: Colors.red,
                    );
                  },
                  onResponseError: (exception, stacktrace, id, packet) => isLoading.value = false,
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        } else {
          GlobalVar.invalidResponse();
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
    late String executionDate;
    if (smartScale.value.executionDate != null) {
      DateTime executionDateTime = Convert.getDatetime(smartScale.value.executionDate!);
      executionDate = '${Convert.getYear(executionDateTime)}/${Convert.getMonthNumber(executionDateTime)}/${Convert.getDay(executionDateTime)}';
    } else if (smartScale.value.date != null) {
      DateTime executionDateTime = Convert.getDatetime(smartScale.value.date!);
      executionDate = '${Convert.getYear(executionDateTime)}/${Convert.getMonthNumber(executionDateTime)}/${Convert.getDay(executionDateTime)}';
    } else {
      return false;
    }

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
