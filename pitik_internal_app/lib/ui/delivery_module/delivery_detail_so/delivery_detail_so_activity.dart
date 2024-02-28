import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_fill/button_fill_controller.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import '../../../utils/constant.dart';
import '../../../utils/enum/so_status.dart';
import '../../../widget/common/custom_appbar.dart';
import '../../../widget/common/loading.dart';
import '../../../widget/common/order_status.dart';

import 'delivery_detail_so_controller.dart';

class DeliveryDetailSO extends StatelessWidget {
  const DeliveryDetailSO({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryDetailSOController controller = Get.put(DeliveryDetailSOController(context: context));

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
            overflow: TextOverflow.ellipsis,
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
                        'Informasi Pengiriman',
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${controller.order.code} - ${Convert.getDateFormat(controller.order.createdDate!)}',
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                      )
                    ],
                  ),
                ),
                OrderStatus(
                  orderStatus: controller.order.status,
                  returnStatus: controller.order.returnStatus,
                  grStatus: controller.order.grStatus,
                  soPage: true,
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader('Sumber', '${controller.order.operationUnit!.operationUnitName}'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Tujuan', "${controller.order.customer == null ? "-" : controller.order.customer!.businessName}"),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Kategori', controller.order.type == 'LB' ? 'LB' : 'NON-LB'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Dibuat Oleh', controller.order.userCreator?.email ?? '-'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Sales Branch', controller.order.salesperson == null ? '-' : '${controller.order.salesperson?.branch?.name}'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Driver', "${controller.order.driver == null ? "-" : controller.order.driver!.fullName}"),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Target Pengiriman', controller.order.deliveryTime != null ? DateFormat('dd MMM yyyy').format(Convert.getDatetime(controller.order.deliveryTime!)) : '-'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader(
              'Waktu Pengiriman',
              controller.order.deliveryTime != null
                  ? DateFormat('HH:mm').format(Convert.getDatetime(controller.order.deliveryTime!)) != '00:00'
                      ? DateFormat('HH:mm').format(Convert.getDatetime(controller.order.deliveryTime!))
                      : '-'
                  : '-',
            ),
          ],
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
      if ((products.returnWeight == null || products.returnWeight == 0) && (products.returnQuantity == null || products.returnQuantity == 0) && products.productCategoryId == null) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
              controller: GetXCreator.putAccordionController('sku${products.name}delivew;uj;'),
              headerText: '${products.name}',
              child: Column(
                children: [
                  if (products.category?.name != null) infoDetailSku('Kategori SKU', '${products.category?.name}'),
                  if (products.name != null) infoDetailSku(products.productCategoryId != null ? 'Kategori SKU' : 'SKU', '${products.name}'),
                  if (products.quantity != null && products.quantity != 0) infoDetailSku('Jumlah Ekor', '${products.quantity} Ekor'),
                  if (products.cutType != null && Constant.havePotongan(products.category?.name)) infoDetailSku('Jenis Potong', Constant.getTypePotongan(products.cutType!)),
                  if (products.numberOfCuts != null && products.cutType == 'REGULAR' && Constant.havePotongan(products.category?.name)) infoDetailSku('Potongan', '${products.numberOfCuts} Potong'),
                  if (products.weight != null && products.weight != 0) infoDetailSku('Kebutuhan', '${products.weight} Kg'),
                  if (products.price != null) infoDetailSku('Harga', "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                ],
              )),
        );
      } else if (products.productCategoryId != null) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
              controller: GetXCreator.putAccordionController('sku${products.name}delivew;uj;asdasdasdasas'),
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
        if (controller.order.returnStatus == 'FULL') {
          return Container(
            margin: const EdgeInsets.only(top: 16),
            child: Expandable(
                controller: GetXCreator.putAccordionController('sku${products.name}delivewaabcasddz'),
                headerText: '${products.name}',
                child: Column(
                  children: [
                    if (products.category?.name != null) infoDetailSku('Kategori SKU', '${products.category?.name}'),
                    if (products.name != null) infoDetailSku(products.productCategoryId != null ? 'Kategori SKU' : 'SKU', '${products.name}'),
                    if (products.returnQuantity != null) infoDetailSku('Jumlah Ekor', '${products.returnQuantity!} Ekor'),
                    if (products.cutType != null && Constant.havePotongan(products.category?.name)) infoDetailSku('Jenis Potong', Constant.getTypePotongan(products.cutType!)),
                    if (products.numberOfCuts != null && products.cutType == 'REGULAR' && Constant.havePotongan(products.category?.name)) infoDetailSku('Potongan', '${products.numberOfCuts} Potong'),
                    if (products.returnWeight != null) infoDetailSku('Kebutuhan', '${products.returnWeight!} Kg'),
                    if (products.price != null) infoDetailSku('Harga', "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                  ],
                )),
          );
        } else {
          if (products.weight! - products.returnWeight! != 0 || products.quantity! - products.returnQuantity! != 0) {
            return Container(
              margin: const EdgeInsets.only(top: 16),
              child: Expandable(
                  controller: GetXCreator.putAccordionController('sku${products.name}delivewaabc'),
                  headerText: '${products.name}',
                  child: Column(
                    children: [
                      if (products.category?.name != null) infoDetailSku('Kategori SKU', '${products.category?.name}'),
                      if (products.name != null) infoDetailSku(products.productCategoryId != null ? 'Kategori SKU' : 'SKU', '${products.name}'),
                      if (products.returnQuantity != null) infoDetailSku('Jumlah Ekor', '${products.quantity! - products.returnQuantity!} Ekor'),
                      if (products.cutType != null && Constant.havePotongan(products.category?.name)) infoDetailSku('Jenis Potong', Constant.getTypePotongan(products.cutType!)),
                      if (products.numberOfCuts != null && products.cutType == 'REGULAR' && Constant.havePotongan(products.category?.name)) infoDetailSku('Potongan', '${products.numberOfCuts} Potong'),
                      if (products.returnWeight != null) infoDetailSku('Kebutuhan', '${products.weight! - products.returnWeight!} Kg'),
                      if (products.price != null) infoDetailSku('Harga', "${Convert.toCurrency("${products.price}", "Rp. ", ".")}/Kg"),
                    ],
                  )),
            );
          } else {
            return const SizedBox();
          }
        }
      }
    }

    Widget bottomNvabar() {
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
                    controller.order.status == EnumSO.readyToDeliver
                        ? Expanded(
                            child: ButtonFill(
                                controller: GetXCreator.putButtonFillController('ReadyToDeliveryDeliverySO'),
                                label: 'Kirim Barang',
                                onClick: () {
                                  if (controller.order.status == EnumSO.readyToDeliver && controller.isSendItem.isFalse) {
                                    controller.isSendItem.value = true;
                                    final ButtonFillController btController = Get.find(tag: 'ReadyToDeliveryDeliverySO');
                                    btController.changeLabel('Konfirmasi');
                                  } else if (controller.isSendItem.isTrue) {
                                    _showBottomDialogSend(context, controller);
                                  }
                                }),
                          )
                        : controller.order.status == EnumSO.onDelivery
                            ? Expanded(
                                child: controller.confirmButton,
                              )
                            : const SizedBox(),
                    if (controller.order.status == EnumSO.onDelivery) ...[
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ButtonOutline(
                          controller: GetXCreator.putButtonOutlineController('tolakPenjualan'),
                          label: 'Ditolak',
                          onClick: () {
                            _showBottomDialogCancel(context, controller);
                          },
                        ),
                      )
                    ] else if (controller.order.status == 'REJECTED' && controller.order.returnStatus == 'PARTIAL') ...[
                      Expanded(
                        child: controller.confirmButton,
                      )
                    ] else
                      const SizedBox(),
                  ],
                ),
              ),
            ],
          ));
    }

    Widget totalPenjualan() {
      return Container(
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
            ],
            if (controller.order.deliveryFee! > 0) ...[
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Biaya Pengiriman',
                      style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(controller.order.deliveryFee),
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
                ],
              )
            ],
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Rp',
                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                    overflow: TextOverflow.clip,
                  ),
                ),
                Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(Convert.roundPrice(controller.sumPrice.value + (controller.order.deliveryFee ?? 0))),
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
              ],
            )
          ],
        ),
      );
    }

    Widget payment() {
      return Container(
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
                    'Pembayaran',
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
                    'Metode Pemabyaran',
                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                    overflow: TextOverflow.clip,
                  ),
                ),
                Text(
                  controller.order.paymentMethod == 'CASH' ? 'Tunai' : 'Transfer',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Nominal Uang',
                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                    overflow: TextOverflow.clip,
                  ),
                ),
                Text(
                  controller.order.paymentAmount != null ? Convert.toCurrency('${controller.order.paymentAmount}', 'Rp. ', '.') : '${controller.order.paymentAmount}',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                  overflow: TextOverflow.clip,
                )
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
            title: 'Detail Pengiriman',
            onBack: () {
              Navigator.pop(context);
            }),
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
                        detailInformation(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Detail SKU',
                          style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.bold),
                        ),
                        Column(
                          children: controller.order.products!.map((e) => customExpandalbe(e!)).toList(),
                        ),
                        if (controller.order.type! == 'LB') ...[
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Detail Catatan',
                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                            overflow: TextOverflow.clip,
                          ),
                          Column(
                            children: controller.order.productNotes!.map((e) => customExpandalbe(e!)).toList(),
                          ),
                        ],
                        totalPenjualan(),
                        if (controller.isSendItem.isTrue) controller.efRemark,
                        (controller.order.status == 'DELIVERED' || controller.order.status == 'RECEIVED') && controller.order.paymentMethod != null ? payment() : const SizedBox(),
                        if (controller.order.remarks != null) ...[
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
                                  'Catatan Penjualan',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  controller.order.remarks != null ? Uri.decodeFull(controller.order.remarks!) : '-',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ],
                        if (controller.order.driverRemarks != null) ...[
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
                                  'Catatan Pengiriman',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  controller.order.driverRemarks != null ? Uri.decodeFull(controller.order.driverRemarks!) : '-',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 140,
                        )
                      ],
                    ),
                  ),
                ),
                controller.order.status == 'READY_TO_DELIVER' || controller.order.status == 'ON_DELIVERY' || (controller.order.status == 'REJECTED' && controller.order.returnStatus == 'PARTIAL') ? bottomNvabar() : const SizedBox()
              ],
            )),
    );
  }

  Future<void> _showBottomDialogCancel(BuildContext context, DeliveryDetailSOController controller) {
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
                    'Apakah yakin kamu ingin melakukan penolakan?',
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text('Pastikan barang sudah sesuai dan benar sebelum melakukan penolakan', style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    'images/cancel_icon.svg',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.yesRejectItem),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noRejectItem),
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

  Future<void> _showBottomDialogSend(BuildContext context, DeliveryDetailSOController controller) {
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
                    'Apakah kamu yakin akan mengirim barang ini?',
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text('Pastikan barang yang akan kamu kirim sudah sesuai dan benar', style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    'images/image_logistic.svg',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.yesSendItem),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noSendItem),
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
