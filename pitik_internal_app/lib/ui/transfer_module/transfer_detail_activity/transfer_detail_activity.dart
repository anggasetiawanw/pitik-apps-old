import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_detail_activity/transfer_detail_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/transfer_status.dart';

class TransferDetailActivity extends StatelessWidget {
  const TransferDetailActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final TransferDetailController controller = Get.put(TransferDetailController(context: context));
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
          "Detail Transfer",
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
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            controller.transferModel.status == "DRAFT"
                                ? Expanded(
                                    child: ButtonFill(
                                        controller: GetXCreator.putButtonFillController(
                                            "editTransferss"),
                                        label: "Edit",
                                        onClick: () {
                                                Get.toNamed(RoutePage.transferForm, arguments: [controller.transferModel, true])!.then((value) {
                                                    controller.isLoading.value =true;
                                                    Timer(const Duration(milliseconds: 500), () {
                                                        controller.getDetailTransfer();
                                                    });
                                                });
                                            }))
                                : controller.transferModel.status == "CONFIRMED"
                                    ? Expanded(
                                        child: ButtonFill(
                                            controller: GetXCreator.putButtonFillController(
                                                "pesanStock"),
                                            label: "Pesan Stock",
                                            onClick: () {
                                                _showBottomDialogSend(context, controller);
                                            }))
                                    : controller.transferModel.status == "BOOKED"
                                        ? Expanded(
                                            child: ButtonFill(
                                                controller:
                                                    GetXCreator.putButtonFillController(
                                                        "Kirim Transfer"),
                                                label: "Kirim",
                                                onClick: () {
                                                    Get.toNamed(RoutePage.transferDriver, arguments: [controller.transferModel, false])!.then((value) {
                                                        controller.isLoading.value =true;
                                                        Timer(const Duration(milliseconds: 500), () {
                                                            controller.getDetailTransfer();
                                                        });
                                                    });
                                                }))
                                        : controller.transferModel.status == "READY_TO_DELIVER"
                                            ? Expanded(
                                                child: ButtonFill(
                                                    controller:
                                                        GetXCreator.putButtonFillController(
                                                            "editTransfer"),
                                                    label: "Edit",
                                                    onClick: () {
                                                            Get.toNamed(RoutePage.transferDriver, arguments: [controller.transferModel, true])!.then((value) {
                                                                controller.isLoading.value =true;
                                                                Timer(const Duration(milliseconds: 500), () {
                                                                    controller.getDetailTransfer();
                                                                });
                                                            });
                                                    }))
                                                : const SizedBox(),
                            const SizedBox(
                                width: 16,
                            ),
                            controller.transferModel.status == "DRAFT"
                                ? Expanded(
                                    child: ButtonOutline(
                                        controller: GetXCreator.putButtonOutlineController(
                                            "cancelTranfer"),
                                        label: "Batal",
                                        onClick: () {
                                            _showBottomDialogCancel(context, controller);
                                        }))
                                : controller.transferModel.status == "CONFIRMED"
                                    ? Expanded(
                                        child: ButtonOutline(
                                            controller:
                                                GetXCreator.putButtonOutlineController(
                                                    "cancelTranfer"),
                                            label: "Batal",
                                            onClick: () {
                                                _showBottomDialogCancel(context, controller);
                                            }))
                                    : controller.transferModel.status == "READY_TO_DELIVER"
                                        ? Expanded(
                                            child: ButtonOutline(
                                                controller:
                                                    GetXCreator.putButtonOutlineController(
                                                        "cancelTranfer"),
                                                label: "Batal",
                                                onClick: () {
                                                    _showBottomDialogCancel(
                                                        context, controller);
                                                }))
                                        : controller.transferModel.status == "BOOKED"
                                            ? Expanded(
                                                child: ButtonOutline(
                                                    controller: GetXCreator
                                                        .putButtonOutlineController(
                                                            "cancelTranfer"),
                                                    label: "Batal",
                                                    onClick: () {
                                                            _showBottomDialogCancel(
                                                                context, controller);
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
                Expanded(
                  child: Column(
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
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                TransferStatus(transferStatus: controller.transferModel.status, isGoodReceipts: false,),
              ],
            ),
            const SizedBox(height: 16,),
            infoDetailHeader("Sumber", "${controller.transferModel.sourceOperationUnit!.operationUnitName}"),
            const SizedBox(height: 8,),
            infoDetailHeader("Tujuan", "${controller.transferModel.targetOperationUnit!.operationUnitName}"),
            const SizedBox(height: 8,),
            controller.transferModel.driver != null ? infoDetailHeader("Driver", "${controller.transferModel.driver!.fullName}") : const SizedBox(),
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
        body:  Obx(() => controller.isLoading.isTrue ? const Center(child:ProgressLoading(),) : Stack(
            children: [
              
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailInformation(),
                        if(controller.transferModel.products!.isNotEmpty) ...[
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                child: Text("Detail SKU", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),),
                            ),
                            Container(
                                width: double.infinity,
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                                  top: BorderSide(color: AppColors.outlineColor, width: 0),
                                ),
                                // border: Border.all(color: AppColors.grey, width: 1),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                              ),
                                child: Column(
                                    children: [
                                        infoDetailSKU("SKU", "${controller.transferModel.products![0]!.productItems![0] != null ? controller.transferModel.products![0]!.productItems![0]!.name : "null"}"),
                                        if(controller.transferModel.products![0]!.productItems![0]!.quantity != null && controller.transferModel.products![0]!.productItems![0]!.quantity != 0) ...[                                        
                                            const SizedBox(height: 14,),
                                            infoDetailSKU("Jumlah Ekor", "${controller.transferModel.products![0]!.productItems![0]!.quantity} Ekor"),
                                        ],
                                        const SizedBox(height: 14,),
                                        controller.transferModel.products![0]!.productItems != null ?infoDetailSKU("Total", "${controller.transferModel.products![0]!.productItems![0]!.weight!} Kg"):const SizedBox(),
                                    ],
                                ),
                            ),
                        ]
                        else const SizedBox()

                      ],
                  ),
                ),
                controller.transferModel.status == "CANCELLED" || controller.transferModel.status == "RECEIVED" || controller.transferModel.status == "DELIVERED"  ? const SizedBox() : bottomNavbar() 
            ],
        ),
    ));
  }
  _showBottomDialogCancel(BuildContext context, TransferDetailController controller) {
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
                ),
                const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        });
    }
    _showBottomDialogSend(BuildContext context, TransferDetailController controller) {
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
                    "Apakah kamu yakin untuk melakukan pemesanan stok?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Pastikan semua data yang akan dipesan stok sudah sesuai",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/stock_icon.svg",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.yesSendButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: controller.noSendButton
                      ),
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