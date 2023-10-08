
import 'package:common_page/history/harvest/harvest_activity.dart';
import 'package:common_page/history/harvest/harvest_controller.dart';
import 'package:common_page/history/performance/performance_controller.dart';
import 'package:common_page/history/sapronak/sapronak_activity.dart';
import 'package:common_page/history/sapronak/sapronak_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

import 'performance/performance_activity.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class HistoryController extends GetxController with GetSingleTickerProviderStateMixin {
    BuildContext context;
    Coop? coop;

    HistoryController({required this.context, this.coop});

    late TabController tabController;
    late PerformanceActivity performanceActivity;
    late SapronakActivity sapronakActivity;
    late HarvestActivity harvestActivity;

    @override
    void onInit() {
        super.onInit();

        Get.put(PerformanceController(context: Get.context!));
        Get.put(SapronakController(context: Get.context!));
        Get.put(HarvestController(context: Get.context!));

        performanceActivity = PerformanceActivity(coop: coop!);
        sapronakActivity = SapronakActivity(coop: coop!);
        harvestActivity = HarvestActivity(coop: coop!);

        tabController = TabController(vsync: this, length: 3);
        tabController.addListener(() {
            if (tabController.index == 0) {
                performanceActivity.controller.generateData();
            } else if (tabController.index == 1) {
                sapronakActivity.controller.generateData();
            } else {
                harvestActivity.controller.generateData();
            }
        });
    }

    void refreshData() {
        if (tabController.index == 0) {
            performanceActivity.controller.generateData();
        } else if (tabController.index == 1) {
            sapronakActivity.controller.generateData();
        } else {
            harvestActivity.controller.generateData();
        }
    }
}

class HistoryBinding extends Bindings {
    BuildContext context;
    HistoryBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<HistoryController>(() => HistoryController(context: context));
    }
}