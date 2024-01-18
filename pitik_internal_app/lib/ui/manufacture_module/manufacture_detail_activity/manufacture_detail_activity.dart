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
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_detail_activity/manufacture_detail_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/manufacture_status.dart';

class ManufactureDetailActivity extends StatelessWidget {
  const ManufactureDetailActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final ManufactureDetailController controller =
        Get.put(ManufactureDetailController(context: context));
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
          "Detail Manufaktur",
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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controller.manufactureModel.status == "INPUT_DRAFT"
                      ? Expanded(
                          child: ButtonFill(
                              controller: GetXCreator.putButtonFillController(
                                  "editManufacture"),
                              label: "Edit",
                              onClick: () {
                                    Get.toNamed(RoutePage.manufactureEdit, arguments: controller.manufactureModel)!.then((value) {
                                        controller.isLoading.value =true;
                                        Timer(const Duration(milliseconds: 500), () {
                                            controller.getDetailManufacture();
                                        });
                                    });
                                }))
                      : controller.manufactureModel.status == "INPUT_CONFIRMED"
                          ? Expanded(
                              child: ButtonFill(
                                  controller: GetXCreator.putButtonFillController(
                                      "pesanStock"),
                                  label: "Pesan Stock",
                                  onClick: () {
                                    _showBottomDialogSend(context, controller);
                                  }))
                          : controller.manufactureModel.status == "INPUT_BOOKED"
                              ? Expanded(
                                  child: ButtonFill(
                                      controller:
                                          GetXCreator.putButtonFillController(
                                              "createOutput"),
                                      label: "Buat Output",
                                      onClick: () {
                                        Get.toNamed(RoutePage.manufactureOutput, arguments: [controller.manufactureModel, false])!.then((value) {
                                            controller.isLoading.value =true;
                                            Timer(const Duration(milliseconds: 500), () {
                                                controller.getDetailManufacture();
                                            });
                                        });
                                      }))
                              : controller.manufactureModel.status == "OUTPUT_DRAFT"
                                  ? Expanded(
                                      child: ButtonFill(
                                          controller:
                                              GetXCreator.putButtonFillController(
                                                  "editManufacture"),
                                          label: "Edit",
                                          onClick: () {
                                                Get.toNamed(RoutePage.manufactureOutput, arguments: [controller.manufactureModel, true])!.then((value) {
                                                    controller.isLoading.value =true;
                                                    Timer(const Duration(milliseconds: 500), () {
                                                        controller.getDetailManufacture();
                                                    });
                                                });
                                          }))
                                  : controller.manufactureModel.status ==
                                          "OUTPUT_CONFIRMED"
                                      ? Expanded(
                                          child: ButtonFill(
                                              controller: GetXCreator
                                                  .putButtonFillController(
                                                      "cancelManufacture"),
                                              label: "Batal",
                                              onClick: () {
                                                _showBottomDialogCancel(
                                                    context, controller);
                                              }))
                                      : const SizedBox(),
                                      if(controller.manufactureModel.status == "INPUT_DRAFT")...[
                                        const SizedBox(width: 16,),
                                         Expanded(
                                            child: ButtonOutline(
                                                controller: GetXCreator.putButtonOutlineController(
                                                    "cancelManufacture"),
                                                label: "Batal",
                                                onClick: () {
                                                    _showBottomDialogCancel(context, controller);
                                                }))
                                      ]
                                      else if(controller.manufactureModel.status == "INPUT_CONFIRMED")...[
                                        const SizedBox(width: 16,),
                                        Expanded(
                                            child: ButtonOutline(
                                                controller:
                                                    GetXCreator.putButtonOutlineController(
                                                        "cancelManufacture"),
                                                label: "Batal",
                                                onClick: () {
                                                    _showBottomDialogCancel(context, controller);
                                                }))
                                      ]
                                      else if(controller.manufactureModel.status == "INPUT_BOOKED")...[
                                        const SizedBox(width: 16,),
                                        Expanded(
                                            child: ButtonOutline(
                                                controller:
                                                    GetXCreator.putButtonOutlineController(
                                                        "cancelManufacture"),
                                                label: "Batal",
                                                onClick: () {
                                                    _showBottomDialogCancel(
                                                        context, controller);
                                                }))

                                      ]
                                      else if(controller.manufactureModel.status == "OUTPUT_DRAFT")...[
                                        const SizedBox(width: 16,),
                                        Expanded(
                                      child: ButtonOutline(
                                          controller: GetXCreator
                                              .putButtonOutlineController(
                                                  "cancelManufacture"),
                                          label: "Batal",
                                          onClick: () {
                                                _showBottomDialogCancel(
                                                    context, controller);
                                          }))
                                      ]
                                      else const SizedBox(),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${controller.manufactureModel.input!.name}",
                        style: AppTextStyle.blackTextStyle.copyWith(
                            fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${controller.manufactureModel.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                ManufactureStatus(
                    manufactureStatus: controller.manufactureModel.status),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader(
                "Sumber", controller.manufactureModel.operationUnit!.operationUnitName!),
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
            style: AppTextStyle.blackTextStyle
                .copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
          )
        ],
      );
    }

    List<Widget> detailSku() {
      return [
        Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: const BoxDecoration(
              color: AppColors.headerSku,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Text(
            "${controller.manufactureModel.input!.productItems![0]!.name}",
            style:
                AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
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
              top: BorderSide(color: AppColors.outlineColor, width: 0.1),
            ),
            // border: Border.all(color: AppColors.grey, width: 1),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          ),
          child: Column(
            children: [
                infoDetailSKU(
                    "Kategori SKU", controller.manufactureModel.input!.name!),
                const SizedBox(
                    height: 14,
                ),
                infoDetailSKU("Jumlah Ekor","${controller.manufactureModel.input!.productItems![0]!.quantity} Ekor"),
                if(controller.manufactureModel.input!.productItems![0]!.weight !=0 && controller.manufactureModel.input!.productItems![0]!.weight != null)...[
                const SizedBox(
                    height: 14,
                ),
                infoDetailSKU( "Total", "${controller.manufactureModel.input!.productItems![0]!.weight} Kg"),
                ],

            ],
          ),
        ),
      ];
    }

    Widget detailSKUOutput(Products product){
        return Container(
            margin: const EdgeInsets.only(top: 16),
          child: Expandable(controller: GetXCreator.putAccordionController(product.name!), headerText: product.name!, child: Column(
              children: product.productItems!.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(item!.name!, style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),),
                        if(item.quantity !=0 &&item.quantity !=null  )...[
                            const SizedBox(height: 4,),
                            infoDetailSKU("Total Ekor", "${item.quantity} Ekor")
                        ],
                        if(item.weight !=null && item.weight !=0 )...[
                            const SizedBox(height: 4,),
                            infoDetailSKU("Total kg", "${item.weight?.toStringAsFixed(2)} Kg")
                        ]
                    ],
                ),
              )).toList()
          )),
        );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: appBar(),
      ),
      body:Obx(() => controller.isLoading.isTrue ? const Center(child: ProgressLoading() ) : Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailInformation(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Detail SKU",
                      style: AppTextStyle.blackTextStyle
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ...detailSku(),
                  if (controller.manufactureModel.status == "OUTPUT_DRAFT" ||
                      controller.manufactureModel.status ==
                          "OUTPUT_CONFIRMED") ...[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Detail Output",
                        style: AppTextStyle.blackTextStyle
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Column(children : controller.manufactureModel.output!.map((e) => detailSKUOutput(e!)).toList()),
                  ],

                  if(controller.manufactureModel.outputTotalWeight != null && controller.manufactureModel.outputTotalWeight != 0) ...[
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
                                  "${(controller.manufactureModel.outputTotalWeight ?? 0)} Kg",
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                  ],
                    const SizedBox(height: 100,)
                ],
              ),
            ),
          ),
                controller.manufactureModel.status == "CANCELLED"  ? const SizedBox() : bottomNavbar()
        ],
      ),
    ));
  }

  _showBottomDialogCancel(
      BuildContext context, ManufactureDetailController controller) {
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
                  child: const Text("Pastikan data aman sebelum melakukan pembatalan",
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
                      Expanded(child: controller.noCancelButton),
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
      BuildContext context, ManufactureDetailController controller) {
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
                      Expanded(child: controller.noSendButton),
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
