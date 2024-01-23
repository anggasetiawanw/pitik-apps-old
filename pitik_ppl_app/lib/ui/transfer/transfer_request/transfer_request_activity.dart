import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_request/transfer_request_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class TransferRequestActivity extends GetView<TransferRequestController> {
    const TransferRequestActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: AppBarFormForCoop(
                        title: 'Transfer',
                        coop: controller.coop,
                    ),
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSubmitTransfer"), label: "Kirim", onClick: () => controller.sendTransfer()),
                ),
                body: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : ListView(
                        children: [
                            Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                    color: GlobalVar.grayBackground,
                                    border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text('Perkiraan Stok', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Daftar Stok', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                                GestureDetector(
                                                    onTap: () => controller.showStockSummary(),
                                                    child: SvgPicture.asset('images/information_blue_icon.svg'),
                                                )
                                            ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Pre-Starter', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(controller.prestarterStockSummary.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                            ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Starter', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(controller.starterStockSummary.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                            ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Finisher', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(controller.finisherStockSummary.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                            ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('OVK', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(controller.ovkStockSummary.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                            ],
                                        )
                                    ],
                                ),
                            ),
                            controller.transferDateField,
                            controller.transferTypeField,
                            controller.transferMethodField,
                            controller.isLoadingPicture.isTrue ? SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 32,
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            const CircularProgressIndicator(color: GlobalVar.primaryOrange),
                                            const SizedBox(width: 16),
                                            Text('Upload foto Sapronak...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                        ],
                                    ),
                                )
                            ) : controller.transferPhotoField,
                            controller.isFeed.isTrue ?
                            Column(
                                children: [
                                    controller.transferCoopTargetField,
                                    const SizedBox(height: 16),
                                    controller.feedMultipleFormField
                                ]
                            ) :
                            Column(
                                children: [
                                    controller.transferPurposeField,
                                    controller.isPurposeCoop.isTrue ? controller.transferCoopTargetField : const SizedBox(),
                                    const SizedBox(height: 16),
                                    controller.ovkMultipleFormField
                                ],
                            )
                        ],
                    )
                )
            )
        );
    }
}