import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';

import '../../../utils/constant.dart';
import '../../../widget/common/loading.dart';
import '../../../widget/common/purchase_status.dart';
import 'create_receive_purchase_jagal_controller.dart';
import 'create_receive_purchase_vendor_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 29/05/23

class CreateGrPurchaseJagal extends GetView<CreateGrPurchaseController> {
  const CreateGrPurchaseJagal({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateGrPurchaseJagalController controller = Get.put(CreateGrPurchaseJagalController(context: context));

    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          'Form Penerimaan Jagal',
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget detailPurchase() {
      final DateTime createdDate = Convert.getDatetime(controller.purchaseDetail.value!.createdDate!);
      return Container(
        margin: const EdgeInsets.only(top: 16, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            border: Border.all(
              width: 1,
              color: AppColors.outlineColor,
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detail Pembelian',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                ),
                PurchaseStatus(purchaseStatus: controller.purchaseDetail.value!.status),
              ],
            ),
            Text(
              '${controller.purchaseDetail.value!.code} - ${createdDate.day} ${DateFormat.MMM().format(createdDate)} ${createdDate.year}',
              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
              overflow: TextOverflow.clip,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sumber',
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.purchaseDetail.value!.operationUnit!.type ?? '-',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tujuan',
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  "${controller.purchaseDetail.value!.jagal != null ? controller.purchaseDetail.value!.jagal!.operationUnitName : "-"}",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );
    }

    Widget bottomNavBar() {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                    controller.purchaseDetail.value!.status == 'CONFIRMED'
                        ? Expanded(
                            child: ButtonFill(
                            controller: GetXCreator.putButtonFillController('saveGRPurchase'),
                            label: 'Simpan',
                            onClick: () {
                              controller.isValid() ? showBottomDialog(context, controller) : null;
                            },
                          ))
                        : controller.purchaseDetail.value!.status == 'RECEIVED'
                            ? Expanded(
                                child: ButtonFill(
                                controller: GetXCreator.putButtonFillController('cancelGRPurchase'),
                                label: 'Batal',
                                onClick: () {
                                  controller.isValid() ? showBottomDialog(context, controller) : null;
                                },
                              ))
                            : const SizedBox(
                                width: 16,
                              ),
                    const SizedBox()
                  ],
                ),
              ),
            ],
          ));
    }

    Widget infoDetailSku(String title, String name) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
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

    Widget customSku(Products products) {
      return Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(color: AppColors.headerSku, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            child: Text(
              '${products.name}',
              style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16, bottom: 0, left: 16, right: 16),
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
                infoDetailSku('Kategori SKU', '${products.category!.name}'),
                infoDetailSku('SKU', '${products.name}'),
                products.quantity != 0 ? infoDetailSku('Jumlah Ekor', '${products.quantity} Ekor') : const SizedBox(),
                if (products.weight != 0) infoDetailSku('Kebutuhan', '${products.weight!} Kg'),
                infoDetailSku('Harga', "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar(),
        ),
        body: Stack(
          children: [
            Obx(() => controller.isLoading.isTrue
                ? const Center(
                    child: ProgressLoading(),
                  )
                : SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          detailPurchase(),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Detail SKU',
                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                            overflow: TextOverflow.clip,
                          ),
                          Column(
                            children: controller.purchaseDetail.value!.products!.map((e) => customSku(e!)).toList(),
                          ),
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
                                      controller.sumNeededMax.value - controller.sumNeededMin.value == 0
                                          ? '${controller.sumNeededMin.value.toStringAsFixed(2)} Kg'
                                          : '${controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.sumNeededMax.value.toStringAsFixed(2)} Kg',
                                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                if (controller.sumChick.value != 0) ...[
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
                                            '${controller.sumChick.value} Ekor',
                                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
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
                                        controller.sumPriceMax.value - controller.sumPriceMin.value == 0
                                            ? NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(controller.sumPriceMin.value)
                                            : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPriceMax.value)}",
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                        overflow: TextOverflow.clip),
                                  ],
                                )
                              ],
                            ),
                          ),
                          controller.efRemark,
                          const SizedBox(
                            height: 120,
                          )
                        ],
                      ),
                    ),
                  )),
            bottomNavBar()
          ],
        ));
  }

  Future<void> showBottomDialog(BuildContext context, CreateGrPurchaseJagalController controller) {
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
                      Expanded(child: controller.bfYesGrPurchase),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: controller.boNoGrPurchase,
                      ),
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
