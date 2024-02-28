import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant.dart';
import '../../../widget/common/loading.dart';
import '../../../widget/common/transfer_status.dart';
import 'create_receive_transfer_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 07/06/23

class CreateGrTransfer extends StatelessWidget {
  const CreateGrTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateGrTransferController controller = Get.put(CreateGrTransferController(context: context));
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
                          controller: GetXCreator.putButtonFillController('saveTransferReceive'),
                          label: 'Simpan',
                          onClick: () {
                            if (controller.isValid()) {
                              _showBottomDialogSend(context, controller);
                            }
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Transfer',
                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${controller.transferModel.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}',
                      style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                    )
                  ],
                ),
                TransferStatus(
                  transferStatus: controller.transferModel.status,
                  isGoodReceipts: true,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader('Sumber', '${controller.transferModel.sourceOperationUnit!.operationUnitName}'),
            const SizedBox(
              height: 8,
            ),
            infoDetailHeader('Tujuan', '${controller.transferModel.targetOperationUnit!.operationUnitName}'),
            // const SizedBox(height: 8,),
            // controller.transferModel.driver != null ? infoDetailHeader("Driver", "${controller.transferModel.driver!.fullName}")
            //     : const SizedBox(),
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
            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
          )
        ],
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
              ? const Center(child: ProgressLoading())
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detailInformation(),
                            if (controller.transferModel.products!.isNotEmpty) ...[
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'Detail SKU',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                decoration: const BoxDecoration(color: AppColors.headerSku, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                child: Text(
                                  '${controller.transferModel.products![0]!.name}',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
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
                                    infoDetailSKU('SKU', "${controller.transferModel.products![0]!.productItems![0] != null ? controller.transferModel.products![0]!.productItems![0]!.name : "null"}"),
                                    if (controller.transferModel.products![0]!.productItems![0]!.quantity != null && controller.transferModel.products![0]!.productItems![0]!.quantity != 0) ...[
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      infoDetailSKU('Jumlah Ekor', '${controller.transferModel.products![0]!.productItems![0]!.quantity} Ekor'),
                                    ],
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    controller.transferModel.products![0]!.productItems![0]!.weight != null ? infoDetailSKU('Total', '${controller.transferModel.products![0]!.productItems![0]!.weight!} Kg') : const SizedBox(),
                                    controller.efChickReceived,
                                    controller.efWeightReceived,
                                  ],
                                ),
                              ),
                            ] else
                              const SizedBox(),
                            MediaQuery.of(context).viewInsets.bottom > 0.0
                                ? const SizedBox(
                                    height: 120,
                                  )
                                : const SizedBox()
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

  Future<void> _showBottomDialogSend(BuildContext context, CreateGrTransferController controller) {
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
}
