// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class SuggestFieldController<T> extends GetxController {

    String tag;
    SuggestFieldController({required this.tag});
    FocusNode focusNode = FocusNode();

    Rx<TextEditingController> textEditingController = (TextEditingController()).obs;

    RxList<T?> listObject = <T?>[].obs;
    T? selectedObject;
    var showTooltip = false.obs;
    var activeField = true.obs;
    var hideLabel = false.obs;
    RxList<String> suggestList = <String>[].obs;

    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void visibleLabel() => hideLabel.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void setupObjects(List<T?> data) => listObject.value = data;
    void generateItems(List<String> data) {
        suggestList.clear();
        suggestList.addAll(data);
        suggestList.refresh();
    }
    void addItems(String data) => suggestList.add(data);
    T? getSelectedObject() => selectedObject;
    void reset({useDelayed = false}) {
        Future.delayed(Duration(milliseconds: useDelayed ? 300 : 0), () {
            selectedObject = null;
            textEditingController.value.text = '';
        });
    }
    void setSelectedObject(String textSelected) {
        Future.delayed(const Duration(milliseconds: 500), () {
            int index = 0;
            for (var element in suggestList) {
                if (element == textSelected && listObject.isNotEmpty) {
                    textEditingController.value.text = element;
                    if (listObject.isNotEmpty) {
                        selectedObject = listObject[index];
                    }
                }

                index++;
            }
        });
    }

    void dissmisDialog(){
        focusNode.unfocus();
        textEditingController.value.text = '';
    }
}

class SuggestFieldBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<SuggestFieldController>(() => SuggestFieldController(tag: ""));
    }
}