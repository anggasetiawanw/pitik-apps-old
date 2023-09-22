import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';
import 'package:pitik_internal_app/widget/common/info_detail_header.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/transfer_status.dart';

import 'delivery_confirm_transfer_controller.dart';

class DeliveryConfirmTransfer extends StatelessWidget {
  const DeliveryConfirmTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryConfirmTransferController controller = Get.put(DeliveryConfirmTransferController(context: context));
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              
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
    Widget bottomNavbar() {
        return Align(
            alignment: Alignment.bottomCenter,
                child: Container(
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
                    child: controller.transferModel.status == "ON_DELIVERY"
                        ? controller.confirmButton
                    : const SizedBox(),
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
            InfoDetailHeader(title: "Sumber", name:controller.transferModel.sourceOperationUnit!.operationUnitName!),
            const SizedBox(height: 8,),
            InfoDetailHeader(title: "Tujuan", name: controller.transferModel.targetOperationUnit!.operationUnitName!),
            const SizedBox(height: 8,),
            controller.transferModel.driver != null ?  InfoDetailHeader(title: "Driver", name: controller.transferModel.driver!.fullName!): const SizedBox(),
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
            child: CustomAppbar(title: "Detail Pengiriman", onBack: (){
                Navigator.pop(context);
            }),
        ),
        body:  Obx(() => controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : Stack(
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
                                child: Text("${controller.transferModel.products![0]!.productItems![0]!.name}", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),),   
                            ),
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.outlineColor, width: 1),
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
                                ),
                                child: Column(
                                    children: [
                                        infoDetailSKU("Kategori SKU", "${controller.transferModel.products != null ? controller.transferModel.products![0]!.name : "null"}"),
                                        if(controller.transferModel.products![0]!.productItems![0]!.quantity != 0) ...[                                        
                                            const SizedBox(height: 14,),
                                            infoDetailSKU("Jumlah Ekor", "${controller.transferModel.products![0]!.productItems![0]!.quantity} Ekor"),
                                        ],
                                        const SizedBox(height: 14,),
                                        infoDetailSKU("Total", "${controller.transferModel.products![0]!.productItems![0]!.weight} Kg"),
                                    ],
                                ),
                            ),
                        ]
                        else const SizedBox(),
                        controller.checkinButton,
                        Obx(() => controller.showErrorCheckin.isTrue
                                ? Container(
                                    margin: const EdgeInsets.only(top: 16),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: controller.isSuccessCheckin.isTrue
                                            ? const Color(0xFFECFDF3)
                                            : const Color(0xFFFEF3F2),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Row(
                                        children: [
                                        SvgPicture.asset(controller.isSuccessCheckin.isTrue ? "images/success_checkin.svg" : "images/failed_checkin.svg", height: 14),
                                        const SizedBox(
                                            width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                              controller.isSuccessCheckin.isTrue
                                                  ? "Selamat kamu berhasil melakukan Check in"
                                                  : "Checkin Gagal ${controller.error.value}, coba Kembali",
                                              style: TextStyle(
                                                  color: controller
                                                          .isSuccessCheckin.isTrue
                                                      ? const Color(0xFF12B76A)
                                                      : const Color(0xFFF04438),
                                                  fontSize: 10),
                                                  overflow: TextOverflow.clip,
                                          ),
                                        )
                                        ],
                                    ),
                                    )
                                : const SizedBox(),),
                        const SizedBox(height: 140,),
                      ],
                  ),
                ),
                bottomNavbar(),
                Obx(() => controller.isLoadCheckin.isTrue ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                    child: const Center(
                        child: ProgressLoading(),
                    ),
                ) : const SizedBox())
            ],
        ),
    ));
  }
}