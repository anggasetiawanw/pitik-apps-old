import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/internal_app/product_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 09/06/23

class SkuCardGrController extends GetxController {
  String tag;
  List<Products?> products;
  SkuCardGrController({required this.tag, required this.products});
  Rx<List<int>> index = Rx<List<int>>([]);
  Rx<List<EditField>> efSumChickReceived = Rx<List<EditField>>([]);
  Rx<List<EditField>> efSumWeightReceived = Rx<List<EditField>>([]);
  Rx<List<bool>> selectedValue = Rx<List<bool>>([]);
  var sumChick = 0.obs;
  var sumNeeded = 0.obs;
  RxMap<int, double?> mapSumChick = <int, double?>{}.obs;
  RxMap<int, double?> mapSumNeeded = <int, double?>{}.obs;

  var itemCount = 0.obs;
  var isShow = true.obs;

  void visibleCard() => isShow.value = true;
  void invisibleCard() => isShow.value = false;
  @override
  void onInit() {
    super.onInit();

    addCard();
  }

  void addCard() {
    final int idx = itemCount.value;
    for (var _ in products) {
      index.value.add(itemCount.value);
      selectedValue.value.add(false);
      efSumChickReceived.value.add(EditField(
          controller: GetXCreator.putEditFieldController('efSumChickReceived${index.value[itemCount.value] + 1}Sku'),
          label: 'Jumlah Ekor Diterima*',
          hint: 'Ketik di sini',
          alertText: 'Kolom Ini Harus Di Isi',
          textUnit: 'Ekor',
          inputType: TextInputType.number,
          maxInput: 20,
          onTyping: (value, control) {
            mapSumChick[idx] = control.getInputNumber();
            refreshSumChick();
          }));

      efSumWeightReceived.value.add(EditField(
          controller: GetXCreator.putEditFieldController('efSumWeightReceived${index.value[itemCount.value] + 1}Sku'),
          label: 'Jumlah Kg Diterima*',
          hint: 'Ketik di sini',
          alertText: 'Kolom Ini Harus Di Isi',
          textUnit: 'Kg',
          inputType: TextInputType.number,
          maxInput: 20,
          onTyping: (value, control) {
            mapSumNeeded[idx] = control.getInputNumber();
            refreshSumNeeded();
          }));

      itemCount.value = index.value.length;
    }
  }

  void refreshSumChick() {
    sumChick.value = 0;
    mapSumChick.forEach((key, value) {
      if (value != null) {
        sumChick.value += value.toInt();
      }
    });
  }

  void refreshSumNeeded() {
    sumNeeded.value = 0;
    mapSumNeeded.forEach((key, value) {
      if (value != null) {
        sumNeeded.value += value.toInt();
      }
    });
  }

  List<dynamic> validation() {
    bool isValid = true;
    const String error = '';
    for (int i = 0; i < index.value.length; i++) {
      final int whichItem = index.value[i];
      if (products[whichItem]!.category!.name == AppStrings.AYAM_UTUH ||
          products[whichItem]!.category!.name == AppStrings.KARKAS ||
          products[whichItem]!.category!.name == AppStrings.BRANGKAS ||
          products[whichItem]!.category!.name == AppStrings.LIVE_BIRD) {
        if (efSumChickReceived.value[whichItem].getInput().isEmpty) {
          efSumChickReceived.value[whichItem].controller.showAlert();
          Scrollable.ensureVisible(efSumChickReceived.value[whichItem].controller.formKey.currentContext!);
          isValid = false;
          return [isValid, error];
        }
      }

      if (efSumWeightReceived.value[whichItem].getInput().isEmpty) {
        efSumWeightReceived.value[whichItem].controller.showAlert();
        Scrollable.ensureVisible(efSumWeightReceived.value[whichItem].controller.formKey.currentContext!);
        isValid = false;
        return [isValid, error];
      }
    }

    return [isValid, error];
  }
}

class SkuCardGrBindings extends Bindings {
  final List<Products> products;
  final String tag;
  SkuCardGrBindings({required this.products, required this.tag});
  @override
  void dependencies() {
    Get.lazyPut(() => SkuCardGrController(tag: tag, products: products));
  }
}
