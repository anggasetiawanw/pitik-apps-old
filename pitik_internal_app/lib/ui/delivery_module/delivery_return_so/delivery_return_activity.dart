import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/constant.dart';
import '../../../widget/common/loading.dart';
import '../../../widget/common/order_status.dart';

import 'delivert_return_controller.dart';

class DeliveryRejectSO extends StatelessWidget {
  const DeliveryRejectSO({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryRejectSOController controller = Get.put(DeliveryRejectSOController(context: context));
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
          'Detail Pengiriman',
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
                Column(
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
                      '${controller.order.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}',
                      style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                    )
                  ],
                ),
                OrderStatus(orderStatus: controller.order.status, returnStatus: controller.order.returnStatus, grStatus: controller.order.grStatus)
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader('Sumber', '${controller.order.operationUnit!.operationUnitName}'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Tujuan', '${controller.order.customer!.businessName}'),
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

    Widget totalPembelian() {
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
                Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(controller.sumPrice.value), style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium), overflow: TextOverflow.clip),
              ],
            )
          ],
        ),
      );
    }

    Widget bottomNvabar() {
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
            child: ButtonFill(
                controller: GetXCreator.putButtonFillController('COnfirmeddd'),
                label: 'Konfirmasi',
                onClick: () {
                  _showBottomDialogSend(context, controller);
                }),
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
                        detailInformation(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Detail SKU',
                          style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        controller.skuReject,
                        totalPembelian(),
                        controller.remarkField,
                        const SizedBox(
                          height: 120,
                        )
                      ],
                    ),
                  ),
                ),
                bottomNvabar(),
              ],
            )),
    );
  }

  Future<void> _showBottomDialogSend(BuildContext context, DeliveryRejectSOController controller) {
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
                    child: Lottie.asset(
                      'images/yakin.json',
                      height: 140,
                      width: 130,
                      fit: BoxFit.cover,
                    )),
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
