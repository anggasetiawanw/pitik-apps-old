
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_detail/transfer_detail_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class TransferDetailActivity extends GetView<TransferDetailController> {
    const TransferDetailActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(95),
                    child: AppBarFormForCoop(
                        title: 'Transfer ${controller.procurement.value.type == null ? '-' :  controller.procurement.value.type == 'pakan' ? 'Pakan' : 'OVK'}',
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
                                                Text('Detail Transfer', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                                controller.getStatus()
                                            ]
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Tanggal Pengiriman', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                controller.getTransferDate()
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Jenis Transfer', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(
                                                    controller.procurement.value.type == null ? '-' : controller.procurement.value.type == 'pakan' ? 'Pakan' : 'OVK',
                                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                )
                                            ]
                                        ),
                                        controller.coop.isOwnFarm != null && controller.coop.isOwnFarm! ? Column(
                                            children: [
                                                const SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text('Tujuan Transfer', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                        controller.getPurposeTransfer()
                                                    ]
                                                )
                                            ],
                                        ) : const SizedBox(),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Kandang Tujuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                controller.getCoopTarget()
                                            ]
                                        )
                                    ]
                                )
                            ),
                            const SizedBox(height: 16),
                            controller.procurement.value.details.isNotEmpty ?
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        controller.procurement.value.type == null ? '-' : controller.procurement.value.type == 'pakan' ? 'Detail Pakan' : 'Detail OVK',
                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                    ),
                                    const SizedBox(height: 12),
                                    controller.generateProductCards(productList: controller.procurement.value.details, isFeed: controller.procurement.value.type == 'pakan')
                                ],
                            ) : const SizedBox(),
                            const SizedBox(height: 16),
                            Column(
                                children: List.generate(controller.procurement.value.photos.length, (index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: Image.network(
                                                controller.procurement.value.photos[index] != null ? controller.procurement.value.photos[index]!.url! : '',
                                                width: MediaQuery.of(context).size.width - 36,
                                                height: MediaQuery.of(context).size.width /2,
                                                fit: BoxFit.fill,
                                            ),
                                        ),
                                    );
                                }),
                            ),
                            controller.isCancel.isTrue ? controller.rejectReasonAreaField : const SizedBox()
                        ]
                    )
                )
            )
        );
    }
}