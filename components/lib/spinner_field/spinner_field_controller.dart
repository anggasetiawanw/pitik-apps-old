// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

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
    RxMap<String, bool> items = RxMap<String, bool>({});
    var amountItems = {}.obs;
    var weightItems = {}.obs;
    var showSpinner = true.obs;
    var isLoading =false.obs;
    var alertText = "".obs;

    void visibleSpinner() => showSpinner.value = true;
    void invisibleSpinner() => showSpinner.value = false;
    void setAlertText(String text) => alertText.value = text;
    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void showLoading() => isLoading.value = true;
    void hideLoading() => isLoading.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void expand() => isShowList.value = true;
    void collapse() => isShowList.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void setTextSelected(String text) => textSelected.value = text;
    void setupObjects(List<T?> data) => listObject.value = data;
    void rejuvenateObjects() {
        int index = 0;
        items.forEach((key, value) {
            if (value) {
                setTextSelected(key);
                selectedIndex = index;

                // for selected object
                if (listObject.isNotEmpty) {
                    selectedObject = listObject[selectedIndex];
                }
            }

            index++;
        });
    }
    void generateItems(Map<String, bool> data) {
        items.clear();
        items.addAll(data);
        items.refresh();
    }
    void generateAmount(Map<String, int> data) => amountItems.value = data;
    void generateWeight(Map<String, double> data) => weightItems.value = data;
    void addItems({required String value, required bool isActive, int milisecondsDelayed = 200}) => Future.delayed(Duration(milliseconds: milisecondsDelayed), () => items[value] = isActive);
    T? getSelectedObject() => selectedObject;
    void reset() {
        selectedObject = null;
        selectedIndex = -1;
        setTextSelected('');
    }
    void setSelected(String textSelected) => Future.delayed(const Duration(milliseconds: 500), () {
        int index = 0;
        items.forEach((key, value) {
            if (key == textSelected) {
                setTextSelected(key);
                selectedIndex = index;
                items[key] = true;

                // for selected object
                if (listObject.isNotEmpty) {
                    selectedObject = listObject[selectedIndex];
                }
            } else {
                items[key] = false;
            }

            index++;
        });
    });

}

class SpinnerFieldBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<SpinnerFieldController>(() => SpinnerFieldController(tag: ""));
    }
}
