
// ignore_for_file: must_be_immutable

import 'package:common_page/history/history_controller.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class HistoryActivity extends GetView<HistoryController> {
    Coop coop;
    HistoryActivity({super.key, required this.coop});

    @override
    Widget build(BuildContext context) {
        final HistoryController historyController = Get.put(HistoryController(
            context: context,
            coop: coop
        ));

        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                    children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Stack(
                                fit: StackFit.passthrough,
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(color: GlobalVar.outlineColor, width: 2.0),
                                            ),
                                        ),
                                    ),
                                    TabBar(
                                        controller: historyController.tabController,
                                        indicatorColor: GlobalVar.primaryOrange,
                                        labelColor: GlobalVar.primaryOrange,
                                        unselectedLabelColor: GlobalVar.gray,
                                        labelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                        unselectedLabelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                        tabs: const [
                                            Tab(text: "Performa"),
                                            Tab(text: "Sapronak"),
                                            Tab(text: "Panen")
                                        ]
                                    )
                                ]
                            ),
                        ),
                        Obx(() =>
                            Expanded(
                                child: TabBarView(
                                    controller: historyController.tabController,
                                    children: [
                                        RawScrollbar(
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            controller: controller.performanceScrollController,
                                            child: RefreshIndicator(
                                                onRefresh: () => Future.delayed(
                                                    const Duration(milliseconds: 200), () => historyController.performanceActivity.controller.generateData(coop)
                                                ),
                                                child: historyController.performanceActivity.controller.isLoading.isTrue ? Padding(
                                                    padding: const EdgeInsets.only(left: 16, top: 16),
                                                    child: Image.asset('images/card_height_450_lazy.gif'),
                                                ) :
                                                ListView.builder(
                                                    physics: const AlwaysScrollableScrollPhysics(),
                                                    itemCount: 1,
                                                    controller: controller.performanceScrollController,
                                                    itemBuilder: (context, index) => historyController.performanceActivity
                                                )
                                            )
                                        ),
                                        RawScrollbar(
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            controller: controller.sapronakScrollController,
                                            child: Padding(
                                                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                                                child: RefreshIndicator(
                                                    onRefresh: () => Future.delayed(
                                                        const Duration(milliseconds: 200), () => historyController.sapronakActivity.controller.generateData(coop)
                                                    ),
                                                    child: historyController.sapronakActivity.controller.isLoading.isTrue ? Image.asset('images/card_height_450_lazy.gif') :
                                                    ListView.builder(
                                                        physics: const AlwaysScrollableScrollPhysics(),
                                                        itemCount: 1,
                                                        controller: controller.sapronakScrollController,
                                                        itemBuilder: (context, index) => historyController.sapronakActivity
                                                    )
                                                ),
                                            )
                                        ),
                                        RawScrollbar(
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            controller: controller.harvestScrollController,
                                            child: Padding(
                                                padding: const EdgeInsets.only(top: 16, left: 16),
                                                child: RefreshIndicator(
                                                    onRefresh: () => Future.delayed(
                                                        const Duration(milliseconds: 200), () => historyController.harvestActivity.controller.generateData(coop)
                                                    ),
                                                    child: historyController.harvestActivity.controller.isLoading.isTrue ? Image.asset('images/card_height_450_lazy.gif') :
                                                    ListView.builder(
                                                        physics: const AlwaysScrollableScrollPhysics(),
                                                        itemCount: 1,
                                                        controller: controller.harvestScrollController,
                                                        itemBuilder: (context, index) => historyController.harvestActivity
                                                    )
                                                ),
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    ],
                ),
            )
        );
    }
}