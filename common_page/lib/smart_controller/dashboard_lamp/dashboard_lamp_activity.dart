import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

import 'dashboard_lamp_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 02/11/2023

class DashboardLamp extends StatelessWidget {
  const DashboardLamp({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardLampController controller = Get.put(DashboardLampController(context: context));
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: AppBarFormForCoop(title: 'Lampu', coop: Coop(), hideCoopDetail: true)),
            body: Stack(children: [
              Obx(() => controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 10), controller.createLampList()]))
            ])));
  }
}
