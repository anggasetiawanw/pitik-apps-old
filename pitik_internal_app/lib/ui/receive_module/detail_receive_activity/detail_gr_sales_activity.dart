import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_activity/detail_gr_sales_controller.dart';
import 'package:pitik_internal_app/widget/common/lead_status.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/order_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23

class DetailGrOrder extends GetView<DetailGrOrderController>{
  const DetailGrOrder({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    DetailGrOrderController controller = Get.put(DetailGrOrderController(context: context));

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
                  controller.orderDetail.value!.grStatus =="RECEIVED"  ? "Informasi Penerimaan" : "Informasi Pengembalian" ,
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                ),
                OrderStatus(orderStatus: controller.orderDetail.value!.status ?? "", returnStatus: controller.orderDetail.value!.returnStatus ?? "",grStatus: controller.orderDetail.value!.grStatus),
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
                  "${controller.orderDetail.value!.operationUnit == null ? "-" : controller.orderDetail.value!.operationUnit!.operationUnitName}",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
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
                  "Alasan",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  "${controller.orderDetail.value!.returnReason != null ? controller.orderDetail.value!.returnReason! :  "-" }",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 8,)

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
                controller.orderDetail.value!.status != null
                    ? controller
                    .orderDetail.value!.status!
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


    Widget customExpandalbe(Products products) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller: GetXCreator.putAccordionController(products.id!),
            headerText: products.name!,
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: ),
              child: Column(
                children: [
                  listDetail("Kategori SKU", products.category != null ? products.category!.name! : "-", false),
                  listDetail("SKU",products.name != null ? products.name! : "-", false),
                 products.returnQuantity !=null || products.returnQuantity != 0? listDetail("Jumlah Ekor","${products.returnQuantity} Ekor", false) :const SizedBox(),
                  listDetail("Kebutuhan","${ products.returnWeight ?? "-"} Kg", false),
                  controller.orderDetail.value!.type == "LB" ? Container(): listDetail("Harga ", "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(products.price!)} /Kg",false),
                ],
              ),
            )),

      );
    }


    Widget listExpandadle(List<Products?> products) {
      return Column(
          children: products
              .map((Products? products) => customExpandalbe(products!))
              .toList());
    }

    Widget bottonNavBar() {
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
                padding: const EdgeInsets.only(left: 16, bottom: 16,right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (controller.orderDetail.value!.status == "REJECTED" &&controller.orderDetail.value!.returnStatus == "FULL" )|| (controller.orderDetail.value!.grStatus == "REJECTED" && controller.orderDetail.value!.returnStatus == "PARTIAL") ?
                    Expanded(
                      child: controller.createGr,
                    ): Container(),
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
        body: Obx(() => controller.isLoading.isTrue ?
            Container(
              child: const Center(
                child: ProgressLoading(),
              ),
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
                      controller.orderDetail.value!.status =="RECEIVED"  ? "Detail SKU Penerimaan" : "Detail SKU Pengembalian",
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
                        if(controller.sumChick !=0)...[
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    )
                  ],
                ),
              ),
            ),
            (controller.orderDetail.value!.status == "REJECTED" &&controller.orderDetail.value!.returnStatus == "FULL" )|| (controller.orderDetail.value!.grStatus == "REJECTED" && controller.orderDetail.value!.returnStatus == "PARTIAL") ? bottonNavBar() : Container()
          ],

        )));

  }

}
