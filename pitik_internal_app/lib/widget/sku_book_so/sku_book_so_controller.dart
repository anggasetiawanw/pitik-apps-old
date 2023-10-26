import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/internal_app/product_model.dart';
class SkuBookSOController extends GetxController {
    String tag;
    List<Products?> products;
    SkuBookSOController({ required this.tag, required this.products});
    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<EditField>> jumlahEkor = Rx<List<EditField>>([]);
    Rx<List<EditField>> jumlahkg = Rx<List<EditField>>([]);

    var itemCount = 0.obs;
    var isShow = true.obs;
    var idx= 0.obs;

    var sumKg = 0.0.obs;
    var sumPrice = 0.0.obs;
    RxMap<int,double?> mapSumKg = <int, double?>{}.obs;


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
            jumlahEkor.value.add(EditField(
                controller: GetXCreator.putEditFieldController(
                    "${products[numberList]!.name!}Ekor $tag"),
                label: "Jumlah Ekor*",
                hint: "0",
                alertText: "Kolom Ini Harus Di Isi",
                textUnit: "Ekor",
                inputType: TextInputType.number,
                maxInput: 20,
                onTyping: (value, control) {
                   
                })
            );
            
            jumlahkg.value.add(EditField(
                controller: GetXCreator.putEditFieldController(
                    "${products[numberList]!.name!}Kg $tag"),
                label: "Kebutuhan*",
                hint: "0.0",
                alertText: "Kolom Ini Harus Di Isi",
                textUnit: "Kg",
                inputType: TextInputType.number,
                maxInput: 20,
                onTyping: (value, control) {
                    mapSumKg[numberList] = control.getInputNumber();
                    refreshtotalPurchase();
                })
            );

            if (!(products[numberList]!.category!.name! == AppStrings.LIVE_BIRD ||products[numberList]!.category!.name! == AppStrings.AYAM_UTUH || products[numberList]!.category!.name! == AppStrings.BRANGKAS)) {        
                jumlahEkor.value[numberList].controller.invisibleField();
                jumlahkg.value[numberList].setInput(products[numberList]!.weight!.toString());
                mapSumKg[numberList] = products[numberList]!.weight;
                refreshtotalPurchase();
            }else{
                jumlahEkor.value[numberList].setInput(products[numberList]!.quantity!.toString());
                jumlahkg.value[numberList].setInput(products[numberList]!.weight!.toString());
                mapSumKg[numberList] = products[numberList]!.weight;
                refreshtotalPurchase();
            }
            itemCount.value = index.value.length;
            idx.value++;
         }

    }

    refreshtotalPurchase(){
        sumKg.value = 0;
        sumPrice.value =0;
        int indexProduct = 0;
        for (var idx in index.value) {
            double kg =  jumlahkg.value[idx].getInputNumber() ?? 0;
            double price = products[indexProduct]!.price ?? 0;
            sumKg.value += kg;
            sumPrice.value += price * kg;
        }
    }
}
class SkuBookSOBindings extends Bindings {
    final List<Products> products;
    final String tag;
    SkuBookSOBindings({required this.products, required this.tag});
    @override
    void dependencies() {
        Get.lazyPut(() => SkuBookSOController(tag : tag, products: products));
    }
}