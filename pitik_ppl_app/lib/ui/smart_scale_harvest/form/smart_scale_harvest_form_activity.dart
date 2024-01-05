
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/smart_scale_harvest/form/smart_scale_harvest_form_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 29/12/2023

class SmartScaleHarvestFormActivity extends GetView<SmartScaleHarvestFormController> {
    const SmartScaleHarvestFormActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: AppBarFormForCoop(
                        title: 'Timbang Panen',
                        coop: controller.coop,
                    ),
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : SizedBox(
                    child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                        ),
                        child: SizedBox(
                            width: MediaQuery.of(Get.context!).size.width - 32,
                            child: ButtonFill(
                                controller: GetXCreator.putButtonFillController("btnSmartScaleHarvestStartWeighing"),
                                label: controller.harvest.weighingNumber != null ? 'Simpan' : 'Mulai Timbang',
                                onClick: () => controller.submit()
                            )
                        )
                    )
                ),
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
                                                Text('Detail Pengajuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                                controller.getSubmittedStatusWidget(statusText: controller.harvest.statusText ?? '')
                                            ]
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Tanggal Pengajuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(Convert.getDate(controller.harvest.datePlanned), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
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
                                                Text(controller.getQuantityText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Alasan Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(controller.harvest.reason ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Sisa Ayam', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(controller.getQuantityLeftOverText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        )
                                    ]
                                )
                            ),
                            const SizedBox(height: 16),
                            controller.efWeighingNumber,
                            controller.dtfHarvestedDate,
                            controller.efCoopName,
                            controller.efAddress,
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Expanded(child: controller.dtfHarvestedTime),
                                    const SizedBox(width: 8),
                                    Expanded(child: controller.dtfOngoingTime)
                                ]
                            ),
                            controller.efBakulName,
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Expanded(child: controller.efDriverName),
                                    const SizedBox(width: 8),
                                    Expanded(child: controller.efPlateNumber)
                                ]
                            ),
                            const SizedBox(height: 16),
                            Text('Saksi Timbang', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                            controller.efWitnessName,
                            controller.efReceiverName,
                            controller.efWeighersName
                        ]
                    )
                )
            )
        );
    }
}