import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/receive_module/new_receive_purchase/create_receive_purchase_vendor_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/purchase_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 29/05/23

class CreateGrPurchase extends GetView<CreateGrPurchaseController>{
  const CreateGrPurchase({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    CreateGrPurchaseController controller = Get.put(CreateGrPurchaseController(context: context));

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
          "Form Penerimaan",
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
                  "Detail Pembelian",
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
                  "Sumber",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  // controller.salerPerson != null
                  //     ? "${controller.salerPerson}"
                  //     : "-",
                  controller.purchaseDetail.value!.vendor!.name ?? "-",
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
                  controller.purchaseDetail.value!.operationUnit!.operationUnitName ?? "-",
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
                  "Total Kg Dibeli",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.sumNeededMax.value - controller.sumNeededMin.value ==0 ? "${controller.sumNeededMin.value.toStringAsFixed(2)} Kg" : "${controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.sumNeededMax.value.toStringAsFixed(2)} Kg",
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
                  "Total Ekor Yang Dibeli",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  "${controller.sumChick} Ekor",
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
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controller.purchaseDetail.value!.status == "CONFIRMED" ?
                    Expanded(
                        child: ButtonFill(
                          controller: GetXCreator.putButtonFillController("saveGRPurchase"),
                          label: "Simpan",
                          onClick: () {
                            controller.isValid() ?
                            controller.sumChick.value == controller.skuCard.controller.sumChick.value?
                            showBottomDialog(context, controller) : controller.showAlertDialog() :  null ;
                          },
                        )):
                    controller.purchaseDetail.value!.status == "RECEIVED" ? Expanded(
                        child: ButtonFill(
                          controller: GetXCreator.putButtonFillController("cancelGRPurchase"),
                          label: "Batal",
                          onClick: () {
                            controller.isValid() ?
                            controller.sumChick.value == controller.skuCard.controller.sumChick.value?
                            showBottomDialog(context, controller) : controller.showAlertDialog() :  null ;
                          },
                        )):
                    const SizedBox(
                      width: 16,
                    ),
                    Container()
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
        body: Stack(
          children: [
            Obx(() => controller.isLoading.isTrue ?
            const Center(
              child: ProgressLoading(),
            )
                :
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
                      "Detail SKU",
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                      overflow: TextOverflow.clip,
                    ),
                    controller.skuCard,
                    controller.skuCardInternal,
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
                        if (controller.isInternal.isTrue)...[
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
                                Text(controller.skuCardInternal.controller.sumNeededMax.value - controller.skuCardInternal.controller.sumNeededMin.value == 0 ? "${controller.skuCardInternal.controller.sumNeededMin.value.toStringAsFixed(2)} Kg" : "${controller.skuCardInternal.controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.skuCardInternal.controller.sumNeededMax.value.toStringAsFixed(2)} Kg",
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
                                    "Total Ekor",
                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip,
                                ),
                                ),
                                Obx(() => Text("${controller.skuCardInternal.controller.sumChick.value} Ekor",
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                overflow: TextOverflow.clip,)),
                            ],
                        ),
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
                                Text(controller.skuCardInternal.controller.sumPriceMax.value - controller.skuCardInternal.controller.sumPriceMin.value ==0 ? controller.skuCardInternal.controller.sumPriceMin.value == 0 ? "Rp - ":NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.skuCardInternal.controller.sumPriceMin.value) : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.skuCardInternal.controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.skuCardInternal.controller.sumPriceMax.value)}",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip),
                            ],
                        )

                    ]
                    else ...[
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
                                Text(controller.skuCard.controller.sumNeededMax.value - controller.skuCard.controller.sumNeededMin.value ==0 ? "${controller.skuCard.controller.sumNeededMin.value.toStringAsFixed(2)} Kg" : "${controller.skuCard.controller.sumNeededMin.value.toStringAsFixed(2)} Kg - ${controller.skuCard.controller.sumNeededMax.value.toStringAsFixed(2)} Kg",
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
                                    "Total Ekor",
                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip,
                                ),
                                ),
                                Obx(() => Text("${controller.skuCard.controller.sumChick.value} Ekor",
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                overflow: TextOverflow.clip,)),
                            ],
                        ),
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
                                Text(controller.skuCard.controller.sumPriceMax.value - controller.skuCard.controller.sumPriceMin.value ==0 ? NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.skuCard.controller.sumPriceMin.value) : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.skuCard.controller.sumPriceMin.value)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.skuCard.controller.sumPriceMax.value)}",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip),
                            ],
                        )
                    ]
                    ],
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    )
                ],
                ),
              ),
            )
            ),
            bottomNavBar()
          ],

        ));

  }

  showBottomDialog(BuildContext context, CreateGrPurchaseController controller) {
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
                    "Apakah kamu yakin data yang dimasukan sudah benar?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Pastikan semua data yang kamu masukan semua sudah benar",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/visit_customer.svg",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.bfYesGrPurchase),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: controller.boNoGrPurchase,
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
