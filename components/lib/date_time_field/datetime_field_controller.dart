// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class DateTimeFieldController extends GetxController {

    String tag;
    DateTimeFieldController({required this.tag});

    var showTooltip = false.obs;
    var activeField = true.obs;
    var hideLabel = false.obs;
    var textSelected = "".obs;
    var formKey = GlobalKey<FormState>();

    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void setTextSelected(String text) => textSelected.value = text;
}

class DateTimeFieldBinding extends Bindings {

    @override
    void dependencies() {
        Get.lazyPut<DateTimeFieldController>(() => DateTimeFieldController(tag: ""));
    }
}