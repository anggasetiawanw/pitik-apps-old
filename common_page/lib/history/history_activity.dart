
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
            body: Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TabBar(
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
                        ),
                    ),
                    Expanded(
                        child: TabBarView(
                            controller: historyController.tabController,
                            children: [
                                RawScrollbar(
                                    thumbVisibility: true,
                                    thumbColor: GlobalVar.primaryOrange,
                                    radius: const Radius.circular(8),
                                    child: ListView(
                                        children: [
                                            historyController.performanceActivity
                                        ],
                                    )
                                ),
                                RawScrollbar(
                                    thumbVisibility: true,
                                    thumbColor: GlobalVar.primaryOrange,
                                    radius: const Radius.circular(8),
                                    child: ListView(
                                        children: [
                                            historyController.sapronakActivity
                                        ],
                                    )
                                ),
                                RawScrollbar(
                                    thumbColor: GlobalVar.primaryOrange,
                                    radius: const Radius.circular(8),
                                    controller: controller.scrollController,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        controller: controller.scrollController,
                                        itemBuilder: (context, index) => historyController.harvestActivity
                                    )
                                )
                            ]
                        )
                    )
                ],
            )
        );
    }
}