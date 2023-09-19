import 'package:components/edit_field_two_row/edit_field_two_row.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/internal_app/product_model.dart';
class StockOpnameTwoFieldController extends GetxController {
    String tag;
    StockOpnameTwoFieldController({required this.tag});
    Rx<List<EditFieldTwoRow>> efSku = Rx<List<EditFieldTwoRow>>([]);

    void generateEf(Products product){

        product.productItems!.sort((a,b) => a!.name!.compareTo(b!.name!));
        for (var element in product.productItems!) {
            efSku.value.add(EditFieldTwoRow(controller: GetXCreator.putEditFieldTwoRowController(element!.name!), label: "${element.name!}*", hint: "0", alertText: "Kolom ini harus di isi", textUnit1: product.quantityUOM!,textUnit2: product.weightUOM!, maxInput: 50, onTyping1: (value,control){}, onTyping2: (value,control){}, action: TextInputAction.next,inputType: TextInputType.number,));
            efSku.refresh();
        }
    }
    void setDefault(Products products){
        // int idx = 0

        products.productItems!.sort((a,b) => a!.name!.compareTo(b!.name!));
        for (var product in products.productItems!) { 
            EditFieldTwoRow sku = efSku.value.firstWhere((element) => element.controller.tag == product!.name!);
            sku.setInput1(product!.quantity == null ? "" : product.quantity.toString());
            sku.setInput2(product.weight == null ? "" :product.weight.toString());
        }
    }
}
class StockOpnameTwoFieldBindings extends Bindings {
    String tag;
    StockOpnameTwoFieldBindings({required this.tag});
    @override
    void dependencies() {
        Get.lazyPut(() => StockOpnameTwoFieldController(tag: tag));
    }
}