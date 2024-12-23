import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../route.dart';
import '../harvest_common.dart';
import 'harvest_list_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 16/11/2023

class HarvestListActivity extends GetView<HarvestListController> {
  const HarvestListActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBarFormForCoop(
            title: 'Panen',
            coop: controller.coop,
          ),
        ),
        floatingActionButton: controller.tabController.index == 0
            ? Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: FloatingActionButton(
                  elevation: 12,
                  onPressed: () {
                    GlobalVar.track('Click_floating_button_add_panen');
                    Get.toNamed(RoutePage.harvestSubmittedForm, arguments: [controller.coop])!.then((value) => controller.refreshHarvestList());
                  },
                  backgroundColor: GlobalVar.primaryOrange,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            : const SizedBox(),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TabBar(
                controller: controller.tabController,
                indicatorColor: GlobalVar.primaryOrange,
                labelColor: GlobalVar.primaryOrange,
                unselectedLabelColor: GlobalVar.gray,
                labelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                unselectedLabelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                tabs: const [Tab(text: 'Pengajuan'), Tab(text: 'Deal'), Tab(text: 'Realisasi')]),
          ),
          const SizedBox(height: 8),
          controller.isLoading.isTrue
              ? Padding(padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - 80) / 3), child: const ProgressLoading())
              : Expanded(
                  child: TabBarView(controller: controller.tabController, children: [
                  RawScrollbar(
                      thumbColor: GlobalVar.primaryOrange,
                      radius: const Radius.circular(8),
                      child: RefreshIndicator(
                        onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => HarvestCommon.getSubmittedList(isLoading: controller.isLoading, coop: controller.coop, harvestList: controller.harvestList)),
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.harvestList.length,
                            itemBuilder: (context, index) => HarvestCommon.createSubmittedHarvestCard(index: index, coop: controller.coop, harvest: controller.harvestList[index], onRefreshData: () => controller.refreshHarvestList())),
                      )),
                  Column(children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: controller.efSearchDeal),
                    Expanded(
                        child: RawScrollbar(
                            thumbColor: GlobalVar.primaryOrange,
                            radius: const Radius.circular(8),
                            child: RefreshIndicator(
                                onRefresh: () => Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () => HarvestCommon.getDealList(
                                        isLoading: controller.isLoading,
                                        coop: controller.coop,
                                        harvestList: controller.harvestList,
                                        onCallBack: () => controller.clearAndAddListData(originalData: controller.harvestList, filteredData: controller.harvestFilteredList))),
                                child: ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.harvestFilteredList.length,
                                    itemBuilder: (context, index) => HarvestCommon.createDealHarvestCard(coop: controller.coop, harvest: controller.harvestList[index], onRefreshData: () => controller.refreshHarvestList())))))
                  ]),
                  Column(children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: controller.efSearchRealization),
                    Expanded(
                        child: RawScrollbar(
                            thumbColor: GlobalVar.primaryOrange,
                            radius: const Radius.circular(8),
                            child: RefreshIndicator(
                                onRefresh: () => Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () => HarvestCommon.getRealizationList(
                                        isLoading: controller.isLoading,
                                        coop: controller.coop,
                                        realizationList: controller.realizationList,
                                        onCallBack: () => controller.clearAndAddListData(originalData: controller.harvestList, filteredData: controller.harvestFilteredList))),
                                child: ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: controller.realizationFilteredList.length,
                                    itemBuilder: (context, index) => HarvestCommon.createRealizationHarvestCard(coop: controller.coop, realization: controller.realizationFilteredList[index], onRefreshData: () => controller.refreshHarvestList())))))
                  ])
                ]))
        ])));
  }
}
