import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/internal_app/product_model.dart';
class SkuRejectController extends GetxController {
    String tag;
    List<Products?> products;
    SkuRejectController({ required this.tag, required this.products});
    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<EditField>> jumlahEkorDitolak = Rx<List<EditField>>([]);
    Rx<List<EditField>> jumlahKgDitolak = Rx<List<EditField>>([]);
    Rx<List<bool>> selectedValue = Rx<List<bool>>([]);

    var itemCount = 0.obs;
    var isShow = true.obs;
    var idx= 0.obs;


    void visibleCard() => isShow.value = true;
    void invisibleCard() => isShow.value = false;
    @override
    void onInit() {
        super.onInit();

        addCard();
    }

    addCard(){
        for (var _ in products) {
            index.value.add(idx.value);
            int numberList = idx.value;
            selectedValue.value.add(false);
            jumlahEkorDitolak.value.add(EditField(
                controller: GetXCreator.putEditFieldController(
                    "jumlahEkorDitolak${numberList}Sku"),
                label: "Jumlah Ekor Ditolak*",
                hint: "Ketik di sini",
                alertText: "Kolom Ini Harus Di Isi",
                textUnit: "Ekor",
                inputType: TextInputType.number,
                maxInput: 20,
                onTyping: (value, control) {
                })
            );
            
            jumlahKgDitolak.value.add(EditField(
                controller: GetXCreator.putEditFieldController(
                    "jumlahKgDitolak${numberList}Sku"),
                label: "Jumlah Kg Ditolak*",
                hint: "Ketik di sini",
                alertText: "Kolom Ini Harus Di Isi",
                textUnit: "Kg",
                inputType: TextInputType.number,
                maxInput: 20,
                onTyping: (value, control) {
                })
            );

            if (!(products[numberList]!.category!.name! == AppStrings.LIVE_BIRD ||products[numberList]!.category!.name! == AppStrings.AYAM_UTUH || products[numberList]!.category!.name! == AppStrings.BRANGKAS)) {        
                jumlahEkorDitolak.value[numberList].controller.invisibleField();
            }
            itemCount.value = index.value.length;
            idx.value++;
         }

    }
}
class SkuRejectBindings extends Bindings {
    final List<Products> products;
    final String tag;
    SkuRejectBindings({required this.products, required this.tag});
    @override
    void dependencies() {
        Get.lazyPut(() => SkuRejectController(tag : tag, products: products));
    }
}