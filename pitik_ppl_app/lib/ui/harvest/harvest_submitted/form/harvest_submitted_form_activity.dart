import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/harvest/harvest_submitted/form/harvest_submitted_form_controller.dart';

class HarvestSubmittedFormActivity extends GetView<HarvestSubmittedFormController> {
    const HarvestSubmittedFormActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(105),
                    child: AppBarFormForCoop(
                        title: 'Pengajuan Panen',
                        coop: controller.coop,
                    ),
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSubmitHarvestSubmitted"), label: "Ajukan", onClick: () => controller.sendHarvestSubmitted()),
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
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Perkiraan Populasi', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                        const SizedBox(width: 16),
                                        Text(controller.populationPrediction.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                )
                            ),
                            controller.submittedDateField,
                            const SizedBox(height: 12),
                            controller.submissionField
                        ]
                    )
                )
            )
        );
    }
}