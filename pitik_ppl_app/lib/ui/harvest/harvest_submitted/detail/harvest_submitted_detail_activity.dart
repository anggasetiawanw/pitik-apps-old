
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/harvest/harvest_submitted/detail/harvest_submitted_detail_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 17/11/2023

class HarvestSubmittedDetailActivity extends GetView<HarvestSubmittedDetailController> {
    const HarvestSubmittedDetailActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: AppBarFormForCoop(
                        title: 'Pengajuan Panen',
                        coop: controller.coop,
                    ),
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : controller.containerButtonBottom.value,
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
                                                Text('Informasi Pengajuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                                controller.getStatusWidget()
                                            ]
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Tanggal Pengajuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(Convert.getDate( controller.harvest.value?.datePlanned ), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        )
                                    ]
                                )
                            ),
                            const SizedBox(height: 16),
                            Text('Pengajuan Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                            const SizedBox(height: 8),
                            Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(controller.getBwText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Jumlah Ayam', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(
                                                    controller.getQuantityText(),
                                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                )
                                            ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Alasan Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(controller.harvest.value == null ? '-' : controller.harvest.value!.reason ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        )
                                    ],
                                ),
                            ),
                            controller.isCancel.isTrue ? controller.rejectReasonAreaField : const SizedBox()
                        ]
                    )
                )
            )
        );
    }
}