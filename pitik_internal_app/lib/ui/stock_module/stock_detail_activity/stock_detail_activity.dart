import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/ui/stock_module/stock_detail_activity/stock_detail_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/stock_status.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/stock_status.dart';
import 'package:screenshot/screenshot.dart';

class StockDetailActivity extends StatelessWidget {
  const StockDetailActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final StockDetailController controller = Get.put(StockDetailController(context: context));
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
          "Detail Stock Opname",
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
            boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.opnameModel.status == EnumStock.draft) ...[
                Expanded(
                    child: ButtonFill(
                        controller: GetXCreator.putButtonFillController("editButton"),
                        label: "Edit",
                        onClick: () {
                          Get.toNamed(RoutePage.stockOpname, arguments: [controller.opnameModel, true, null])!.then((value) {
                            controller.isLoading.value = true;
                            Timer(const Duration(milliseconds: 500), () {
                              controller.getDetailStock();
                            });
                          });
                        })),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: ButtonOutline(
                        controller: GetXCreator.putButtonOutlineController("cancelButton"),
                        label: "Batal",
                        onClick: () {
                          _showBottomDialog(context, controller);
                        })),
              ] else if (controller.opnameModel.status == EnumStock.confirmed) ...[
                if (Constant.isOpsLead.isTrue) ...[
                  Expanded(child: controller.btSetujui),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(child: controller.btTolak)
                ] else ...[
                  Expanded(
                      child: ButtonOutline(
                          controller: GetXCreator.putButtonOutlineController("cancelButton"),
                          label: "Batal",
                          onClick: () {
                            _showBottomDialog(context, controller);
                          })),
                ]
              ]
            ],
          ),
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
                        "Informasi Stock Opname",
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${controller.opnameModel.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                StockStatus(
                  stockStatus: "${controller.opnameModel.status}",
                  isApprove: controller.opnameModel.reviewer != null ? true : false,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader("Sumber", "${controller.opnameModel.operationUnit!.operationUnitName}"),
          ],
        ),
      );
    }

    Widget detailSKU(Products product) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller: GetXCreator.putAccordionController("${product.name!}Detail"),
            headerText: product.name!,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.productItems!.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item!.name!,
                          style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jumlah sebelum",
                                  style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                if (product.name == AppStrings.LIVE_BIRD || product.name == AppStrings.AYAM_UTUH || product.name == AppStrings.BRANGKAS || product.name == AppStrings.KARKAS) ...[
                                  Text(
                                    item.previousQuantity == null ? "-" : "${item.previousQuantity ?? 0} ${product.quantityUOM}",
                                    style: item.previousQuantity == null
                                        ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                        : item.previousQuantity == 0
                                            ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                            : item.quantity == item.previousQuantity
                                                ? AppTextStyle.greenTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                                  )
                                ] else
                                  Text(
                                    item.previousWeight == null ? "-" : "${item.previousWeight ?? 0} ${product.weightUOM}",
                                    style: item.previousWeight == null
                                        ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                        : item.previousWeight == 0
                                            ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                            : item.weight == item.previousWeight
                                                ? AppTextStyle.greenTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                                  )
                              ],
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jumlah Sesudah",
                                  style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                if (product.name == AppStrings.LIVE_BIRD || product.name == AppStrings.AYAM_UTUH || product.name == AppStrings.BRANGKAS || product.name == AppStrings.KARKAS) ...[
                                  Text(
                                    "${item.quantity ?? 0} ${product.quantityUOM}",
                                    style: item.quantity == null
                                        ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                        : item.quantity == 0
                                            ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                            : item.quantity == item.previousQuantity
                                                ? AppTextStyle.greenTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                                  )
                                ] else
                                  Text(
                                    "${item.weight ?? 0} ${product.weightUOM}",
                                    style: item.weight == null
                                        ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                        : item.weight == 0
                                            ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                            : item.weight == item.previousWeight
                                                ? AppTextStyle.greenTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                                  )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jumlah Selisih",
                              style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            if (product.name == AppStrings.LIVE_BIRD || product.name == AppStrings.AYAM_UTUH || product.name == AppStrings.BRANGKAS || product.name == AppStrings.KARKAS) ...[
                              Text(
                                  item.previousQuantity == null && item.quantity == null
                                      ? "-"
                                      : item.quantity! > item.previousQuantity!
                                          ? "> ${item.quantity! - item.previousQuantity!} ${product.quantityUOM}"
                                          : item.quantity! < item.previousQuantity!
                                              ? "< ${item.previousQuantity! - item.quantity!} ${product.quantityUOM}"
                                              : item.previousQuantity! - item.quantity! == 0
                                                  ? "-"
                                                  : "-",
                                  style: item.previousQuantity == null && item.quantity == null
                                      ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                      : item.quantity! > item.previousQuantity!
                                          ? AppTextStyle.redTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                          : item.quantity! < item.previousQuantity!
                                              ? AppTextStyle.redTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                              : item.previousQuantity! - item.quantity! == 0
                                                  ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                  : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium))
                            ] else
                              Text(
                                item.weight == null && item.previousWeight == null
                                    ? "-"
                                    : item.weight! > item.previousWeight!
                                        ? "> ${item.weight! - item.previousQuantity!} ${product.quantityUOM ?? product.weightUOM}"
                                        : item.weight! < item.previousWeight!
                                            ? "< ${item.previousQuantity! - item.weight!} ${product.quantityUOM ?? product.weightUOM}"
                                            : item.previousQuantity! - item.weight! == 0
                                                ? "-"
                                                : "-",
                                style: item.weight == null && item.previousWeight == null
                                    ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                    : item.weight! > item.previousWeight!
                                        ? AppTextStyle.redTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                        : item.weight! < item.previousWeight!
                                            ? AppTextStyle.redTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                            : item.weight! - item.previousWeight! == 0
                                                ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                              )
                          ],
                        ),
                        if (product.productItems!.last != item && product.productItems!.length > 1) ...[
                          const SizedBox(
                            height: 24,
                          ),
                          const Divider(
                            color: AppColors.outlineColor,
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ]
                      ],
                    ),
                  );
                }).toList())),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar(),
        ),
        body: Screenshot(
          controller: controller.screenshotController,
          child: Obx(
            () => controller.isLoading.isTrue
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
                              if (controller.opnameModel.reviewer != null && controller.opnameModel.status == EnumStock.finished) ...[
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
                                            Text(DateFormat("dd MMM yyyy HH:mm", "id").format(DateTime.parse(controller.opnameModel.confirmedDate ?? DateFormat("dd MMM yyyy HH:mm", "id").format(DateTime.now()))), style: AppTextStyle.blackTextStyle.copyWith()),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text("Disetujui dan diperiksa oleh", style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12)),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text("${controller.opnameModel.reviewer!.fullName}", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium)),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text("Email", style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12)),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text("${controller.opnameModel.reviewer!.email}", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium)),
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
                                              "Saya dengan teliti dan sadar sudah memeriksa hasil Stock Opname",
                                              style: AppTextStyle.blackTextStyle,
                                              overflow: TextOverflow.clip,
                                            )),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Text(
                                  "Detail SKU",
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Column(children: controller.opnameModel.products!.map((e) => detailSKU(e!)).toList()),
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
                                      "${(controller.opnameModel.totalWeight ?? 0)} Kg",
                                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                      ),
                      controller.opnameModel.status == EnumStock.draft || controller.opnameModel.status == EnumStock.confirmed ? bottomNavbar() : const SizedBox()
                    ],
                  ),
          ),
        ));
  }

  _showBottomDialog(BuildContext context, StockDetailController controller) {
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
                      Expanded(child: controller.yesButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noButton),
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
