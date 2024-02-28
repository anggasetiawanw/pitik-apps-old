// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:components/edit_area_field/edit_area_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/model/string_model.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/record_model.dart';

import '../edit_field/edit_field.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class ItemHistoricalSmartCameraController extends GetxController {
  String tag;
  BuildContext context;
  ItemHistoricalSmartCameraController({required this.tag, required this.context});

  Rx<List<int>> index = Rx<List<int>>([]);
  Rx<List<EditField>> efDayTotal = Rx<List<EditField>>([]);
  Rx<List<EditField>> efDecreaseTemp = Rx<List<EditField>>([]);

  var itemCount = 0.obs;
  var expanded = false.obs;
  var isShow = false.obs;
  var isLoadApi = false.obs;
  var numberList = 0.obs;
  var isLoading = false.obs;

  Rx<RecordCamera> recordCamera = (RecordCamera()).obs;

  SpinnerField spCrowdedness =
      SpinnerField(controller: GetXCreator.putSpinnerFieldController('spCameraIsCrowdedness'), label: 'Apakah ayam berkerumun?', hint: 'N/A', alertText: 'Harus diisi..!', items: const {'Ya': false, 'Tidak': false}, onSpinnerSelected: (text) {});

  EditAreaField eaCrowdedness =
      EditAreaField(controller: GetXCreator.putEditAreaFieldController('spCameraCrowdednessRemarks'), label: 'Keterangan Penolakan', hint: 'Tulis keterangan penolakan', alertText: 'Harus diisi..!', maxInput: 300, onTyping: (text, field) {});

  void expand() => expanded.value = true;
  void collapse() => expanded.value = false;
  void visibleCard() => isShow.value = true;
  void invisibleCard() => isShow.value = false;

  void submit() => AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          Service.push(
              apiKey: 'smartCameraApi',
              service: ListApi.submitCrowdedness,
              context: Get.context!,
              body: ['Bearer ${auth.token}', auth.id, 'v2/smart-camera/${recordCamera.value.jobId ?? '-'}/evaluate', spCrowdedness.controller.selectedIndex == 0, eaCrowdedness.getInput()],
              listener: ResponseListener(
                  onResponseDone: (code, message, body, id, packet) {
                    recordCamera.value.isCrowded = (body as StringModel).data['isCrowded'];
                    recordCamera.value.remarks = body.data['remarks'];
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
                  onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                      "Pesan",
                      "Terjadi Kesalahan Internal",
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      backgroundColor: Colors.red,
                    );
                  },
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        } else {
          GlobalVar.invalidResponse();
        }
      });
}

class ItemHistoricalSmartCameraBindings extends Bindings {
  String tag;
  BuildContext context;
  ItemHistoricalSmartCameraBindings({required this.tag, required this.context});

  @override
  void dependencies() {
    Get.lazyPut<ItemHistoricalSmartCameraController>(() => ItemHistoricalSmartCameraController(tag: tag, context: context));
  }
}
