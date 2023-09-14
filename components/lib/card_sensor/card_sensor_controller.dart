
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_field_qr/edit_field_qrcode.dart';
import '../get_x_creator.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class CardSensorController extends GetxController {
    String tag;
    BuildContext context;
    CardSensorController({required this.tag, required this.context});

    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<EditFieldQR>> efSensorId = Rx<List<EditFieldQR>>([]);

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
    void onInit() {
        super.onInit();
    }

    @override
    void onReady() {
        super.onReady();
        addCard();
    }

    @override
    void onClose() {
        super.onClose();
    }

    addCard() {
        index.value.add(numberList.value);
        int idx = numberList.value;

        efSensorId.value.add(EditFieldQR(
            controller: GetXCreator.putEditFieldQRController(
                "efSensorId${idx}"),
            label: "Sensor ID*",
            textPrefix: prefDevice.value,
            hint: "XXXXXX",
            alertText: "Kode Alat Tidak Sesuai",
            textUnit: "",
            isMacAddres: false,
            inputType: TextInputType.text,
            maxInput: 6,
            onTyping: (value, control) {
            }
        ));

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


            if (efSensorId.value[whichItem].getInput().length < 6) {
                efSensorId.value[whichItem].controller.setAlertText("Sensor Id Tidak Valid!");
                efSensorId.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(efSensorId.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }

            if (efSensorId.value[whichItem].controller.showTooltip.isTrue) {
                Scrollable.ensureVisible(efSensorId.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }
        }

        return [isValid, error];
    }

}

class CardSensorBInding extends Bindings {
    String tag;
    BuildContext context;
    CardSensorBInding({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<CardSensorController>(() => CardSensorController(tag: tag, context: context));
    }
}
