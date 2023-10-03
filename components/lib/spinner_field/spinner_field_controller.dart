// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class SpinnerFieldController<T> extends GetxController {
    String tag;
    SpinnerFieldController({required this.tag});

    final FocusNode focusNode = FocusNode();
    T? selectedObject;
    RxList<T?> listObject = <T?>[].obs;
    var formKey = GlobalKey<FormState>();
    var showTooltip = false.obs;
    var activeField = true.obs;
    var isShowList = false.obs;
    var hideLabel = false.obs;
    var textSelected = "".obs;
    var selectedIndex = -1.obs;
    Rx<Map<String,bool>> items =Rx<Map<String,bool>>({});
    var amountItems = {}.obs;
    var weightItems = {}.obs;
    var showSpinner = true.obs;
    var isloading =false.obs;

    var alertText = "".obs;

    void visibleSpinner() => showSpinner.value = true;
    void invisibleSpinner() => showSpinner.value = false;
    void setAlertText(String text) => alertText.value = text;
    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void showLoading() => isloading.value = true;
    void hideloading() => isloading.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void expand() => isShowList.value = true;
    void collapse() => isShowList.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void setTextSelected(String text) => textSelected.value = text;
    void setupObjects(List<T?> data) => listObject.value = data;
    void generateItems(Map<String, bool> data) {
        items.value.clear();
        items.value.addAll(data);
        items.refresh();
    } 
    void generateAmount(Map<String, int> data) => amountItems.value = data;
    void generateWeight(Map<String, double> data) => weightItems.value = data;
    void addItems(String value, bool isActive) => items.value.putIfAbsent(value, () => isActive);
    T? getSelectedObject() => selectedObject;

    @override
    void onClose() {
        super.onClose();
        focusNode.dispose();
    }

    
}

class SpinnerFieldBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<SpinnerFieldController>(() => SpinnerFieldController(tag: ""));
    }
}
