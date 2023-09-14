import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class TimePickerController extends GetxController {

    String tag;
    TimePickerController({required this.tag});

    var showTooltip = false.obs;
    var activeField = true.obs;
    var hideLabel = false.obs;
    var textSeleted = "".obs;
    var hours = "".obs;
    var formKey = GlobalKey<FormState>();

    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void setTextSelected(String text) => textSeleted.value = text;
}

class DateTimeFieldBinding extends Bindings {

    @override
    void dependencies() {
        Get.lazyPut<TimePickerController>(() => TimePickerController(tag: ""));
    }
}