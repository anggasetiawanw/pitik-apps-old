import 'package:common_page/smart_controller/setup_reset/reset_time_controller.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

class ResetTimeActivity extends GetView<ResetTimeController> {
  const ResetTimeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    ResetTimeController controller = Get.put(ResetTimeController(context: context));

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
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Obx(() => controller.isEdit.isTrue ? controller.bfSaveResetTime : controller.bfEditResetTime))]))
          ]));
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBarFormForCoop(
                title: 'Reset Waktu',
                coop: Coop(),
                hideCoopDetail: true,
              ),
            ),
            body: Stack(children: [
              Obx(() => controller.isLoading.isTrue
                  ? const Center(
                      child: ProgressLoading(),
                    )
                  : SingleChildScrollView(
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: GlobalVar.blueLights, borderRadius: BorderRadius.circular(8)),
                                child: Row(children: [
                                  SvgPicture.asset("images/information_blue_icon.svg"),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Expanded(
                                      child: Text(
                                    "Saat ini menggunakan waktu bawaan ",
                                    style: TextStyle(color: GlobalVar.black, fontSize: 14),
                                    overflow: TextOverflow.clip,
                                  )),
                                  Text("${controller.controllerData.onlineTime}", style: const TextStyle(color: GlobalVar.black, fontSize: 14), overflow: TextOverflow.clip)
                                ])),
                            controller.dtfLampReset,
                            const SizedBox(height: 120)
                          ])))),
              bottomNavBar()
            ])));
  }
}
