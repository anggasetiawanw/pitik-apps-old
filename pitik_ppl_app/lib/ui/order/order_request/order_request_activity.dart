import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/order/order_request/order_request_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class OrderRequestActivity extends GetView<OrderRequestController> {
    const OrderRequestActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(95),
                    child: AppBarFormForCoop(
                        title: 'Order',
                        coop: controller.coop,
                    ),
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSubmitOrder"), label: "Simpan", onClick: () => controller.sendOrder()),
                ),
                body: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : ListView(
                        children: [
                            controller.orderDateField,
                            controller.orderTypeField,
                            controller.isFeed.isTrue ?
                            Column(
                                children: [
                                    controller.orderMultipleLogisticField,
                                    controller.isMerge.isTrue ? controller.orderCoopTargetLogisticField : const SizedBox(),
                                    const SizedBox(height: 16),
                                    controller.feedMultipleFormField
                                ],
                            ): controller.coop.isOwnFarm != null && controller.coop.isOwnFarm! ?
                            Column(
                                children: [
                                    const SizedBox(height: 32),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            GestureDetector(
                                                onTap: () => controller.isVendor.value = true,
                                                child: Container(
                                                    width: (MediaQuery.of(context).size.width / 2) - 16,
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)),
                                                        color: controller.isVendor.isTrue ? GlobalVar.primaryLight2 : GlobalVar.primaryLight
                                                    ),
                                                    child: Column(
                                                        children: [
                                                            Container(
                                                                padding: const EdgeInsets.only(top: 12, bottom: 12),
                                                                child: Text(
                                                                    'Vendor',
                                                                    style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.isVendor.isTrue ? GlobalVar.primaryOrange : GlobalVar.grayLightText)
                                                                )
                                                            ),
                                                            Container(height: 3, color: controller.isVendor.isTrue ? GlobalVar.primaryOrange : Colors.transparent)
                                                        ],
                                                    ),
                                                ),
                                            ),
                                            GestureDetector(
                                                onTap: () => controller.isVendor.value = false,
                                                child: Container(
                                                    width: (MediaQuery.of(context).size.width / 2) - 16,
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
                                                        color: controller.isVendor.isFalse ? GlobalVar.primaryLight2 : GlobalVar.primaryLight
                                                    ),
                                                    child: Column(
                                                        children: [
                                                            Container(
                                                                padding: const EdgeInsets.only(top: 12, bottom: 12),
                                                                child: Text(
                                                                    'Unit',
                                                                    style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.isVendor.isFalse ? GlobalVar.primaryOrange : GlobalVar.grayLightText)
                                                                )
                                                            ),
                                                            Container(height: 3, color: controller.isVendor.isFalse ? GlobalVar.primaryOrange : Colors.transparent)
                                                        ],
                                                    ),
                                                ),
                                            )
                                        ],
                                    ),
                                    controller.isVendor.isTrue ? controller.ovkVendorMultipleFormField : controller.ovkUnitMultipleFormField
                                ],
                            ) :
                            Column(
                                children: [
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