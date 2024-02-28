import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../route.dart';
import '../../harvest/harvest_common.dart';
import 'smart_scale_harvest_list_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 28/12/2023

class SmartScaleHarvestListActivity extends GetView<SmartScaleHarvestListController> {
  const SmartScaleHarvestListActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBarFormForCoop(
            title: 'Smart Scale',
            coop: controller.coop,
          ),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TabBar(
                controller: controller.tabController,
                dividerColor: Colors.white,
                indicatorColor: GlobalVar.primaryOrange,
                labelColor: GlobalVar.primaryOrange,
                unselectedLabelColor: GlobalVar.gray,
                labelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                unselectedLabelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                tabs: const [Tab(text: 'Pengajuan'), Tab(text: 'Hasil')]),
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
                          onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.getHarvestSubmitted()),
                          child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.harvestList.length,
                              itemBuilder: (context, index) => HarvestCommon.createSubmittedHarvestCard(
                                  index: index,
                                  coop: controller.coop,
                                  harvest: controller.harvestList[index],
                                  onRefreshData: () => controller.refreshHarvestList(),
                                  onNavigate: () => Get.toNamed(RoutePage.smartScaleHarvestForm, arguments: [controller.coop, controller.harvestList[index]])!.then((value) => controller.refreshHarvestList()))))),
                  RawScrollbar(
                      thumbColor: GlobalVar.primaryOrange,
                      radius: const Radius.circular(8),
                      child: RefreshIndicator(
                          onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.getHarvestResult()),
                          child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.realizationList.length,
                              itemBuilder: (context, index) => HarvestCommon.createRealizationHarvestCard(
                                  coop: controller.coop,
                                  realization: controller.realizationList[index],
                                  onRefreshData: () => controller.refreshHarvestList(),
                                  onNavigate: () => Get.toNamed(RoutePage.smartScaleHarvestDetail, arguments: [controller.coop, controller.realizationList[index]])!.then((value) => controller.refreshHarvestList())))))
                ]))
        ])));
  }
}
