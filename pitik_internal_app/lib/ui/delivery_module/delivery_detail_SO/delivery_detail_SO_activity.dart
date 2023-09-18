import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/order_status.dart';

import 'delivery_detail_SO_controller.dart';

class DeliveryDetailSO extends StatelessWidget {
  const DeliveryDetailSO({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryDetailSOController controller =
        Get.put(DeliveryDetailSOController(context: context));
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          "Detail Pengiriman",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget infoDetailHeader(String title, String name) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
          ),
          Text(
            name,
            style: AppTextStyle.blackTextStyle
                .copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
          )
        ],
      );
    }

    Widget detailInformation() {
      return Container(
        margin: const EdgeInsets.only(top: 16, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Pengiriman",
                      style: AppTextStyle.blackTextStyle
                          .copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
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
                OrderStatus(
                  orderStatus: controller.order.status,
                  returnStatus: controller.order.returnStatus,grStatus: controller.order.grStatus,
                  soPage: true,
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader("Sumber",
                "${controller.order.operationUnit!.operationUnitName}"),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader(
                "Tujuan", "${controller.order.customer!.businessName}"),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader("Driver", "${controller.order.driver!.fullName}"),
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
              style: AppTextStyle.blackTextStyle
                  .copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
            )
          ],
        ),
      );
    }

    Widget customExpandalbe(Products products) {
        Timer(const Duration(milliseconds: 200), () { });
       if((products.returnWeight ==null || products.returnWeight ==0) &&(products.returnQuantity ==null || products.returnQuantity ==0)) { return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller:
                GetXCreator.putAccordionController("sku${products.name}"),
            headerText: "${products.name}",
            child: Container(
              child: Column(
                children: [
                  infoDetailSku("Kategori SKU", "${products.category!.name}"),
                  infoDetailSku("SKU", "${products.name}"),
                  products.quantity != 0
                      ? infoDetailSku(
                          "Jumlah Ekor", "${products.quantity} Ekor")
                      : Container(),
                  products.numberOfCuts != 0
                      ? infoDetailSku(
                          "Potongan", "${products.numberOfCuts} Potong")
                      : Container(),
                  infoDetailSku("Kebutuhan", "${products.weight!} Kg"),
                  infoDetailSku("Harga",
                      "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
              ),
            )),
      ); } else { return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller:
                GetXCreator.putAccordionController("sku${products.name}"),
            headerText: "${products.name}",
            child: Container(
              child: Column(
                children: [
                  infoDetailSku("Kategori SKU", "${products.category!.name}"),
                  infoDetailSku("SKU", "${products.name}"),
                  products.quantity != 0
                      ? infoDetailSku(
                          "Jumlah Ekor", "${(products.quantity! - products.returnQuantity!)} Ekor")
                      : Container(),
                  products.numberOfCuts != 0
                      ? infoDetailSku(
                          "Potongan", "${products.numberOfCuts} Potong")
                      : Container(),
                  infoDetailSku("Kebutuhan", "${products.weight! - products.returnWeight!} Kg"),
                  infoDetailSku("Harga",
                      "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
              ),
            )),
      );
    }}

    Widget bottomNvabar() {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(20, 158, 157, 157),
                        blurRadius: 5,
                        offset: Offset(0.75, 0.0))
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controller.order.status == "READY_TO_DELIVER"
                        ? Expanded(
                            child: ButtonFill(
                                controller: GetXCreator.putButtonFillController(
                                    "ReadyToDelivery"),
                                label: "Kirim Barang",
                                onClick: () {
                                  _showBottomDialogSend(context, controller);
                                }),
                          )
                        : controller.order.status == "ON_DELIVERY"
                            ? Expanded(
                                child: controller.confirmButton,
                              )
                            : Container(),
                        if(controller.order.status == "ON_DELIVERY")...[
                                const SizedBox(width: 16,),
                                Expanded(
                                    child: ButtonOutline(
                                    controller: GetXCreator.putButtonOutlineController(
                                        "tolakPenjualan"),
                                    label: "Ditolak",
                                    onClick: () {
                                        _showBottomDialogCancel(context, controller);
                                    },
                                    ),
                                )
                            ] 
                        else if(controller.order.status == "REJECTED" && controller.order.returnStatus =="PARTIAL") ...[
                            Expanded(
                              child: controller.confirmButton,
                            )
                        ]
                            else Container(),
                  ],
                ),
              ),
            ],
          ));
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
                    Text("${controller.sumKg.value.toStringAsFixed(2)}kg",
                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                        overflow: TextOverflow.clip,),
                    ],
                ),
                const SizedBox(
                    height: 8,
                ),
                if(controller.sumChick !=0)...[
                        Row(
                        children: [
                        Expanded(
                            child: Text(
                            "Total Ekor",
                            style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                            overflow: TextOverflow.clip,
                            ),
                        ),
                        Obx(() => Text("${controller.sumChick.value} Ekor",
                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                            overflow: TextOverflow.clip,)),
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
                    Text(NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.sumPrice.value),
                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                        overflow: TextOverflow.clip),
                    ],
                )
            ],
            ),
        );
    }
       
    Widget payment() {
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
                        "Pembayaran",
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
                        "Metode Pemabyaran",
                        style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                        overflow: TextOverflow.clip,
                    ),
                    ),
                    Text(controller.order.paymentMethod == "CASH" ? "Tunai" : "Transfer",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                    overflow: TextOverflow.clip,),
                ],
                ),
                const SizedBox(
                height: 8,
                ),
                Row(
                children: [
                    Expanded(
                    child: Text(
                        "Nominal Uang",
                        style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                        overflow: TextOverflow.clip,
                    ),
                    ),
                    Text(controller.order.paymentAmount != null ? Convert.toCurrency("${controller.order.paymentAmount}", "Rp. ", "."): "${controller.order.paymentAmount}",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                    overflow: TextOverflow.clip,)
                ],
                ),
            ],
            ),
        );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: appBar(),
      ),
      body: Obx(() => controller.isLoading.isTrue ? const Center(child: ProgressLoading(),) : Stack(
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
                        style: AppTextStyle.blackTextStyle
                            .copyWith(fontWeight: AppTextStyle.bold),
                      ),
                      Column(
                        children: controller.order.products!
                            .map((e) => customExpandalbe(e!))
                            .toList(),
                      ),
                      totalPembelian(),
                      (controller.order.status == "DELIVERED" || controller.order.status == "RECEIVED" ) && controller.order.paymentMethod != null? payment() : Container(),
                      const SizedBox(height: 140,)
                    ],
                  ),
                ),
              ),
               controller.order.status == "READY_TO_DELIVER"  || controller.order.status == "ON_DELIVERY" || (controller.order.status == "REJECTED" && controller.order.returnStatus =="PARTIAL")? bottomNvabar() :Container()
            ],
          )),
    );
  }

  _showBottomDialogCancel(
      BuildContext context, DeliveryDetailSOController controller) {
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
                    "Apakah yakin kamu ingin melakukan penolakan?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text("Pastikan barang sudah sesuai dan benar sebelum melakukan penolakan",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
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
                      Expanded(child: controller.yesRejectItem),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noRejectItem),
                    ],
                  ),
                ),
                const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        });
  }

  _showBottomDialogSend(
      BuildContext context, DeliveryDetailSOController controller) {
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
                    "Apakah kamu yakin akan mengirim barang ini?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Pastikan barang yang akan kamu kirim sudah sesuai dan benar",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/image_logistic.svg",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.yesSendItem),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noSendItem),
                    ],
                  ),
                ),
                const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        });
  }
}
