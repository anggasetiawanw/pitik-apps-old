import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant.dart';
import '../../../widget/common/loading.dart';
import 'new_data_purchase_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 10/04/23

class NewDataPurchase extends StatelessWidget {
  const NewDataPurchase({super.key});

  @override
  Widget build(BuildContext context) {
    final NewDataPurchaseController controller = Get.put(NewDataPurchaseController(context: context));

    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          'Pembelian',
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget buttonFormPurchase() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ButtonFill(
                  controller: GetXCreator.putButtonFillController('saveDataPurchase'),
                  label: 'Simpan',
                  onClick: () {
                    Constant.track('Click_Simpan_Pembelian');
                    controller.status.value = 'DRAFT';
                    controller.savePurchase();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ButtonOutline(
                  controller: GetXCreator.putButtonOutlineController('confirmDataPurchase'),
                  label: 'Konfirmasi',
                  onClick: () {
                    _showBottomDialog(context, controller, 'CONFIRMED');
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar(),
        ),
        body: Obx(
          () => controller.isLoading.isTrue
              ? const Center(child: ProgressLoading())
              : Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            controller.spinnerTypeSource,
                            controller.spinnerSource,
                            controller.spinnerDestination,
                            controller.skuCard,
                            controller.skuCardInternal,
                            Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppColors.outlineColor, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: controller.efTotalKG),
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(top: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                border: Border.all(color: AppColors.outlineColor, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  if (controller.isInternal.isTrue) ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Pembelian',
                                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Kg',
                                            style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        Text(
                                          controller.skuCardInternal.controller.sumNeededMax.value - controller.skuCardInternal.controller.sumNeededMin.value == 0
                                              ? '${controller.skuCardInternal.controller.sumNeededMin.value.toStringAsFixed(2)} Kg'
                                              : '${controller.skuCardInternal.controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.skuCardInternal.controller.sumNeededMax.value.toStringAsFixed(2)} Kg',
                                          style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Ekor',
                                            style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        Obx(() => Text(
                                              '${controller.skuCardInternal.controller.sumChick.value} Ekor',
                                              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                              overflow: TextOverflow.clip,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Rp',
                                            style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        Text(
                                            controller.skuCardInternal.controller.sumPriceMax.value - controller.skuCardInternal.controller.sumPriceMin.value == 0
                                                ? controller.skuCardInternal.controller.sumPriceMin.value == 0
                                                    ? 'Rp - '
                                                    : NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(controller.skuCardInternal.controller.sumPriceMin.value)
                                                : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.skuCardInternal.controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.skuCardInternal.controller.sumPriceMax.value)}",
                                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip),
                                      ],
                                    )
                                  ] else ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Pembelian',
                                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Kg',
                                            style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        Text(
                                          controller.skuCard.controller.sumNeededMax.value - controller.skuCard.controller.sumNeededMin.value == 0
                                              ? '${controller.skuCard.controller.sumNeededMin.value.toStringAsFixed(2)} Kg'
                                              : '${controller.skuCard.controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.skuCard.controller.sumNeededMax.value.toStringAsFixed(2)} Kg',
                                          style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Ekor',
                                            style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        Obx(() => Text(
                                              '${controller.skuCard.controller.sumChick.value} Ekor',
                                              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                              overflow: TextOverflow.clip,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total Rp',
                                            style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        Text(
                                            controller.skuCard.controller.sumPriceMax.value - controller.skuCard.controller.sumPriceMin.value == 0
                                                ? NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(controller.skuCard.controller.sumPriceMin.value)
                                                : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.skuCard.controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.skuCard.controller.sumPriceMax.value)}",
                                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip),
                                      ],
                                    )
                                  ]
                                ],
                              ),
                            ),
                            controller.efRemark,
                            const SizedBox(height: 100)
                          ],
                        ),
                      ),
                    ),
                    buttonFormPurchase(),
                  ],
                ),
        ));
  }

  Future<void> _showBottomDialog(BuildContext context, NewDataPurchaseController controller, String status) {
    controller.status.value = status;
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
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
                    'Apakah kamu yakin data yang dimasukan sudah benar?',
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text('Pastikan semua data yang kamu masukan semua sudah benar', style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    'images/visit_customer.svg',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.iyaVisitButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.tidakVisitButton),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Constant.bottomSheetMargin,
                )
              ],
            ),
          );
        });
  }
}
