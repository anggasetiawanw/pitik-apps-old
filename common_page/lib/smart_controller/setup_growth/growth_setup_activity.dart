import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

import 'growth_setup_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

class GrowthSetupActivity extends GetView<GrowthSetupController> {
  const GrowthSetupActivity({super.key});

  @override
  Widget build(BuildContext context) {
    GrowthSetupController controller = Get.put(GrowthSetupController(context: context));

    Widget customExpandable(String device) {
      return Container(margin: const EdgeInsets.only(top: 16), child: controller.expandable);
    }

    Widget bottomNavBar() {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      child: Obx(() => controller.isEdit.isTrue
                          ? ButtonFill(controller: GetXCreator.putButtonFillController("bfSaveGrowthDay"), label: "Simpan", onClick: () => controller.showBottomDialog(context))
                          : ButtonFill(
                              controller: GetXCreator.putButtonFillController("bfEditGrowthDay"),
                              label: "Edit",
                              onClick: () {
                                controller.isEdit.value = true;
                                controller.getDetailGrowthDay();
                              })))
                ]))
          ]));
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBarFormForCoop(
              title: 'Masa Tumbuh',
              coop: Coop(),
              hideCoopDetail: true,
            ),
          ),
          body: Stack(children: [
            Obx(() => controller.isLoading.isTrue
                ? const Center(child: ProgressLoading())
                : SingleChildScrollView(
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [controller.efTargetTemp, controller.efAge, controller.efTempDayFirst, customExpandable("device"), const SizedBox(height: 120)])))),
            bottomNavBar()
          ])),
    );
  }
}
