import 'package:flutter/material.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/widget/sku_card_gr/sku_card_gr_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 09/06/23

class SkuCardGr extends StatelessWidget {
    final SkuCardGrController controller;
    const SkuCardGr({super.key, required this.controller});

    @override
    Widget build(BuildContext context) {

      Widget infoDetailSKU(String title, String name){
        return Container(
          margin: const EdgeInsets.only(top: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),),
              Text(name, style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),)
            ],
          ),
        );
      }

      return Column(  children: controller.index.value.map((int index) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              height: 48,
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                  color: AppColors.headerSku,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: Text("SKU ${index+1}", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),),
                  )

                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.outlineColor, width: 1),
                  left: BorderSide(color: AppColors.outlineColor, width: 1),
                  right: BorderSide(color: AppColors.outlineColor, width: 1),
                  top: BorderSide(color: AppColors.outlineColor, width: 0.1),
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              ),
              child: Column(
                children: [
                  infoDetailSKU("Kategori SKU", "${controller.products[index]!.category!.name}"),
                  infoDetailSKU("SKU", "${controller.products[index]!.name}"),
                  controller.products[index]!.returnQuantity != null ?  controller.products[index]!.returnQuantity !=0 ?infoDetailSKU("Jumlah Ekor", "${controller.products[index]!.returnQuantity} Ekor") : const SizedBox() : controller.products[index]!.quantity != null  && controller.products[index]!.quantity !=0  ? infoDetailSKU("Jumlah Ekor", "${controller.products[index]!.quantity} Ekor") : const SizedBox(),
                  controller.products[index]!.numberOfCuts != 0 && controller.products[index]!.numberOfCuts != null  ? infoDetailSKU("Potongan", "${controller.products[index]!.numberOfCuts} Potong") : const SizedBox(),
                  controller.products[index]!.returnWeight != null ?  controller.products[index]!.returnWeight !=0 ?infoDetailSKU("Kebutuhan", "${controller.products[index]!.returnWeight} Kg") : const SizedBox() : controller.products[index]!.weight != null  && controller.products[index]!.weight !=0  ? infoDetailSKU("Kebutuhan", "${controller.products[index]!.weight} Kg") : const SizedBox(),
                  infoDetailSKU("Harga", Convert.toCurrency("${controller.products[index]!.price}", "Rp. ", ".")),
                  controller.products[index]!.category!.name == AppStrings.AYAM_UTUH || controller.products[index]!.category!.name == AppStrings.BRANGKAS || controller.products[index]!.category!.name == AppStrings.LIVE_BIRD ?controller.efSumChickReceived.value[index] : const SizedBox(),
                  controller.efSumWeightReceived.value[index],
                  const SizedBox(height: 14,)
                ],
              ),
            ),
          ],
        );
      },).toList());
    }
}
