import 'package:flutter/material.dart';
import 'package:global_variable/global_variable.dart';
import '../../utils/constant.dart';
import 'sku_book_so_controller.dart';

class SkuBookSO extends StatelessWidget {
  final SkuBookSOController controller;
  const SkuBookSO({required this.controller, super.key});
  @override
  Widget build(BuildContext context) {
    Widget infoDetailSKU(String title, String name) {
      return Container(
        margin: const EdgeInsets.only(top: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
            ),
            Text(
              name,
              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
            )
          ],
        ),
      );
    }

    return Column(
        children: controller.index.value.map(
      (int index) {
        return Column(
          children: [
            Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(color: AppColors.headerSku, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'SKU ${index + 1}',
                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
                    ))),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(border: Border.all(color: AppColors.outlineColor, width: 1), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
              child: Column(
                children: [
                  if (controller.products[index]!.productCategoryId == null) ...[
                    infoDetailSKU('Kategori SKU', '${controller.isRemarks ? controller.products[index]!.name : controller.products[index]!.category?.name}'),
                    if (!controller.isRemarks) infoDetailSKU('SKU', '${controller.products[index]!.name}'),
                    if (controller.products[index]!.cutType != null && Constant.havePotongan(controller.products[index]!.category?.name)) infoDetailSKU('Jenis Potong', Constant.getTypePotongan(controller.products[index]!.cutType!)),
                    if (controller.products[index]!.cutType == 'REGULAR' && Constant.havePotongan(controller.products[index]!.category?.name)) infoDetailSKU('Potongan', '${controller.products[index]!.numberOfCuts} Potong'),
                    if (controller.products[index]!.price != null) infoDetailSKU('Harga', "${Convert.toCurrency("${controller.products[index]!.price}", "Rp. ", ".")}/kg"),
                    controller.jumlahEkor.value[index],
                    if (!controller.isRemarks) controller.jumlahkg.value[index],
                    const SizedBox(
                      height: 14,
                    )
                  ] else ...[
                    infoDetailSKU('Kategori SKU', '${controller.isRemarks ? controller.products[index]!.name : controller.products[index]!.category?.name}'),
                    if (!controller.isRemarks) infoDetailSKU('SKU', '${controller.products[index]!.name}'),
                    if (controller.products[index]!.cutType != null && Constant.havePotongan(controller.products[index]!.name)) infoDetailSKU('Jenis Potong', Constant.getTypePotongan(controller.products[index]!.cutType!)),
                    if (controller.products[index]!.cutType == 'REGULAR' && Constant.havePotongan(controller.products[index]!.name)) infoDetailSKU('Potongan', '${controller.products[index]!.numberOfCuts} Potong'),
                    if (controller.products[index]!.price != null) infoDetailSKU('Harga', "${Convert.toCurrency("${controller.products[index]!.price}", "Rp. ", ".")}/kg"),
                    controller.jumlahEkor.value[index],
                    if (!controller.isRemarks) controller.jumlahkg.value[index],
                    const SizedBox(
                      height: 14,
                    )
                  ]
                ],
              ),
            ),
          ],
        );
      },
    ).toList());
  }
}
