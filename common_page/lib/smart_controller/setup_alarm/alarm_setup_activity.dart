import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

import 'alarm_setup_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

class AlarmSetupActivity extends GetView<AlarmSetupController> {
  const AlarmSetupActivity({super.key});

  @override
  Widget build(BuildContext context) {
    AlarmSetupController controller = Get.put(AlarmSetupController(context: context));

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
                          ? ButtonFill(
                              controller: GetXCreator.putButtonFillController("bfSaveSmartAlarm"),
                              label: "Simpan",
                              onClick: () => controller.showBottomDialog(context),
                            )
                          : ButtonFill(
                              controller: GetXCreator.putButtonFillController("bfEditSmartAlarm"),
                              label: "Edit",
                              onClick: () {
                                controller.isEdit.value = true;
                                controller.loadData(controller.controllerData);
                              },
                            )))
                ]))
          ]));
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBarFormForCoop(
                title: 'Alarm',
                coop: Coop(),
                hideCoopDetail: true,
              ),
            ),
            body: Stack(children: [
              Obx(() => controller.isLoading.isTrue
                  ? const Center(child: ProgressLoading())
                  : SingleChildScrollView(
                      child: Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [controller.efDiffHotTemp, controller.efDiffColdTemp, const SizedBox(height: 120)])))),
              bottomNavBar()
            ])));
  }
}
