import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant.dart';
import '../../../widget/common/order_status.dart';
import 'create_receive_sales_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23

class CreateGrOrder extends StatelessWidget {
  const CreateGrOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateGrOrderController controller = Get.put(CreateGrOrderController(context: context));
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
          'Form Penerimaan',
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Future<void> showBottomDialogSend(BuildContext context, CreateGrOrderController controller) {
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
                        Expanded(child: controller.yesSendButton),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(child: controller.noSendButton),
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
              padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ButtonFill(
                          controller: GetXCreator.putButtonFillController('saveGrPo'),
                          label: 'Simpan',
                          onClick: () {
                            controller.isValid() ? showBottomDialogSend(context, controller) : null;
                          })),
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
                      'Informasi Pengembalian',
                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${controller.orderDetail.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}',
                      style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                    )
                  ],
                )),
                OrderStatus(orderStatus: controller.orderDetail.status, returnStatus: controller.orderDetail.returnStatus, grStatus: controller.orderDetail.grStatus),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader('Sumber', "${controller.orderDetail.operationUnit != null ? controller.orderDetail.operationUnit!.operationUnitName : ""}"),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Tujuan', '${controller.orderDetail.customer!.businessName}'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Dibuat Oleh', controller.orderDetail.userCreator?.email ?? '-'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Sales Branch', controller.orderDetail.salesperson == null ? '-' : '${controller.orderDetail.salesperson?.branch?.name}'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Driver', "${controller.orderDetail.driver == null ? "-" : controller.orderDetail.driver!.fullName}"),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Target Pengiriman', controller.orderDetail.deliveryTime != null ? DateFormat('dd MMM yyyy').format(Convert.getDatetime(controller.orderDetail.deliveryTime!)) : '-'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader(
              'Waktu Pengiriman',
              controller.orderDetail.deliveryTime != null
                  ? DateFormat('HH:mm').format(Convert.getDatetime(controller.orderDetail.deliveryTime!)) != '00:00'
                      ? DateFormat('HH:mm').format(Convert.getDatetime(controller.orderDetail.deliveryTime!))
                      : '-'
                  : '-',
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
        body: Obx(
          () => controller.isLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
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
                            detailInformation(),
                            if (controller.orderDetail.products!.isNotEmpty) ...[
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'Detail SKU Pengembalian',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              controller.skuCardGr,
                              const SizedBox(
                                height: 120,
                              )
                            ] else
                              const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    bottomNavbar(),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
        ));
  }
}
