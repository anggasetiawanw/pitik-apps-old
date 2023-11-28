
import 'package:common_page/transaction_success_activity.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/harvest/harvest_realization/form/harvest_realization_form_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 23/11/2023

class HarvestRealizationFormActivity extends GetView<HarvestRealizationFormController> {
    const HarvestRealizationFormActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Obx(() =>
                Scaffold(
                    backgroundColor: Colors.white,
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(110),
                        child: AppBarFormForCoop(
                            title: 'Realisasi Panen',
                            coop: controller.bundle.getCoop,
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
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(
                                            child: ButtonFill(controller: GetXCreator.putButtonFillController("btnHarvestRealizationSubmit"), label: "Simpan", onClick: () => controller.saveOrUpdateHarvestRealization()),
                                        )
                                    ]
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Informasi Deal Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                            const SizedBox(height: 12),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('No. DO', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    Text(controller.getDeliveryOrder(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                ]
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Bakul', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    Text(controller.getBakulName(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
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
                                            )
                                        ]
                                    )
                                ),
                                const SizedBox(height: 16),
                                controller.harvestDateField,
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: controller.harvestHourField),
                                        const SizedBox(width: 8),
                                        Expanded(child: controller.ongoingHourField)
                                    ]
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: controller.driverNameField),
                                        const SizedBox(width: 8),
                                        Expanded(child: controller.truckPlateField)
                                    ]
                                ),
                                Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.white,
                                        border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                    ),
                                    child: Column(
                                        children: [
                                            Container(
                                                padding: const EdgeInsets.all(16),
                                                width: MediaQuery.of(context).size.width - 32,
                                                decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                                                    color: GlobalVar.headerSku
                                                ),
                                                child: Text('Kartu Timbang', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: Column(
                                                    children: [
                                                        controller.weighingNumberField,
                                                        controller.totalChickenField,
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Expanded(child: controller.tonnageField),
                                                                const SizedBox(width: 8),
                                                                Expanded(child: controller.averageWeightField)
                                                            ]
                                                        ),
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
                                                                        Text('Upload data timbang...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                                                    ],
                                                                ),
                                                            )
                                                        ) : controller.weightMediaField,
                                                    ]
                                                )
                                            )
                                        ]
                                    )
                                )
                            ]
                        )
                    )
                )
            )
        );
    }
}