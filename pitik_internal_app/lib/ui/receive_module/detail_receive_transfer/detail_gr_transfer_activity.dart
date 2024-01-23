import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_transfer/detail_gr_transfer_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/transfer_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 07/06/23

class DetailGRTransfer extends StatelessWidget {
  const DetailGRTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailGRTransferController controller = Get.put(DetailGRTransferController(context: context));
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
    Widget bottomNavbar() {
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
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                        ),
                        padding: const EdgeInsets.only(left: 16, bottom: 16,right: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            controller.transferModel.status == "RECEIVED"
                                ? Expanded(
                                    child: ButtonFill(
                                        controller: GetXCreator.putButtonFillController(
                                            "cancelTransferReceive"),
                                        label: "Batal",
                                        onClick: () {
                                          _showBottomDialogCancel(context, controller);
                                            }))
                                : controller.transferModel.status == "DELIVERED"
                                    ? Expanded(
                                        child: ButtonFill(
                                            controller: GetXCreator.putButtonFillController(
                                                "createTransferReceive"),
                                            label: "Buat Penerimaan",
                                            onClick: () {
                                              Get.toNamed(RoutePage.createGrTransferPage, arguments: controller.transferModel)!.then((value) {
                                                controller.isLoading.value =true;
                                                Timer(const Duration(milliseconds: 500), () {
                                                  controller.getDetailTransfer();
                                                });
                                              });
                                            }))
                                : const SizedBox(),
                            ],
                        ),
                    ),
                  ],
                ),
            );
    }

    Widget infoDetailHeader(String title, String name){
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(title, style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),),
                Text(name, style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),)
            ],
        );
    }

    Widget detailInformation() {
      return Container(
        margin: const EdgeInsets.only(top: 16, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8)),
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
                      "Informasi Transfer",
                      style: AppTextStyle.blackTextStyle
                          .copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${controller.transferModel.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}",
                      style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                    )
                  ],
                ),
                TransferStatus(transferStatus: controller.transferModel.status, isGoodReceipts: true,),
              ],
            ),
            const SizedBox(height: 16,),
            infoDetailHeader("Sumber", "${controller.transferModel.sourceOperationUnit!.operationUnitName}"),
            const SizedBox(height: 8,),
            infoDetailHeader("Tujuan", "${controller.transferModel.targetOperationUnit!.operationUnitName}"),
            // const SizedBox(height: 8,),
            // controller.transferModel.driver != null ? infoDetailHeader("Driver", "${controller.transferModel.driver!.fullName}")
            //     : const SizedBox(),

          ],
        ),
      );
    }

    Widget infoDetailSKU(String title, String name){
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(title, style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),),
                Text(name, style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),)
            ],
        );
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: appBar(),
        ),
        body:  Obx(() => controller.isLoading.isTrue ? const Center(child: ProgressLoading()): Stack(
            children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailInformation(),
                        if(controller.transferModel.products!.isNotEmpty && controller.transferModel.status == "DELIVERED") ...[
                            if(controller.transferModel.products!.isNotEmpty) ...[
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                child: Text("Detail SKU", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),),
                            ),
                            Container(
                                width: double.infinity,
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: const BoxDecoration(
                                    color: AppColors.headerSku,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                ),
                                child: Text("${controller.transferModel.products![0]!.name}", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),),
                            ),
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
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
                                        infoDetailSKU("SKU", "${controller.transferModel.products![0]!.productItems != null ? controller.transferModel.products![0]!.productItems![0]!.name : "null"}"),
                                        if(controller.transferModel.products![0]!.productItems![0]!.quantity != null && controller.transferModel.products![0]!.productItems![0]!.quantity != 0) ...[
                                            const SizedBox(height: 14,),
                                            infoDetailSKU("Jumlah Ekor", "${controller.transferModel.products![0]!.productItems![0]!.quantity} Ekor"),
                                        ],
                                        const SizedBox(height: 14,),
                                        controller.transferModel.products![0]!.productItems![0]!.weight != null ?infoDetailSKU("Total", "${controller.transferModel.products![0]!.productItems![0]!.weight!} Kg"):const SizedBox(),
                                    ],
                                ),
                            ),
                        ]
                        ]
                        else if(controller.transferModel.status == "RECEIVED" && (controller.goodReceiptDetail.value != null || controller.transferModel.goodsReceived !=null))...[
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                child: Text(controller.transferModel.status == "DELIVERED"  ? "Detail SKU Transfer" :"Detail SKU Penerimaan" , style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),),
                            ),
                            Container(
                                width: double.infinity,
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                decoration: const BoxDecoration(
                                    color: AppColors.headerSku,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                ),
                                child: Text("SKU", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),),
                            ),
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color:AppColors.outlineColor, width: 1),
                                  left: BorderSide(color: AppColors.outlineColor, width: 1),
                                  right: BorderSide(color: AppColors.outlineColor, width: 1),
                                  top: BorderSide(color: AppColors.outlineColor, width: 0.1),
                                ),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                              ),
                                child: Column(
                                    children: [
                                        infoDetailSKU("Kategori SKU", "${controller.goodReceiptDetail.value!.products != null ? controller.goodReceiptDetail.value!.products![0]!.productItem!.category!.name : "null" }"),
                                        if((controller.goodReceiptDetail.value!.products != null && controller.goodReceiptDetail.value!.products![0]!.quantity !=0)) ...[
                                            const SizedBox(height: 14,),
                                            infoDetailSKU("Jumlah Ekor", "${controller.goodReceiptDetail.value!.products != null ? controller.goodReceiptDetail.value!.products![0]!.quantity : controller.transferModel.products![0]!.quantity } Ekor"),
                                        ],
                                        const SizedBox(height: 14,),
                                        infoDetailSKU("Total", "${controller.goodReceiptDetail.value!.products != null ? controller.goodReceiptDetail.value!.products![0]!.weight : controller.transferModel.products![0]!.weight} Kg"),
                                    ],
                                ),
                            ),
                        ]

                      ],
                  ),
                ),
                bottomNavbar()
            ],
        ),
    ));
  }
  _showBottomDialogCancel(BuildContext context, DetailGRTransferController controller) {
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
                    "images/cancel_icon.svg",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.yesCancelButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: controller.noCancelButton
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