
import 'package:common_page/smart_controller/monitoring/smart_monitor_controller.dart';
import 'package:common_page/smart_monitor/detail_smartmonitor_activity.dart';
import 'package:common_page/smart_monitor/detail_smartmonitor_controller.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 03/11/2023

class SmartMonitorControllerActivity extends GetView<SmartMonitorController> {
    const SmartMonitorControllerActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Scaffold(
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: AppBarFormForCoop(
                        title: 'Smart Monitor',
                        coop: controller.coop,
                        hideCoopDetail: true,
                    ),
                ),
                backgroundColor: Colors.white,
                body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DetailSmartMonitor(
                        controller: Get.put(DetailSmartMonitorController(
                            tag: "smartMonitorForController",
                            context: Get.context!,
                            coop: controller.coop,
                            useBundleLatestCondition: true,
                            bundleLatestCondition: controller.deviceSummary
                        ), tag: "smartMonitorForController"),
                        deviceIdForController: controller.deviceIdForController,
                        coopIdForController: controller.coopIdForController,
                        hideBuildings: true,
                        hideHeatStress: true,
                        hideAmmonia: true,
                        hideWind: true,
                        hideLight: true,
                        widgetLoading: Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Column(
                                children: [
                                    Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                                    const SizedBox(height: 24),
                                    Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                                    const SizedBox(height: 24),
                                    Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                                ]
                            )
                        )
                    )
                )
            )
        );
    }
}