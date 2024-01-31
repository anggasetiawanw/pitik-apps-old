import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';
import 'package:pitik_internal_app/widget/common/info_detail_header.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/order_status.dart';

import 'delivery_confirm_so_controller.dart';

class DeliveryConfirmSO extends StatelessWidget {
  const DeliveryConfirmSO({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryConfirmSOController controller = Get.put(DeliveryConfirmSOController(
      context: context,
    ));

    Widget detailInformation() {
      return Container(
        margin: const EdgeInsets.only(top: 16, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informasi Pengiriman",
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${controller.order.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                      )
                    ],
                  ),
                ),
                OrderStatus(
                  orderStatus: controller.order.status,
                  returnStatus: controller.order.returnStatus,
                  grStatus: controller.order.grStatus,
                  soPage: true,
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            InfoDetailHeader(title: "Sumber", name: controller.order.operationUnit!.operationUnitName!),
            const SizedBox(
              height: 8,
            ),
            InfoDetailHeader(title: "Tujuan", name: controller.order.customer!.businessName!),
            const SizedBox(
              height: 8,
            ),
            InfoDetailHeader(title: "Dibuat Oleh", name: controller.order.userCreator?.email ?? "-"),
            const SizedBox(
              height: 8,
            ),
            InfoDetailHeader(title: "Sales Branch", name: controller.order.salesperson == null ? "-" : "${controller.order.salesperson?.branch?.name}"),
            const SizedBox(
              height: 8,
            ),
            InfoDetailHeader(title: "Driver", name: "${controller.order.driver == null ? "-" : controller.order.driver!.fullName}"),
            const SizedBox(
              height: 8,
            ),
            InfoDetailHeader(title: "Target Pengiriman", name: controller.order.deliveryTime != null ? DateFormat("dd MMM yyyy").format(Convert.getDatetime(controller.order.deliveryTime!)) : "-"),
            const SizedBox(
              height: 8,
            ),
            InfoDetailHeader(
              title: "Waktu Pengiriman",
              name: controller.order.deliveryTime != null
                  ? DateFormat("HH:mm").format(Convert.getDatetime(controller.order.deliveryTime!)) != "00:00"
                      ? DateFormat("HH:mm").format(Convert.getDatetime(controller.order.deliveryTime!))
                      : "-"
                  : "-",
            ),
          ],
        ),
      );
    }

    Widget infoDetailSku(String title, String name) {
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

    Widget customExpandalbe(Products products) {
      if ((products.returnWeight == null || products.returnWeight == 0) && (products.returnQuantity == null || products.returnQuantity == 0) && products.productCategoryId == null) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
              controller: GetXCreator.putAccordionController("sku${products.name}deliveadsasdasdaw;uj;"),
              headerText: "${products.name}",
              child: Column(
                children: [
                  if (products.category?.name != null) infoDetailSku("Kategori SKU", "${products.category?.name}"),
                  if (products.name != null) infoDetailSku(products.productCategoryId != null ? "Kategori SKU" : "SKU", "${products.name}"),
                  if (products.quantity != null && products.quantity != 0) infoDetailSku("Jumlah Ekor", "${products.quantity} Ekor"),
                  if (products.cutType != null && Constant.havePotongan(products.category?.name)) infoDetailSku("Jenis Potong", Constant.getTypePotongan(products.cutType!)),
                  if (products.numberOfCuts != null && products.cutType == "REGULAR" && Constant.havePotongan(products.category?.name)) infoDetailSku("Potongan", "${products.numberOfCuts} Potong"),
                  if (products.weight != null && products.weight != 0) infoDetailSku("Kebutuhan", "${products.weight} Kg"),
                  if (products.price != null) infoDetailSku("Harga", "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
              )),
        );
      } else if (products.productCategoryId != null) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
              controller: GetXCreator.putAccordionController("sku${products.name}delivew;uj;asdasdaasdasdasdasdasas"),
              headerText: "${products.name}",
              child: Column(
                children: [
                  if (products.category?.name != null) infoDetailSku("Kategori SKU", "${products.category?.name}"),
                  if (products.name != null) infoDetailSku(products.productCategoryId != null ? "Kategori SKU" : "SKU", "${products.name}"),
                  if (products.quantity != null && products.quantity != 0) infoDetailSku("Jumlah Ekor", "${products.quantity} Ekor"),
                  if (products.cutType != null && Constant.havePotongan(products.name)) infoDetailSku("Jenis Potong", Constant.getTypePotongan(products.cutType!)),
                  if (products.numberOfCuts != null && products.cutType == "REGULAR" && Constant.havePotongan(products.name)) infoDetailSku("Potongan", "${products.numberOfCuts} Potong"),
                  if (products.weight != null && products.weight != 0) infoDetailSku("Kebutuhan", "${products.weight} Kg"),
                  if (products.price != null) infoDetailSku("Harga", "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
              )),
        );
      } else {
        if (controller.order.returnStatus == "FULL") {
          return Container(
            margin: const EdgeInsets.only(top: 16),
            child: Expandable(
                controller: GetXCreator.putAccordionController("sku${products.name}delivewaabccxzzc"),
                headerText: "${products.name}",
                child: Column(
                  children: [
                    if (products.category?.name != null) infoDetailSku("Kategori SKU", "${products.category?.name}"),
                    if (products.name != null) infoDetailSku(products.productCategoryId != null ? "Kategori SKU" : "SKU", "${products.name}"),
                    if (products.returnQuantity != null) infoDetailSku("Jumlah Ekor", "${(products.returnQuantity!)} Ekor"),
                    if (products.cutType != null && Constant.havePotongan(products.category?.name)) infoDetailSku("Jenis Potong", Constant.getTypePotongan(products.cutType!)),
                    if (products.numberOfCuts != null && products.cutType == "REGULAR" && Constant.havePotongan(products.category?.name)) infoDetailSku("Potongan", "${products.numberOfCuts} Potong"),
                    if (products.returnWeight != null) infoDetailSku("Kebutuhan", "${products.returnWeight!} Kg"),
                    if (products.price != null) infoDetailSku("Harga", "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                  ],
                )),
          );
        } else {
          if (products.weight! - products.returnWeight! != 0 || products.quantity! - products.returnQuantity! != 0) {
            return Container(
              margin: const EdgeInsets.only(top: 16),
              child: Expandable(
                  controller: GetXCreator.putAccordionController("sku${products.name}delivewaabc123123"),
                  headerText: "${products.name}",
                  child: Column(
                    children: [
                      if (products.category?.name != null) infoDetailSku("Kategori SKU", "${products.category?.name}"),
                      if (products.name != null) infoDetailSku(products.productCategoryId != null ? "Kategori SKU" : "SKU", "${products.name}"),
                      if (products.returnQuantity != null) infoDetailSku("Jumlah Ekor", "${(products.quantity! - products.returnQuantity!)} Ekor"),
                      if (products.cutType != null && Constant.havePotongan(products.category?.name)) infoDetailSku("Jenis Potong", Constant.getTypePotongan(products.cutType!)),
                      if (products.numberOfCuts != null && products.cutType == "REGULAR" && Constant.havePotongan(products.category?.name)) infoDetailSku("Potongan", "${products.numberOfCuts} Potong"),
                      if (products.returnWeight != null) infoDetailSku("Kebutuhan", "${products.weight! - products.returnWeight!} Kg"),
                      if (products.price != null) infoDetailSku("Harga", "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                    ],
                  )),
            );
          } else {
            return const SizedBox();
          }
        }
      }
    }

    Widget bottomNvabar() {
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
              child: controller.confirButton));
    }

    Widget totalPembelian() {
      return Container(
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
                  "${controller.sumKg.value.toStringAsFixed(2)}kg",
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
            if (controller.order.deliveryFee! > 0) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Biaya Pengiriman",
                      style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.order.deliveryFee), style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
                ],
              )
            ],
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
                Text(NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(Convert.roundPrice(controller.sumPrice.value + (controller.order.deliveryFee ?? 0))), style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
            title: "Detail Pengiriman",
            onBack: () {
              Get.back();
            }),
      ),
      body: Obx(() => controller.isLoading.isTrue
          ? const Center(
              child: ProgressLoading(),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailInformation(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Detail SKU",
                          style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.bold),
                        ),
                        Column(
                          children: controller.order.products!.map((e) => customExpandalbe(e!)).toList(),
                        ),
                        if (controller.order.type! == "LB") ...[
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Detail Catatan",
                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                            overflow: TextOverflow.clip,
                          ),
                          Column(
                            children: controller.order.productNotes!.map((e) => customExpandalbe(e!)).toList(),
                          ),
                        ],
                        totalPembelian(),
                        controller.paymentMethod,
                        controller.nominalMoney,
                        controller.checkinButton,
                        Obx(
                          () => controller.showErrorCheckin.isTrue
                              ? Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: controller.isSuccessCheckin.isTrue ? const Color(0xFFECFDF3) : const Color(0xFFFEF3F2), borderRadius: BorderRadius.circular(6)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(controller.isSuccessCheckin.isTrue ? "images/success_checkin.svg" : "images/failed_checkin.svg", height: 14),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.isSuccessCheckin.isTrue ? "Selamat kamu berhasil melakukan Check in" : "Checkin Gagal ${controller.error.value}, coba Kembali",
                                          style: TextStyle(color: controller.isSuccessCheckin.isTrue ? const Color(0xFF12B76A) : const Color(0xFFF04438), fontSize: 10),
                                          overflow: TextOverflow.clip,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(
                          height: 140,
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNvabar(),
                Obx(() => controller.isLoadCheckin.isTrue
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey.withOpacity(0.5),
                        child: const Center(
                          child: ProgressLoading(),
                        ),
                      )
                    : const SizedBox())
              ],
            )),
    );
  }
}
