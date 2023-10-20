import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/sales_order_module/new_sales_order/new_data_sales_order_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23

class NewDataSalesOrder extends StatelessWidget {
  const NewDataSalesOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final NewDataSalesOrderController controller = Get.put(NewDataSalesOrderController(context: context));

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
            "Penjualan",
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
                    controller: GetXCreator.putButtonFillController("saveDataSalesOrder"),
                    label: "Simpan",
                    onClick: () {
                        controller.status.value = "DRAFT";
                        controller.saveOrder();
                    },
                    ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: ButtonOutline(
                    controller: GetXCreator.putButtonOutlineController("confirmDataSalesOrder"),
                    label: "Konfirmasi",
                    onClick: () {
                        controller.status.value = "CONFIRMED";
                        _showBottomDialog(context, controller);
                    },
                    ),
                ),
                ],
            ),
            ),
        );
    }

    Widget cardSKULB() {
      return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            Container(
              height: 48,
              decoration: const BoxDecoration(color: Color(0xFFFDDAA5), borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: const Text("SKU")),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.outlineColor, width: 1),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              ),
              child: Column(
                children: [
                  controller.spinnerCategories,
                  controller.spinnerSku,
                  controller.editFieldJumlahAyam,
                  controller.editFieldKebutuhan,
                  controller.editFieldHarga,
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
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
              ? const Center(
                  child: ProgressLoading(),
                )
              : Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            controller.spinnerCustomer,
                            controller.spinnerOrderType,
                            Obx(() => controller.produkType.value == "Non-LB" ? controller.skuCard : cardSKULB()),
                            Obx(
                              () => controller.produkType.value == "Non-LB" ? const SizedBox() : controller.skuCardRemark,
                            ),
                            Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(top: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppColors.outlineColor, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Obx(
                                  () => controller.produkType.value == "Non-LB"
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Total Penjualan",
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
                                                    "Total Kg",
                                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                Text(
                                                  controller.skuCard.controller.sumNeededMax.value - controller.skuCard.controller.sumNeededMin.value == 0 ? "${controller.skuCard.controller.sumNeededMin.value.toStringAsFixed(2)} Kg" : "${controller.skuCard.controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.skuCard.controller.sumNeededMax.value.toStringAsFixed(2)} Kg",
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
                                                    "Total Ekor",
                                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                Obx(() => Text(
                                                      "${controller.skuCard.controller.sumChick.value} Ekor",
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
                                                    "Total Rp",
                                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                Text(
                                                    controller.skuCard.controller.sumPriceMax.value - controller.skuCard.controller.sumPriceMin.value == 0
                                                        ? NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.skuCard.controller.sumPriceMin.value)
                                                        : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.skuCard.controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.skuCard.controller.sumPriceMax.value)}",
                                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                                    overflow: TextOverflow.clip),
                                              ],
                                            )
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Total Penjualan",
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
                                                    "Total Kg",
                                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                Text(
                                                  controller.sumNeededMax.value - controller.sumNeededMin.value == 0 ? "${controller.sumNeededMin.value.toStringAsFixed(2)} Kg" : "${controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.sumNeededMax.value.toStringAsFixed(2)} Kg",
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
                                                    "Total Ekor",
                                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                Obx(() => Text(
                                                      "${controller.sumChick.value} Ekor",
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
                                                    "Total Rp",
                                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                Text(controller.sumPriceMax.value - controller.sumPriceMin.value == 0 ? NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPriceMin.value) : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPriceMax.value)}",
                                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
                                              ],
                                            )
                                          ],
                                        ),
                                )),
                            controller.efRemartk,
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

  _showBottomDialog(BuildContext context, NewDataSalesOrderController controller) {
        return showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
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
                        "Apakah kamu yakin data yang dimasukan sudah benar?",
                        style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                    ),
                    ),
                    Container(
                    margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                    child: const Text("Pastikan semua data yang kamu masukan semua sudah benar", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                    ),
                    Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: SvgPicture.asset(
                        "images/visit_customer.svg",
                    ),
                    ),
                    Container(
                    margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Expanded(child: controller.iyaOrderButton),
                        const SizedBox(
                            width: 16,
                        ),
                        Expanded(child: controller.tidakOrderButton),
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
