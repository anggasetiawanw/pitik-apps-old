import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/ui/purchase_module/detail_purchase_activity/detail_purchase_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/lead_status.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/purchase_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 12/04/23

class DetailPurchase extends GetView<DetailPurchaseController> {
  const DetailPurchase({super.key});

  @override
  Widget build(BuildContext context) {
    DetailPurchaseController controller = Get.put(DetailPurchaseController(context: context));

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
          "Detail Pembelian",
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
                  "Detail Pembelian",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                ),
                PurchaseStatus(purchaseStatus: controller.purchaseDetail.value!.status),
              ],
            ),
            Text(
              "${controller.purchaseDetail.value!.code} - ${createdDate.day} ${DateFormat.MMM().format(createdDate)} ${createdDate.year}",
              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
              overflow: TextOverflow.clip,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Jenis Sumber", style: AppTextStyle.subTextStyle.copyWith(fontSize: 10), overflow: TextOverflow.clip),
                Text(
                  controller.purchaseDetail.value!.vendor != null
                      ? "Vendor"
                      : controller.purchaseDetail.value!.jagal != null
                          ? "Jagal Eksternal"
                          : "",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                  overflow: TextOverflow.clip,
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
                  "Sumber",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  "${controller.purchaseDetail.value!.vendor != null ? controller.purchaseDetail.value!.vendor!.name : controller.purchaseDetail.value!.jagal != null ? controller.purchaseDetail.value!.jagal!.operationUnitName! : ""}",
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
                  "Tujuan",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.purchaseDetail.value!.operationUnit!.operationUnitName ?? "-",
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

    Widget listDetail(String label, String value, bool isLeadStatus) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            isLeadStatus
                ? LeadStatus(leadStatus:controller.purchaseDetail.value?.status)
                : Expanded(
                    flex: 2,
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                      overflow: TextOverflow.clip,
                    ),
                  ),
          ],
        ),
      );
    }

    Widget customExpandalbe(Products products) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller: GetXCreator.putAccordionController(products.id!),
            headerText: products.name!,
            child: Column(
              children: [
                listDetail("Kategori SKU", products.category != null ? products.category!.name! : "-", false),
                listDetail("SKU", products.name != null ? "${products.name}" : "-", false),
                if (products.quantity != 0) listDetail("Jumlah Ekor", "${products.quantity ?? "-"} Ekor", false),
                if (products.weight != 0) listDetail("Kebutuhan", "${products.weight ?? "-"}Kg", false),
                if (products.price != null) listDetail("Harga ", "${products.price == 0 ? "-" : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(products.price!)} "} /Kg", false),
              ],
            )),
      );
    }

    Widget listExpandadle(List<Products?> products) {
      return Column(children: products.map((Products? products) => customExpandalbe(products!)).toList());
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
                    controller.purchaseDetail.value!.status == "CONFIRMED"
                        ? Expanded(
                            child: controller.editButton,
                          )
                        : controller.purchaseDetail.value!.status == "DRAFT"
                            ? Expanded(
                                child: controller.editButton,
                              )
                            : const SizedBox(),
                    if (controller.purchaseDetail.value!.status == "DRAFT") ...[
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: ButtonOutline(
                        controller: GetXCreator.putButtonOutlineController("batalPembelian"),
                        label: "Batal",
                        onClick: () {
                          _showBottomDialogCancel(context, controller);
                        },
                      ))
                    ] else if (controller.purchaseDetail.value!.status == "CONFIRMED") ...[
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ButtonOutline(
                          controller: GetXCreator.putButtonOutlineController("batalPembelian"),
                          label: "Batal",
                          onClick: () {
                            _showBottomDialogCancel(context, controller);
                          },
                        ),
                      )
                    ] else if (controller.purchaseDetail.value!.status == "RECEIVED") ...[
                      Expanded(
                          child: ButtonFill(
                        controller: GetXCreator.putButtonFillController("batalPembelian"),
                        label: "Batal",
                        onClick: () {
                          _showBottomDialogCancel(context, controller);
                        },
                      ))
                    ] else ...[
                      const SizedBox()
                    ]
                  ],
                ),
              ),
            ],
          ));
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
                            "Detail SKU",
                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                            overflow: TextOverflow.clip,
                          ),
                          controller.purchaseDetail.value!.products == null ? const Text(" ") : listExpandadle(controller.purchaseDetail.value!.products as List<Products?>),
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
                                        "Total Pembelian",
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
                                if (controller.sumChick.value != 0) ...[
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
                                ],
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
                                        controller.sumPriceMax.value - controller.sumPriceMin.value == 0
                                            ? controller.sumPriceMin.value == 0
                                                ? "Rp - "
                                                : NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPriceMin.value)
                                            : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPriceMax.value)}",
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                        overflow: TextOverflow.clip),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.outlineColor, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total/Global(kg)",
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "${(controller.purchaseDetail.value!.totalWeight ?? 0)} Kg",
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.outlineColor, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Catatan",
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  controller.purchaseDetail.value!.remarks != null ? Uri.decodeFull(controller.purchaseDetail.value!.remarks!) : "-",
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 120,
                          )
                        ],
                      ),
                    ),
                  )),
            Obx(() => controller.isLoading.isTrue
                ? const SizedBox()
                : controller.purchaseDetail.value!.status == "CANCELLED"
                    ? const SizedBox()
                    : bottomNavBar()),
          ],
        ));
  }

  _showBottomDialogCancel(BuildContext context, DetailPurchaseController controller) {
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
                    "Apakah kamu yakin ingin melakukan pembatalan?",
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text("Pastikan data aman sebelum melakukan pembatalan", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/cancel_icon.svg",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.bfYesCancel),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.boNoCancel),
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
