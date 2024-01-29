///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 19/05/23

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/sku_card_order/sku_card_order_controller.dart';

class SkuCardOrder extends StatelessWidget {
  final SkuCardOrderController controller;
  const SkuCardOrder({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    controller.isShow.isTrue
        ?
    Column(
      children: controller.index.value.map((int index) {
        return Container(
          margin: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              Container(
                height: 48,
                decoration: const BoxDecoration(
                    color: Color(0xFFFDDAA5),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("SKU ${index + 1}")),
                    GestureDetector(
                        onTap: () {
                          if (index == (controller.index.value[controller.itemCount.value - 1]) || controller.itemCount.value == 1) {
                            controller.addCard();
                          } else {
                            _showBottomDialog(context, index, controller);
                          }
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.transparent,
                            width: 48,
                            height: 48,
                            child: index == (controller.index.value[controller.itemCount.value - 1]) || controller.itemCount.value == 1 ?
                            const Icon(Icons.add, size: 30, color: AppColors.primaryOrange,)
                                :Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset("images/delete_sku.svg", fit: BoxFit.cover, width: 20, height: 20),
                            )
                        )
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(color: AppColors.outlineColor, width: 1),
                    left: BorderSide(color: AppColors.outlineColor, width: 1),
                    right: BorderSide(color: AppColors.outlineColor, width: 1),
                    top: BorderSide(color: AppColors.outlineColor, width: 0.1),
                  ),
                  // border: Border.all(color: AppColors.grey, width: 1),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    controller.spinnerCategories.value[index],
                    Obx(() => controller.isLoadApi.isTrue ? controller.spinnerSku.value[index] : controller.spinnerSku.value[index],),
                    controller.editFieldJumlahAyam.value[index],
                    controller.spinnerTypePotongan.value[index],
                    controller.editFieldPotongan.value[index],
                    controller.editFieldKebutuhan.value[index],
                    controller.editFieldHarga.value[index],
                    index == (controller.index.value[controller.itemCount.value - 1]) && controller.itemCount.value != 1 ?
                    ButtonOutline(
                        controller: GetXCreator.putButtonOutlineController("Cancel$index"),
                        label: "Cancel",
                        onClick: (){
                          _showBottomDialog(context, index, controller);
                        })
                        : const SizedBox(),
                    const SizedBox(height: 16,),
                  ],
                ),
              )
            ],
          ),
        );
      }).toList(),
    )
        : const SizedBox());
  }

  _showBottomDialog(BuildContext context, int index, SkuCardOrderController controller) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                  child: Text(
                    "Apakah kamu yakin ingin menghapus data SKU?",
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Data SKU yang kamu hapus akan hilang secara permanen pastikan kembali sebelum menghapus",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset("images/sku_delete_sheet.svg"),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ButtonFill(
                              controller: GetXCreator.putButtonFillController("iyaSku$index"),
                              label: "Ya",
                              onClick: () {
                                controller.removeCard(index);
                                Get.back();
                              })),
                      const SizedBox(width: 16),
                      Expanded(
                          child: ButtonOutline(
                              controller: GetXCreator.putButtonOutlineController("tidakVisit$index"),
                              label: "Tidak",
                              onClick: () {
                                Get.back();
                              }
                          )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        }
    );
  }
}
