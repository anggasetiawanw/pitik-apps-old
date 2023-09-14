import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class SwitchButtonController extends GetxController {
    String tag;
    SwitchButtonController({required this.tag});

    final FocusNode focusNode = FocusNode();

    var activeField = true.obs;
    var showField = true.obs;
    var showTooltip = false.obs;
    var hideLabel = false.obs;
    var alertText = "".obs;
    var formKey = GlobalKey<FormState>();
    var light = false.obs;
    var switchValue = "".obs;

    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void visibleField() => showField.value = true;
    void invisibleField() => showField.value = false;
    void setOn() => light.value = true;
    void setOff() => light.value = false;

    void setAlertText(String text) => alertText.value = text;

    @override
    void onClose() {
        super.onClose();
        focusNode.dispose();
    }
}

class EditFieldBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<SwitchButtonController>(() => SwitchButtonController(tag: ""));
    }
}
