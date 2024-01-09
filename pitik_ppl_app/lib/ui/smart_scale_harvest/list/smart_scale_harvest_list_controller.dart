
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/harvest_model.dart';
import 'package:model/realization_model.dart';
import 'package:pitik_ppl_app/ui/harvest/harvest_common.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 28/12/2023

class SmartScaleHarvestListController extends GetxController with GetSingleTickerProviderStateMixin {
    BuildContext context;
    SmartScaleHarvestListController({required this.context});

    late Coop coop;
    late TabController tabController;

    var isLoading = false.obs;
    RxList<Harvest?> harvestList = <Harvest?>[].obs;
    RxList<Realization?> realizationList = <Realization?>[].obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];

        tabController = TabController(vsync: this, length: 2);
        tabController.addListener(() => refreshHarvestList());
        HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList, isApproved: true);
    }

    void getHarvestSubmitted() => HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList, isApproved: true);
    void getHarvestResult() => HarvestCommon.getRealizationList(isLoading: isLoading, coop: coop, realizationList: realizationList, isApproved: true);

    void refreshHarvestList() {
        if (tabController.index == 0) {
            HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList, isApproved: true);
        } else {
            HarvestCommon.getRealizationList(isLoading: isLoading, coop: coop, realizationList: realizationList, isApproved: true);
        }
    }
}

class SmartScaleHarvestBinding extends Bindings {
    BuildContext context;
    SmartScaleHarvestBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<SmartScaleHarvestListController>(() => SmartScaleHarvestListController(context: context));
}