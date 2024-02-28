import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

class EditFieldTwoRowController extends GetxController {
  String tag;
  EditFieldTwoRowController({required this.tag});

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  var activeField = true.obs;
  var showField = true.obs;
  var showTooltip = false.obs;
  var hideLabel = false.obs;
  var alertText = "".obs;
  var formKey = GlobalKey<FormState>();

  void showAlert() => showTooltip.value = true;
  void hideAlert() => showTooltip.value = false;
  void enable() => activeField.value = true;
  void disable() => activeField.value = false;
  void invisibleLabel() => hideLabel.value = true;
  void visibleLabel() => hideLabel.value = false;
  void visibleField() => showField.value = true;
  void invisibleField() => showField.value = false;

  void setAlertText(String text) => alertText.value = text;

  @override
  void onClose() {
    super.onClose();
    focusNode1.dispose();
    focusNode2.dispose();
  }
}

class EditFieldTwoRowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditFieldTwoRowController>(() => EditFieldTwoRowController(tag: ""));
  }
}
