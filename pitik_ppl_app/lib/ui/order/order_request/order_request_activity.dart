

import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/multiple_form_field/multiple_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/product_model.dart';
import 'package:pitik_ppl_app/ui/order/order_request/order_request_controller.dart';
import 'package:components/global_var.dart';

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
                body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                            return MultipleFormField<Product>(
                                controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleFeed"),
                                childAdded: () => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Flexible(child: Text(controller.getFeedProductName(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                                        const SizedBox(width: 16),
                                        Text(controller.getFeedQuantity(null), style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                                    ],
                                ),
                                increaseWhenDuplicate: (product) {
                                    return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Flexible(child: Text(controller.getFeedProductName(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                                            const SizedBox(width: 16),
                                            Text(controller.getFeedQuantity(product), style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                                        ],
                                    );
                                },
                                labelButtonAdd: 'Tambah Pakan',
                                initInstance: Product(),
                                selectedObject: () => controller.getSelectedObject(),
                                selectedObjectWhenIncreased: (product) => controller.getSelectedObjectWhenIncreased(product),
                                keyData: () => controller.getFeedProductName(),
                                child: Column(
                                    children: [
                                        controller.feedCategory,
                                        controller.feedSuggestField,
                                        controller.feedQuantityField
                                    ]
                                )
                            );
                        },
                    )
                )
            )
        );
    }
}