
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    RxList<Harvest?> harvestFilteredList = <Harvest?>[].obs;
    RxList<Realization?> realizationList = <Realization?>[].obs;
    RxList<Realization?> realizationFilteredList = <Realization?>[].obs;

    late EditField efSearchDeal;
    late EditField efSearchRealization;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];

        efSearchDeal = EditField(
            controller: GetXCreator.putEditFieldController('harvestDealFilter'),
            label: '',
            hideLabel: true,
            hint: 'Cari nomor DO',
            alertText: '',
            textUnit: '',
            maxInput: 100,
            childPrefix: SvgPicture.asset('images/search_icon.svg', fit: BoxFit.scaleDown, width: 24, height: 24),
            onTyping: (text, field) {
                harvestFilteredList.clear();
                if (text.isEmpty) {
                    harvestFilteredList.addAll(harvestList);
                } else {
                    for (var element in harvestList) {
                        if (element!.deliveryOrder!.toLowerCase().contains(text.toLowerCase())) {
                            harvestFilteredList.add(element);
                        }
                    }
                }

                harvestFilteredList.refresh();
            }
        );

        efSearchRealization = EditField(
            controller: GetXCreator.putEditFieldController('harvestRealizationFilter'),
            label: '',
            hideLabel: true,
            hint: 'Cari nomor DO',
            alertText: '',
            textUnit: '',
            maxInput: 100,
            childPrefix: SvgPicture.asset('images/search_icon.svg', fit: BoxFit.scaleDown, width: 24, height: 24),
            onTyping: (text, field) {
                realizationFilteredList.clear();
                if (text.isEmpty) {
                    realizationFilteredList.addAll(realizationList);
                } else {
                    for (var element in realizationList) {
                        if (element!.deliveryOrder!.toLowerCase().contains(text.toLowerCase())) {
                            realizationFilteredList.add(element);
                        }
                    }
                }

                realizationFilteredList.refresh();
            }
        );

        tabController = TabController(vsync: this, length: 3);
        tabController.addListener(() {
            if (tabController.index == 0) {
                HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList);
                GlobalVar.track('Open_panen_page_pengajuan');
            } else if (tabController.index == 1) {
                HarvestCommon.getDealList(isLoading: isLoading, coop: coop, harvestList: harvestList, onCallBack: () => clearAndAddListData(originalData: harvestList, filteredData: harvestFilteredList));
                GlobalVar.track('Open_panen_page_deal');
            } else {
                HarvestCommon.getRealizationList(isLoading: isLoading, coop: coop, realizationList: realizationList, onCallBack: () => clearAndAddListData(originalData: realizationList, filteredData: realizationFilteredList));
                GlobalVar.track('Open_panen_page_realisasi');
            }
        });

        HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList);
    }

    void clearAndAddListData({required RxList originalData, required RxList filteredData}) {
        filteredData.clear();
        filteredData.addAll(originalData);
    }

    void refreshHarvestList() {
        if (tabController.index == 0) {
            HarvestCommon.getSubmittedList(isLoading: isLoading, coop: coop, harvestList: harvestList);
        } else if (tabController.index == 1) {
            HarvestCommon.getDealList(isLoading: isLoading, coop: coop, harvestList: harvestList, onCallBack: () => clearAndAddListData(originalData: harvestList, filteredData: harvestFilteredList));
        } else {
            HarvestCommon.getRealizationList(isLoading: isLoading, coop: coop, realizationList: realizationList, onCallBack: () => clearAndAddListData(originalData: realizationList, filteredData: realizationFilteredList));
        }
    }
}

class HarvestListBinding extends Bindings {
    BuildContext context;
    HarvestListBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<HarvestListController>(() => HarvestListController(context: context));
}