import 'package:components/button_fill/button_fill.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';

import '../../../utils/constant.dart';
import '../../../widget/common/loading.dart';
import '../../../widget/common/order_status.dart';
import 'assign_driver_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/05/23

class AssignDriverPage extends StatelessWidget {
  const AssignDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AssignDriverController controller = Get.put(AssignDriverController(context: context));

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
          'Detail Penjualan',
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
      if (products.productCategoryId == null) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
              controller: GetXCreator.putAccordionController('sku${products.name}${products.id}ASSSIGN DRIVERR'),
              headerText: '${products.name}',
              child: Column(
                children: [
                  if (products.category?.name != null) infoDetailSku('Kategori SKU', '${products.category?.name}'),
                  if (products.name != null) infoDetailSku(products.productCategoryId != null ? 'Kategori SKU' : 'SKU', '${products.name}'),
                  if (products.quantity != null) infoDetailSku('Jumlah Ekor', '${products.quantity} Ekor'),
                  if (products.cutType != null && Constant.havePotongan(products.category?.name)) infoDetailSku('Jenis Potong', Constant.getTypePotongan(products.cutType!)),
                  if (products.numberOfCuts != null && products.cutType == 'REGULAR' && Constant.havePotongan(products.category?.name)) infoDetailSku('Potongan', '${products.numberOfCuts} Potong'),
                  if (products.weight != 0) infoDetailSku('Kebutuhan', '${products.weight} Kg'),
                  if (products.price != null) infoDetailSku('Harga', "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
              )),
        );
      } else if (products.productCategoryId != null) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
              controller: GetXCreator.putAccordionController('sku${products.name}delivew;uasdasdasdaj;'),
              headerText: '${products.name}',
              child: Column(
                children: [
                  if (products.category?.name != null) infoDetailSku('Kategori SKU', '${products.category?.name}'),
                  if (products.name != null) infoDetailSku(products.productCategoryId != null ? 'Kategori SKU' : 'SKU', '${products.name}'),
                  if (products.quantity != null && products.quantity != 0) infoDetailSku('Jumlah Ekor', '${products.quantity} Ekor'),
                  if (products.cutType != null && Constant.havePotongan(products.name)) infoDetailSku('Jenis Potong', Constant.getTypePotongan(products.cutType!)),
                  if (products.numberOfCuts != null && products.cutType == 'REGULAR' && Constant.havePotongan(products.name)) infoDetailSku('Potongan', '${products.numberOfCuts} Potong'),
                  if (products.weight != null && products.weight != 0) infoDetailSku('Kebutuhan', '${products.weight} Kg'),
                  if (products.price != null) infoDetailSku('Harga', "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
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

    Widget bottonNavBar() {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
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
                Expanded(
                  child: ButtonFill(
                    controller: GetXCreator.putButtonFillController('assignDriver'),
                    label: 'Kirim',
                    onClick: () {
                      if (controller.spinnerDriver.controller.textSelected.isEmpty) {
                        controller.spinnerDriver.controller.showAlert();
                        Scrollable.ensureVisible(controller.spinnerDriver.controller.formKey.currentContext!);
                        return;
                      }
                      showBottomDialog(context, controller);
                    },
                  ),
                ),
              ],
            ),
          ));
    }

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
                  'Informasi Penjualan',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                ),
                OrderStatus(orderStatus: controller.orderDetail.value!.status ?? '', returnStatus: controller.orderDetail.value!.returnStatus ?? '', grStatus: controller.orderDetail.value!.grStatus),
              ],
            ),
            Text(
              '${controller.orderDetail.value!.code} - ${createdDate.day} ${DateFormat.MMM().format(createdDate)} ${createdDate.year} ',
              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
              overflow: TextOverflow.clip,
            ),
            const SizedBox(
              height: 16,
            ),
            controller.orderDetail.value!.status == 'READY_TO_DELIVER' || controller.orderDetail.value!.status == 'BOOKED'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sumber',
                        style: AppTextStyle.subTextStyle.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        controller.orderDetail.value!.operationUnit!.operationUnitName ?? '-',
                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tujuan',
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value!.customer!.businessName ?? '-',
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
                  'Kategori',
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value!.products!.isEmpty ? '-' : controller.orderDetail.value!.products!.map((e) => e!.category!.name.toString()).reduce((a, b) => '$a , $b'),
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
                  'Dibuat Oleh',
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value?.userCreator?.email ?? '-',
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
                  'Sales Branch',
                  style: AppTextStyle.subTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.orderDetail.value!.salesperson == null ? '-' : '${controller.orderDetail.value!.salesperson?.branch?.name}',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            controller.orderDetail.value!.status == 'READY_TO_DELIVER'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Driver',
                        style: AppTextStyle.subTextStyle.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        controller.orderDetail.value!.driver!.fullName ?? '-',
                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar(),
        ),
        body: Stack(
          children: [
            Obx(() => controller.isLoading.isTrue
                ? const Center(
                    child: ProgressLoading(),
                  )
                : SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          detailOrder(),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Detail SKU',
                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                            overflow: TextOverflow.clip,
                          ),
                          controller.orderDetail.value!.products == null ? const Text(' ') : listExpandadle(controller.orderDetail.value!.products as List<Products?>),
                          if (controller.orderDetail.value!.type! == 'LB') ...[
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Detail Catatan',
                              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                              overflow: TextOverflow.clip,
                            ),
                            listExpandadle(controller.orderDetail.value!.productNotes as List<Products?>)
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
                                        'Total Penjualan',
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
                                        'Total Kg',
                                        style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    Text(
                                      '${controller.sumKg.value.toStringAsFixed(2)}kg',
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
                                          'Total Ekor',
                                          style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      Obx(() => Text(
                                            '${controller.sumChick.value} Ekor',
                                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                            overflow: TextOverflow.clip,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                                if (controller.deliveryPrice.value != 0) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Biaya Pengiriman',
                                          style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(controller.deliveryPrice.value),
                                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
                                      ),
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
                                        'Total Rp',
                                        style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(Convert.roundPrice(controller.sumPrice.value + controller.deliveryPrice.value)),
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
                                  ],
                                )
                              ],
                            ),
                          ),
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
                                  'Catatan',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  controller.orderDetail.value!.remarks != null ? Uri.decodeFull(controller.orderDetail.value!.remarks!) : '-',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          controller.dtDeliveryDate,
                          controller.dtDeliveryTime,
                          controller.spinnerDriver,
                          const SizedBox(
                            height: 120,
                          )
                        ],
                      ),
                    ),
                  )),
            bottonNavBar()
          ],
        ));
  }

  Future<dynamic> showBottomDialog(BuildContext context, AssignDriverController controller) {
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
                    'Apakah kamu yakin data yang dimasukan sudah benar?',
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text('Pastikan semua data yang kamu masukan semua sudah benar', style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    'images/visit_customer.svg',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.bfYesAssign),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: controller.boNoAssign,
                      ),
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
