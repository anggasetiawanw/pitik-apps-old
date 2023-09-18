import 'package:components/button_fill/button_fill.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_purchase/detail_gr_purchase_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/lead_status.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/purchase_status.dart';
///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 29/05/23

class DetailGrPurchase extends GetView<DetailGrPurchaseController>{
  const DetailGrPurchase({
    super.key
  });

@override
  Widget build(BuildContext context) {
    DetailGrPurchaseController controller = Get.put(DetailGrPurchaseController(context: context));

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
          "Detail Penerimaan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
                  "Informasi Pembelian",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                ),
                PurchaseStatus(purchaseStatus: controller.purchaseDetail.value!.status),
              ],
            ),
            Text("${controller.purchaseDetail.value!.code} - ${createdDate.day} ${DateFormat.MMM().format(createdDate)} ${createdDate.year}",
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
                    "Jenis Sumber", style: AppTextStyle.subTextStyle.copyWith(fontSize: 10),
                    overflow: TextOverflow.clip),
                Text(
                  controller.purchaseDetail.value!.vendor != null  ? "Vendor" : controller.purchaseDetail.value!.jagal != null ? "Jagal Eksternal" :"",
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
                  "${controller.purchaseDetail.value!.vendor != null ?
                  controller.purchaseDetail.value!.vendor!.name : controller.purchaseDetail.value!.jagal != null ?
                  controller.purchaseDetail.value!.jagal!.operationUnitName! :"" }",
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
                  // controller.salerPerson != null
                  //     ? "${controller.salerPerson}"
                  //     : "-",
                  "${controller.purchaseDetail.value!.operationUnit!.operationUnitName ?? "-"}",
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
              flex: 2,
              child: Text(
                label,
                style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            isLeadStatus
                ? LeadStatus(
                leadStatus:
                controller.purchaseDetail.value!.status != null
                    ? controller
                    .purchaseDetail.value!.status!
                    : null)
                : Expanded(
              flex: 2,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: AppTextStyle.blackTextStyle
                    .copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      );
    }


    Widget customExpandable(Products products) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller: GetXCreator.putAccordionController(products.id!),
            headerText: products.name!,
            child: Column(
                children: [
                  listDetail("Kategori SKU", products.category != null ? products.category!.name! : "-", false),
                  listDetail("SKU",products.name ?? "-", false),
                  if(products.quantity !=0) listDetail("Jumlah Ekor","${ products.quantity ?? "-"} Ekor", false),
                  listDetail("Kebutuhan","${ products.weight ?? "-"} Kg", false),
                  listDetail("Harga ", "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(products.price!)} /Kg",false),
                ],
            )),

      );
    }


    Widget listExpandadle(List<Products?> products) {
      return Column(
          children: products
              .map((Products? products) => customExpandable(products!))
              .toList());
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
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(20, 158, 157, 157),
                        blurRadius: 5,
                        offset: Offset(0.75, 0.0))
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controller.purchaseDetail.value!.status == "CONFIRMED" ?
                    Expanded(
                      child: controller.bfMakePurchase,
                    ):
                    controller.purchaseDetail.value!.status == "RECEIVED" ?
                    Expanded(
                        child: ButtonFill(
                            controller: GetXCreator.putButtonFillController(
                                "cancelGRPurchase"),
                            label: "Batal",
                            onClick: () {
                              showBottomDialog(context, controller);
                            })):
                    Container(),
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
        body:Obx(() => controller.isLoading.isTrue ?
             const Center(
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
              detailPurchase(),
              const SizedBox(
                height: 20,),
                    Text(
                      "Detail SKU Pembelian",
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                      overflow: TextOverflow.clip,
                    ),
                    if(controller.purchaseDetail.value!.products != null )...[
                        if( controller.purchaseDetail.value!.goodsReceived != null  && controller.purchaseDetail.value!.goodsReceived!.status == "CONFIRMED" )...[
                            listExpandadle(controller.purchaseDetail.value!.goodsReceived!.products as List<Products?>),
                        ] else ...[
                            listExpandadle(controller.purchaseDetail.value!.products as List<Products?>),
                        ]
                    ],
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
                                Text(controller.sumNeededMax.value - controller.sumNeededMin.value ==0 ? "${controller.sumNeededMin.value.toStringAsFixed(2)} Kg" : "${controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.sumNeededMax.value.toStringAsFixed(2)} Kg",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip,),
                                ],
                            ),
                            const SizedBox(
                                height: 8,
                            ),
                            if(controller.sumChick.value !=0)...[
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
                                Text(controller.sumPriceMax.value - controller.sumPriceMin.value ==0 ? NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.sumPriceMin.value) : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.sumPriceMax.value)}",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip),
                                ],
                            )
                        ],
                      ),
              ),
              const SizedBox(
                height: 120,
              )],
                ),
              ),
            ),
           bottomNavBar()
          ],

    )));

  }

  showBottomDialog(BuildContext context, DetailGrPurchaseController controller) {
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
                    "Apakah kamu yakin ingin melakukan pembatalan?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Pastikan data aman sebelum melakukan pembatalan",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/sad_face_flatline.svg",
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
                      Expanded(
                          child: controller.boNoCancel,
                      ),
                    ],
                  ),
                ), const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        });
  }


}
