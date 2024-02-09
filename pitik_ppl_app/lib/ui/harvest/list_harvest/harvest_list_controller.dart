
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/harvest_model.dart';
import 'package:model/realization_model.dart';
import 'package:pitik_ppl_app/ui/harvest/harvest_common.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 16/11/2023

class HarvestListController extends GetxController with GetSingleTickerProviderStateMixin {
    BuildContext context;
    HarvestListController({required this.context});

    late TabController tabController;
    late Coop coop;

    var isLoading = false.obs;
    RxList<Harvest?> harvestList = <Harvest?>[].obs;
    RxList<Realization?> realizationList = <Realization?>[].obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];

        tabController = TabController(vsync: this, length: 3);
        tabController.addListener(() {
            if (tabController.index == 0) {
                HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList);
                GlobalVar.track('Open_panen_page_pengajuan');
            } else if (tabController.index == 1) {
                HarvestCommon.getDealList(isLoading: isLoading, coop: coop, harvestList: harvestList);
                GlobalVar.track('Open_panen_page_deal');
            } else {
                HarvestCommon.getRealizationList(isLoading: isLoading, coop: coop, realizationList: realizationList);
                GlobalVar.track('Open_panen_page_realisasi');
            }
        });

        HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList);
    }

    void refreshHarvestList() {
        if (tabController.index == 0) {
            HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList);
        } else if (tabController.index == 1) {
            HarvestCommon.getDealList(isLoading: isLoading, coop: coop, harvestList: harvestList);
        } else {
            HarvestCommon.getRealizationList(isLoading: isLoading, coop: coop, realizationList: realizationList);
        }
    }
}

class HarvestListBinding extends Bindings {
    BuildContext context;
    HarvestListBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<HarvestListController>(() => HarvestListController(context: context));
}