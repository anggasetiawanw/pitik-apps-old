import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_fill/button_fill_controller.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/transfer_status.dart';

import 'delivery_detail_transfer_controller.dart';

class DeliveryDetailTransfer extends StatelessWidget {
  const DeliveryDetailTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryDetailTransferController controller = Get.put(DeliveryDetailTransferController(context: context));
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
          "Detail Pengiriman",
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
                boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: controller.transferModel.status == "ON_DELIVERY"
                  ? controller.doneSendButton
                  : controller.transferModel.status == "READY_TO_DELIVER"
                      ? ButtonFill(
                          controller: GetXCreator.putButtonFillController("READY_TO_DELIVERBarang"),
                          label: "Kirim Barang",
                          onClick: () {
                            if (controller.transferModel.status =="READY_TO_DELIVER" && controller.isSendItem.isFalse) {
                                    controller.isSendItem.value = true;
                                    ButtonFillController btController = Get.find(tag: "READY_TO_DELIVERBarang");
                                    btController.changeLabel("Konfirmasi");
                                  } else if (controller.isSendItem.isTrue) {
                                    _showBottomDialogSend(context, controller);
                                  }
                          })
                      : const SizedBox(),
            ),
          ],
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
            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
          )
        ],
      );
    }

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
                        "Informasi Transfer",
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
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
                TransferStatus(
                  transferStatus: controller.transferModel.status,
                  isGoodReceipts: false,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader("Sumber", "${controller.transferModel.sourceOperationUnit!.operationUnitName}"),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader("Tujuan", "${controller.transferModel.targetOperationUnit!.operationUnitName}"),
            const SizedBox(
              height: 8,
            ),
            controller.transferModel.driver != null ? infoDetailHeader("Driver", "${controller.transferModel.driver!.fullName}") : const SizedBox(),
          ],
        ),
      );
    }

    Widget infoDetailSKU(String title, String name) {
      return Row(
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
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar(),
        ),
        body: Obx(
          () => controller.isLoading.isTrue
              ? const Center(child: ProgressLoading())
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          detailInformation(),
                          if (controller.transferModel.products!.isNotEmpty) ...[
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "Detail SKU",
                                style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: const BoxDecoration(color: AppColors.headerSku, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                              child: Text(
                                "${controller.transferModel.products![0]!.productItems![0]!.name}",
                                style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.outlineColor, width: 1), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                              child: Column(
                                children: [
                                  infoDetailSKU("Kategori SKU", "${controller.transferModel.products != null ? controller.transferModel.products![0]!.name : "null"}"),
                                  if (controller.transferModel.products![0]!.productItems![0]!.quantity != 0) ...[
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    infoDetailSKU("Jumlah Ekor", "${controller.transferModel.products![0]!.productItems![0]!.quantity} Ekor"),
                                  ],
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  infoDetailSKU("Total", "${controller.transferModel.products![0]!.productItems![0]!.weight} Kg"),
                                ],
                              ),
                            ),
                          ] else
                            const SizedBox(),
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
                                  controller.transferModel.remarks != null ? Uri.decodeFull(controller.transferModel.remarks!) : "-",
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          if (controller.isSendItem.isTrue) controller.efRemark,
                          if (controller.transferModel.status != "READY_TO_DELIVER") ...[
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
                                    "Catatan Pengiriman",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    controller.transferModel.driverRemarks != null ? Uri.decodeFull(controller.transferModel.driverRemarks!) : "-",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 120,),
                        ]),
                      ),
                    ),
                    controller.transferModel.status == "ON_DELIVERY" || controller.transferModel.status == "READY_TO_DELIVER" ? bottomNavbar() : const SizedBox()
                  ],
                ),
        ));
  }

  _showBottomDialogSend(BuildContext context, DeliveryDetailTransferController controller) {
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
                    "Apakah kamu yakin akan mengirim barang ini?",
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text("Pastikan barang yang akan kamu kirim sudah sesuai dan benar", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
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
                      Expanded(child: controller.yesSendButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noSendButton),
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
