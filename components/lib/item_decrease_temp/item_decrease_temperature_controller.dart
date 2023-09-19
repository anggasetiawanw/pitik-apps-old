
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_field/edit_field.dart';
import '../get_x_creator.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ItemDecreaseTemperatureController extends GetxController {
    String tag;
    BuildContext context;
    ItemDecreaseTemperatureController({required this.tag, required this.context});

    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<EditField>> efDayTotal = Rx<List<EditField>>([]);
    Rx<List<EditField>> efDecreaseTemp = Rx<List<EditField>>([]);

    var itemCount = 0.obs;
    var expanded = false.obs;
    var isShow = true.obs;
    var isLoadApi = false.obs;
    var numberList = 0.obs;

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;
    void visibleCard() => isShow.value = true;
    void invisibleCard() => isShow.value = false;

    @override
    void onReady() {
        super.onReady();
        addCard();
    }

    addCard() {
        index.value.add(numberList.value);
        int idx = numberList.value;

        efDayTotal.value.add(
            EditField(
                controller: GetXCreator.putEditFieldController("efDayTotal$idx"),
                label: "Total Hari",
                hint: "Ketik di sini",
                alertText: "Kolom Ini Harus Di Isi",
                textUnit: "Hari",
                inputType: TextInputType.number,
                maxInput: 50,
                onTyping: (value, control) {}
            )
        );

        efDecreaseTemp.value.add(
            EditField(
                controller: GetXCreator.putEditFieldController("efDecreaseTemp$idx"),
                label: "Pengurangan Suhu",
                hint: "Ketik di sini",
                textUnit: "°C",
                alertText: "Kolom Ini Harus Di Isi",
                inputType: TextInputType.number,
                maxInput: 4,
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

    removeAll() {
        index.value.clear();
        efDayTotal.value.clear();
        efDecreaseTemp.value.clear();
        itemCount.value =0;
        numberList.value=0;
        index.refresh();
        efDayTotal.refresh();
        efDecreaseTemp.refresh();
    }

    List validation() {
        bool isValid = true;
        String error = "";
        for (int i = 0; i < index.value.length; i++) {
            int whichItem = index.value[i];
            if (efDayTotal.value[whichItem].getInput().isEmpty) {
                efDayTotal.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(efDayTotal.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }
            if (efDecreaseTemp.value[whichItem].getInput().isEmpty) {
                efDecreaseTemp.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(efDecreaseTemp.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }
        }

        return [isValid, error];
    }
}

class ItemDecreaseTemperatureBindings extends Bindings {
    String tag;
    BuildContext context;
    ItemDecreaseTemperatureBindings({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ItemDecreaseTemperatureController>(() => ItemDecreaseTemperatureController(tag: tag, context: context));
    }
}
