import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_activity/detail_gr_sales_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/so_status.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/order_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23

class DetailGrOrder extends GetView<DetailGrOrderController> {
  const DetailGrOrder({super.key});

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
                Expanded(
                  child: Text(
                    controller.orderDetail.value!.grStatus == "RECEIVED" ? "Informasi Penerimaan" : "Informasi Pengembalian",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                    overflow: TextOverflow.clip,
                  ),
                ),
                OrderStatus(
                  orderStatus: controller.orderDetail.value!.status ?? "",
                  returnStatus: controller.orderDetail.value!.returnStatus ?? "",
                  grStatus: controller.orderDetail.value!.grStatus,
                  soPage: false,
                ),
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
                  controller.orderDetail.value!.customer!.businessName ?? "-",
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
                  controller.orderDetail.value!.returnReason != null ? controller.orderDetail.value!.returnReason! : "-",
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
                  "Dibuat Oleh",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value?.userCreator?.email ?? "-",
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
                  "Sales Branch",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value!.salesperson == null ? "-" : "${controller.orderDetail.value!.salesperson?.branch?.name}",
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
                  "Target Pengiriman",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value!.deliveryTime != null ? DateFormat("dd MMM yyyy").format(Convert.getDatetime(controller.orderDetail.value!.deliveryTime!)) : "-",
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
                  "Waktu Pengiriman",
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value!.deliveryTime != null
                      ? DateFormat("HH:mm").format(Convert.getDatetime(controller.orderDetail.value!.deliveryTime!)) != "00:00"
                          ? DateFormat("HH:mm").format(Convert.getDatetime(controller.orderDetail.value!.deliveryTime!))
                          : "-"
                      : "-",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
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
          "Detail Penerimaan",
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget infoDetailSku(String title, String name) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Row(
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
        ),
      );
    }

    Widget customExpandalbe(Products products) {
        if(products.returnWeight != null) {
        return Container(
            margin: const EdgeInsets.only(top: 16),
            child: Expandable(
                controller: GetXCreator.putAccordionController("skuNote${products.name}${products.id}Ntess"),
                headerText: products.name!,
                child: Column(
                children: [
                    if (products.category?.name != null) infoDetailSku("Kategori SKU", "${products.category?.name}"),
                    if (products.name != null) infoDetailSku(products.productCategoryId != null ? "Kategori SKU" : "SKU", "${products.name}"),
                    if (products.returnQuantity != 0) infoDetailSku("Jumlah Ekor", "${products.returnQuantity ?? products.quantity} Ekor"),
                    if (products.cutType != null) infoDetailSku("Jenis Potong", products.cutType == "REGULAR" ? "Potong Biasa" : "Bekakak"),
                    if (products.numberOfCuts != null && products.cutType == "REGULAR") infoDetailSku("Potongan", "${products.numberOfCuts} Potong"),
                    if (products.returnWeight != 0) infoDetailSku("Kebutuhan", "${products.returnWeight ?? products.weight} Kg"),
                    if (products.price != null) infoDetailSku("Harga", "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
                )),
        );
        } else {
        return const SizedBox();
        }
    }

    Widget customExpandalbeDetail(Products products) {
      if (products.productCategoryId == null) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
              controller: GetXCreator.putAccordionController("sku${products.name}${products.id}ALLOCATEDD BOdddddOKasdasd"),
              headerText: "${products.name}",
              child: Column(
                children: [
                  if (products.category?.name != null) infoDetailSku("Kategori SKU", "${products.category?.name}"),
                  if (products.name != null) infoDetailSku(products.productCategoryId != null ? "Kategori SKU" : "SKU", "${products.name}"),
                  if (products.quantity != null) infoDetailSku("Jumlah Ekor", "${products.quantity} Ekor"),
                  if (products.cutType != null && Constant.havePotongan(products.category?.name)) infoDetailSku("Jenis Potong", Constant.getTypePotongan(products.cutType!)),
                  if (products.numberOfCuts != null && products.cutType == "REGULAR" && Constant.havePotongan(products.category?.name)) infoDetailSku("Potongan", "${products.numberOfCuts} Potong"),
                  if (products.weight != 0) infoDetailSku("Kebutuhan", "${products.weight} Kg"),
                  if (products.price != null) infoDetailSku("Harga", "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
              )),
        );
      } else if (products.productCategoryId != null) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
              controller: GetXCreator.putAccordionController("sku${products.name}delivew;ujasdads;ssssss"),
              headerText: "${products.name}",
              child: Column(
                children: [
                  if (products.category?.name != null) infoDetailSku("Kategori SKU", "${products.category?.name}"),
                  if (products.name != null) infoDetailSku(products.productCategoryId != null ? "Kategori SKU" : "SKU", "${products.name}"),
                  if (products.quantity != null && products.quantity != 0) infoDetailSku("Jumlah Ekor", "${products.quantity} Ekor"),
                  if (products.cutType != null && Constant.havePotongan(products.name)) infoDetailSku("Jenis Potong", Constant.getTypePotongan(products.cutType!)),
                  if (products.numberOfCuts != null && products.cutType == "REGULAR" && Constant.havePotongan(products.name)) infoDetailSku("Potongan", "${products.numberOfCuts} Potong"),
                  if (products.weight != null && products.weight != 0) infoDetailSku("Kebutuhan", "${products.weight} Kg"),
                  if (products.price != null) infoDetailSku("Harga", "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
              )),
        );
      } else {
        return Container();
      }
    }

    Widget listExpandadle(List<Products?> products) {
      return Column(children: products.map((Products? products) => customExpandalbe(products!)).toList());
    }

    Widget listExpandadleDetails(List<Products?> products) {
      return Column(children: products.map((Products? products) => customExpandalbeDetail(products!)).toList());
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
                  boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (controller.orderDetail.value?.grStatus != EnumSO.received)
                        ? Expanded(
                            child: controller.createGr,
                          )
                        : const SizedBox(),
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
        body: Obx(() => controller.isLoading.isTrue
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
                          detailOrder(),
                          const SizedBox(
                            height: 20,
                          ),
                          if (controller.orderDetail.value!.grStatus != "RECEIVED" && controller.orderDetail.value!.returnStatus == "PARTIAL") ...[
                            Text(
                              "Detail SKU",
                              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                              overflow: TextOverflow.clip,
                            ),
                            listExpandadleDetails(controller.orderDetail.value!.products as List<Products?>),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                          Text(
                            controller.orderDetail.value!.grStatus == "RECEIVED" ? "Detail SKU Penerimaan" : "Detail SKU Ditolak",
                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                            overflow: TextOverflow.clip,
                          ),
                          if (controller.orderDetail.value!.grStatus == "RECEIVED" && controller.orderDetail.value!.goodsReceived == null) ...[listExpandadle(controller.orderDetail.value!.goodsReceived?.products as List<Products?>)] else listExpandadle(controller.orderDetail.value!.products as List<Products?>),
                          if (controller.orderDetail.value!.type! == "LB") ...[
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Detail Catatan",
                              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                              overflow: TextOverflow.clip,
                            ),
                            listExpandadleDetails(controller.orderDetail.value!.productNotes as List<Products?>)
                          ],
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
                                    Text(
                                      "${controller.sumKg.value.toStringAsFixed(2)}kg",
                                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                if (controller.sumChick.value != 0) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Total Ekor",
                                          style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      Obx(() => Text(
                                            "${controller.sumChick.value} Ekor",
                                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          )),
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
                                    Text(NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(controller.sumPrice.value), style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
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
                  (controller.orderDetail.value!.status == "REJECTED" && controller.orderDetail.value!.returnStatus == "FULL") || (controller.orderDetail.value!.grStatus == "REJECTED" && controller.orderDetail.value!.returnStatus == "PARTIAL") ? bottonNavBar() : const SizedBox()
                ],
              )));
  }
}
