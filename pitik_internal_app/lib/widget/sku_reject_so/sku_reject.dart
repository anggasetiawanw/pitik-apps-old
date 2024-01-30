import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/sku_reject_so/sku_reject_controller.dart';

class SkuReject extends StatelessWidget {
    final SkuRejectController controller;
  const SkuReject({
    super.key,
    required this.controller
  });
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
                        Obx(() => Checkbox(
                            value: controller.selectedValue.value[index],
                            side: const BorderSide(color: AppColors.primaryOrange, width: 2),
                            activeColor: AppColors.primaryOrange ,
                            onChanged: (value){
                                controller.selectedValue.value[index] = !controller.selectedValue.value[index];
                                controller.selectedValue.refresh();
                        })),
                        Text("SKU ${index+1}", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),),
                    ],
                    ),
                ),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.outlineColor, width: 1),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
                    ),
                    child: Column(
                        children: [
                            infoDetailSKU("Kategori SKU", "${controller.products[index]!.category!.name}"),
                            infoDetailSKU("SKU", "${controller.products[index]!.name}"),
                            if(controller.products[index]!.quantity != null  && controller.products[index]!.quantity != 0 )  infoDetailSKU("Total Ekor", "${controller.products[index]!.quantity} Ekor"),
                            if (controller.products[index]!.cutType != null) infoDetailSKU("Jenis Potong", Constant.getTypePotongan(controller.products[index]!.cutType!)),
                            if (controller.products[index]!.cutType == "REGULAR") infoDetailSKU("Potongan", "${controller.products[index]!.numberOfCuts} Potong"),
                            infoDetailSKU("Kebutuhan", "${controller.products[index]!.weight} Kg"),
                            infoDetailSKU("Harga", Convert.toCurrency("${controller.products[index]!.price}", "Rp. ", ".")),
                            controller.jumlahEkorDitolak.value[index],
                            controller.jumlahKgDitolak.value[index],
                            const SizedBox(height: 14,)
                        ],
                    ),
                ),
            ],
        );
    },).toList());

  }
}