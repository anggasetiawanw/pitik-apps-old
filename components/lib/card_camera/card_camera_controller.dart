// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_field_qr/edit_field_qrcode.dart';
import '../get_x_creator.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class CardCameraController extends GetxController {
    String tag;
    BuildContext context;
    CardCameraController({required this.tag, required this.context});


    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<EditFieldQR>> efCameraId = Rx<List<EditFieldQR>>([]);

    var itemCount = 0.obs;
    var expanded = false.obs;
    var isShow = true.obs;
    var isLoadApi = false.obs;
    var numberList = 0.obs;
    var prefDevice = "".obs;

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;
    void visibleCard() => isShow.value = true;
    void invisibleCard() => isShow.value = false;
    void setPrefixDevice(String prefix) => prefDevice.value = prefix;

    @override
    void onReady() {
        super.onReady();
        addCard();
    }

    addCard() {
        index.value.add(numberList.value);
        int idx = numberList.value;

        efCameraId.value.add(
            EditFieldQR(
                controller: GetXCreator.putEditFieldQRController("efCameraId$idx"),
                label: "Kode Kamera*",
                textPrefix: prefDevice.value,
                hint: "XXXXXX",
                alertText: "Kode Alat Tidak Sesuai",
                textUnit: "",
                isMacAddres: false,
                inputType: TextInputType.text,
                maxInput: 6,
                onTyping: (value, control) {}
            )
        );

        itemCount.value = index.value.length;
        numberList.value++;
    }

    removeCard(int idx) {
        index.value.removeWhere((item) => item == idx);
        itemCount.value = index.value.length;
    }

    List validation() {
        bool isValid = true;
        String error = "";
        for (int i = 0; i < index.value.length; i++) {
            int whichItem = index.value[i];

            if (efCameraId.value[whichItem].getInput().length < 6) {
                efCameraId.value[whichItem].controller.setAlertText("Kode Kamera Tidak Valid!");
                efCameraId.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(efCameraId.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }

            if (efCameraId.value[whichItem].controller.showTooltip.isTrue) {
                Scrollable.ensureVisible(efCameraId.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }
        }

        return [isValid, error];
    }

}

class CardCameraBinding extends Bindings {
    String tag;
    BuildContext context;
    CardCameraBinding({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<CardCameraController>(() => CardCameraController(tag: tag, context: context));
    }
}
