

import 'package:common_page/library/component_library.dart';
import 'package:components/app_bar_form_for_coop.dart';
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
        return SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(110),
                    child: AppBarFormForCoop(
                        title: 'Order',
                        coop: controller.coop,
                    ),
                ),
                bottomNavigationBar: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSubmitOrder"), label: "Simpan", onClick: () {

                    }),
                ),
                body: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Obx(() =>
                        ListView(
                            children: [
                                controller.orderDateField,
                                controller.orderTypeField,
                                controller.isFeed.isTrue ?
                                Column(
                                    children: [
                                        controller.orderMultipleLogisticField,
                                        const SizedBox(height: 16),
                                        controller.feedMultipleFormField
                                    ],
                                ):
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
            )
        );
    }
}