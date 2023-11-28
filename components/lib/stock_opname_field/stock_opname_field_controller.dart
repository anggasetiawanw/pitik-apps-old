import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/internal_app/product_model.dart';

class StockOpnameFieldController extends GetxController {
  String tag;
  StockOpnameFieldController({required this.tag});
  Rx<List<EditField>> efSku = Rx<List<EditField>>([]);
  var title = "".obs;

  void generateEf(Products product) {
    efSku.value.clear();
    product.productItems!.sort((a, b) => a!.name!.compareTo(b!.name!));
    for (var element in product.productItems!) {
      efSku.value.add(EditField(
        controller: GetXCreator.putEditFieldController(element!.name!),
        label: element.name!,
        hint: "0",
        alertText: "Kolom ini harus di isi",
        textUnit: product.quantityUOM ?? product.weightUOM!,
        maxInput: 50,
        onTyping: (value, control) {},
        action: TextInputAction.next,
        inputType: TextInputType.number,
      ));
      efSku.refresh();
    }
  }

  void setDefault(Products products) {
    // int idx = 0
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      //products.productItems!.sort((a,b) => a!.name!.compareTo(b!.name!));
      for (var product in products.productItems!) {
        EditField sku = efSku.value.firstWhere((element) => element.controller.tag == product!.name!);
        sku.setInput(products.name == AppStrings.LIVE_BIRD || products.name == AppStrings.AYAM_UTUH || products.name == AppStrings.BRANGKAS ? (product!.quantity == 0 ? "" : product.quantity.toString()) : (product!.weight == null ? "" : product.weight.toString()));
      }
    });
  }
}

class StockOpnameFieldBindings extends Bindings {
  String tag;
  StockOpnameFieldBindings({required this.tag});
  @override
  void dependencies() {
    Get.lazyPut(() => StockOpnameFieldController(tag: tag));
  }
}
