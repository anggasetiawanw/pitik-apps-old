import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_detail_activity/terminate_detail_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/terminate_status.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/transfer_terminate.dart';

class TerminateDetailActivity extends StatelessWidget {
  const TerminateDetailActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final TerminateDetailController controller = Get.put(TerminateDetailController(context: context));
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
          "Detail Pemusnahan",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.terminateModel.status == EnumTerminateStatus.draft) ...[
                    Expanded(
                        child: ButtonFill(
                            controller: GetXCreator.putButtonFillController("editManufacture"),
                            label: "Edit",
                            onClick: () {
                              Get.toNamed(RoutePage.terminateForm, arguments: [controller.terminateModel, true])!.then((value) {
                                controller.isLoading.value = true;
                                Timer(const Duration(milliseconds: 500), () {
                                  controller.getDetailTerminate();
                                });
                              });
                            })),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: ButtonOutline(
                            controller: GetXCreator.putButtonOutlineController("cancelTerminate"),
                            label: "Batal",
                            onClick: () {
                              _showBottomDialogCancel(context, controller);
                            }))
                  ] else if (controller.terminateModel.status == EnumTerminateStatus.confirmed) ...[
                    Expanded(
                        child: ButtonFill(
                            controller: GetXCreator.putButtonFillController("pesanStock"),
                            label: "Pesan Stock",
                            onClick: () {
                              _showBottomDialogOrderStock(context, controller);
                            })),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: ButtonOutline(
                            controller: GetXCreator.putButtonOutlineController("cancelTerminate"),
                            label: "Batal",
                            onClick: () {
                              _showBottomDialogCancel(context, controller);
                            }))
                  ] else if (controller.terminateModel.status == EnumTerminateStatus.booked) ...[
                    if (Constant.isOpsLead.isTrue || Constant.isScRelation.isTrue) ...[
                      Expanded(child: controller.btSetujui),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.btTolak)
                    ] else ...[
                      Expanded(
                          child: ButtonOutline(
                              controller: GetXCreator.putButtonOutlineController("cancelTerminate"),
                              label: "Batal",
                              onClick: () {
                                _showBottomDialogCancel(context, controller);
                              }))
                    ]
                  ]
                ],
              ),
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
                        "Informasi Pemusnahan",
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${controller.terminateModel.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                TerminateStatus(terminateStatus: controller.terminateModel.status,isApproved: controller.terminateModel.reviewer != null ? true : false),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader("Sumber", "${controller.terminateModel.operationUnit!.operationUnitName}"),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detailInformation(),
                            if (controller.terminateModel.reviewer != null && controller.terminateModel.status == EnumTerminateStatus.finished) ...[
                              Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.outlineColor, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Berita Acara", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700)),
                                          Text(DateFormat("dd MMM yyyy HH:mm", "id").format(DateTime.parse(controller.terminateModel.reviewedDate ?? DateFormat("dd MMM yyyy HH:mm", "id").format(DateTime.now()))), style: AppTextStyle.blackTextStyle.copyWith()),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text("Disetujui dan diperiksa oleh", style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12)),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("${controller.terminateModel.reviewer!.fullName}", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium)),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text("Email", style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12)),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("${controller.terminateModel.reviewer!.email}", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium)),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset("images/checkbox_fill.svg"),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "Saya dengan teliti dan sadar sudah memeriksa hasil Pemusnahan",
                                            style: AppTextStyle.blackTextStyle,
                                            overflow: TextOverflow.clip,
                                          )),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: const BoxDecoration(color: AppColors.headerSku, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                              child: Text(
                                "${controller.terminateModel.product!.productItem!.name}",
                                style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
                              ),
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
                                  infoDetailSKU("Kategori SKU", "${controller.terminateModel.product!.name}"),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  controller.terminateModel.product!.productItem!.quantity != null ? infoDetailSKU("Jumlah Ekor", "${controller.terminateModel.product!.productItem!.quantity} Ekor") : const SizedBox(),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  infoDetailSKU("Total", "${controller.terminateModel.product!.productItem!.weight} Kg"),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Image.network(
                              controller.terminateModel.imageLink!,
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryOrange,
                                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                  ),
                                );
                              },
                            ),
                            if (controller.terminateModel.status == EnumTerminateStatus.rejected) ...[
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
                                      "Catatan Penolakan",
                                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "-",
                                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ),
                    controller.terminateModel.status == EnumTerminateStatus.draft || controller.terminateModel.status == EnumTerminateStatus.confirmed || controller.terminateModel.status == EnumTerminateStatus.booked ? bottomNavbar() : const SizedBox(),
                  ],
                ),
        ));
  }

  _showBottomDialogCancel(BuildContext context, TerminateDetailController controller) {
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
                      Expanded(child: controller.yesCancelButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noCancelButton),
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

  _showBottomDialogTerminate(BuildContext context, TerminateDetailController controller) {
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
                    "Apakah kamu yakin ingin melakukan pemusnahan?",
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text("Pastikan data yang akan dimusnahkan sudah aman dan sesuai", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/delete_sku.svg",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.yesTerminateButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noTerminateButton),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Constant.bottomSheetMargin,
                ),
              ],
            ),
          );
        });
  }

  _showBottomDialogOrderStock(BuildContext context, TerminateDetailController controller) {
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
                    "Apakah kamu yakin untuk melakukan pemesanan stok?",
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text("Pastikan semua data yang akan dipesan stok sudah sesuai", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
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
                      Expanded(child: controller.yesOrderStockButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noOrderStockButton),
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
