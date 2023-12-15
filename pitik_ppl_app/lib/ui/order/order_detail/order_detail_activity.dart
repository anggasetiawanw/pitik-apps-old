
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/order/order_detail/order_detail_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class OrderDetailActivity extends GetView<OrderDetailController> {
    const OrderDetailActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(105),
                    child: AppBarFormForCoop(
                        title: 'Order ${controller.procurement.value.type == null ? '-' :  controller.procurement.value.type == 'pakan' ? 'Pakan' : 'OVK'}',
                        coop: controller.coop
                    ),
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : controller.containerButtonEditAndCancel.value,
                body: Container(
                    padding: const EdgeInsets.all(16),
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
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Detail Order', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                                controller.getStatus()
                                            ]
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Tanggal Order', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                controller.getOrderDate()
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Jenis Order', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(
                                                    controller.procurement.value.type == null ? '-' : controller.procurement.value.type == 'pakan' ? 'Pakan' : 'OVK',
                                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                )
                                            ]
                                        ),
                                        controller.procurement.value.type != null && controller.procurement.value.type == 'pakan' ?
                                        Column(
                                            children: [
                                                const SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text('Digabung?', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                        Text(
                                                            controller.procurement.value.mergedLogistic == null ? '-' : controller.procurement.value.mergedLogistic! ? 'Ya' : 'Tidak',
                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                        )
                                                    ]
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text('Nama Kandang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                        Text(
                                                            controller.procurement.value.mergedLogisticCoopName == null ? '-' : controller.procurement.value.mergedLogisticCoopName!,
                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                        )
                                                    ]
                                                )
                                            ],
                                        )
                                            : controller.isOwnFarm() ?
                                        Column(
                                            children: [
                                                const SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text('Asal Sumber', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                        Text(
                                                            controller.procurement.value.details.isNotEmpty && controller.procurement.value.internalOvkTransferRequest != null ? 'Vendor & Unit' :
                                                            controller.procurement.value.details.isNotEmpty && controller.procurement.value.internalOvkTransferRequest == null ? 'Vendor' :
                                                            controller.procurement.value.details.isEmpty && controller.procurement.value.internalOvkTransferRequest != null ? 'Unit' :
                                                            '-',
                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                        )
                                                    ]
                                                ),
                                            ],
                                        ) : const SizedBox()
                                    ]
                                )
                            ),
                            const SizedBox(height: 16),
                            controller.procurement.value.details.isNotEmpty ?
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        controller.procurement.value.type == null ? '-' : controller.procurement.value.type == 'pakan' ? 'Detail Pakan' : controller.isOwnFarm() ? 'Total OVK Vendor' : 'Detail OVK',
                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                    ),
                                    const SizedBox(height: 12),
                                    controller.generateProductCards(productList: controller.procurement.value.details, isFeed: controller.procurement.value.type == 'pakan')
                                ],
                            ) : const SizedBox(),
                            controller.procurement.value.internalOvkTransferRequest != null ?
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        'Total OVK Unit',
                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                    ),
                                    const SizedBox(height: 12),
                                    controller.generateProductCards(productList: controller.procurement.value.internalOvkTransferRequest!.details)
                                ],
                            ) : const SizedBox(),
                            controller.isCancel.isTrue ? controller.rejectReasonAreaField : const SizedBox()
                        ]
                    )
                )
            )
        );
    }
}