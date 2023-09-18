import 'package:components/button_outline/button_outline.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/ui/sales_order_module/sales_order_detail/detail_sales_order_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/order_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23

class DetailSalesOrder extends GetView<DetailSalesOrderController>{
  const DetailSalesOrder({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    DetailSalesOrderController controller = Get.put(DetailSalesOrderController(context: context));

    Widget detailOrder() {
      final DateTime createdDate = Convert.getDatetime(controller.orderDetail.value!.createdDate!);
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
                  "Informasi Penjualan",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                ),
                OrderStatus(orderStatus: controller.orderDetail.value!.status ?? "", returnStatus: controller.orderDetail.value!.returnStatus ?? "",grStatus: controller.orderDetail.value!.grStatus, soPage: true,),
              ],
            ),
            Text(
              "${controller.orderDetail.value!.code} - ${createdDate.day} ${DateFormat.MMM().format(createdDate)} ${createdDate.year}",
              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
              overflow: TextOverflow.clip,
            ),
            const SizedBox(
              height: 16,
            ),
            controller.orderDetail.value!.status =="READY_TO_DELIVER" || controller.orderDetail.value!.status =="BOOKED" ?
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
                  "${controller.orderDetail.value!.operationUnit!.operationUnitName ?? "-"}",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                ),
              ],
            ): Container(),
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
                  "${controller.orderDetail.value!.customer!.businessName ?? "-"}",
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
                  "Kategori",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value!.type == "LB" ? "LB" : "Non LB",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            controller.orderDetail.value!.status =="READY_TO_DELIVER" ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Driver",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  "${controller.orderDetail.value!.driver!.fullName ?? "-"}",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),overflow: TextOverflow.ellipsis,
                ),
              ],
            )
                : Container(),
          ],
        ),
      );
    }

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
          "Detail Penjualan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
      return (products.returnWeight ==null || products.returnWeight ==0) &&(products.returnQuantity ==null || products.returnQuantity ==0) ?  Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller:
                GetXCreator.putAccordionController("sku${products.name}"),
            headerText: "${products.name}",
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
                if(products.price != null ) infoDetailSku("Harga",
                    "${Convert.toCurrency("${products.price }", "Rp. ", ".")}/Kg"),
              ],
            )),
      ) : Container(
      );
    }


    Widget listExpandadle(List<Products?> products) {
      return Column(
          children: products
              .map((Products? products) => customExpandalbe(products!))
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
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controller.orderDetail.value!.status == "DRAFT" ?
                    Expanded(
                      child: controller.editButton,
                    ): controller.orderDetail.value!.status =="CONFIRMED" ?
                    Expanded(
                      child: controller.bookStockButton,
                    ) :controller.orderDetail.value!.status =="BOOKED" ?
                    Expanded(
                      child: controller.sendButton,
                    ):controller.orderDetail.value!.status =="READY_TO_DELIVER" ?
                    Expanded(
                      child: controller.editDriver,
                    ):
                    Container(),
                    const SizedBox(
                      width: 16,
                    ),
                    controller.orderDetail.value!.status == "DRAFT" ?
                    Expanded(
                      child: ButtonOutline(
                        controller: GetXCreator.putButtonOutlineController("batalPenjualan"),
                        label: "Batal",
                        onClick: () {
                          showBottomDialog(context, controller);
                        },
                      ),
                    ): controller.orderDetail.value!.status =="CONFIRMED"
                        || controller.orderDetail.value!.status =="BOOKED"
                        || controller.orderDetail.value!.status =="READY_TO_DELIVER"?
                    Expanded(
                      child: ButtonOutline(
                        controller: GetXCreator.putButtonOutlineController("batalPenjualan"),
                        label: "Batal",
                        onClick: () {
                          showBottomDialog(context, controller);
                        },
                      ),
                    ) :
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
                    detailOrder(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Detail SKU",
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                      overflow: TextOverflow.clip,
                    ),
                    controller.orderDetail.value!.products == null ? const Text(" ") :
                    listExpandadle(controller.orderDetail.value!.products as List<Products?>),
                    controller.orderDetail.value!.type! == "LB" ? const SizedBox(
                      height: 16,
                    ): Container(),
                    controller.orderDetail.value!.type! == "LB" ? Text(
                      "Detail Catatan",
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                      overflow: TextOverflow.clip,
                    ): const Text("")
                    ,  controller.orderDetail.value!.type! == "LB" ?
                    listExpandadle(controller.orderDetail.value!.productNotes as List<Products?>) : Container(),
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
                            if(controller.orderDetail.value!.status =="BOOKED" || controller.orderDetail.value!.status =="READY_TO_DELIVER")...[
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
                                    Text(NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.sumPrice.value),
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
                            ]
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    )],
                ),
              ),
            ),
            controller.orderDetail.value!.status == "DELIVERED" ||
                controller.orderDetail.value!.status == "CANCELLED" ?
            Container() : bottomNavBar()
          ],

        )));

  }

  showBottomDialog(BuildContext context, DetailSalesOrderController controller) {
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
                ),  const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        });
  }


}
