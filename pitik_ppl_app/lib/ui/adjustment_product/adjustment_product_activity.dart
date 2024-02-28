import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'adjustment_product_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 12/12/2023

class AdjustmentProductActivity extends GetView<AdjustmentProductController> {
  const AdjustmentProductActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(preferredSize: const Size.fromHeight(135), child: AppBarFormForCoop(title: 'Penyesuaian Pakan', coop: controller.coop)),
        bottomNavigationBar: controller.isLoading.isTrue
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]),
                child: ButtonFill(controller: GetXCreator.putButtonFillController('btnAdjustmentProductSave'), label: 'Simpan', onClick: () => controller.saveAdjustment()),
              ),
        body: controller.isLoading.isTrue
            ? const Center(child: ProgressLoading())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(children: [const SizedBox(height: 12), controller.adjustmentTypeField, const SizedBox(height: 12), controller.isFeed ? controller.feedMultipleFormField : controller.ovkMultipleFormField]))));
  }
}
