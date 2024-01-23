
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/coop/coop_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 05/10/2023

class CoopActivity extends GetView<CoopController> {
    const CoopActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Column(
                    children: [
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Flexible(
                                        flex: 9,
                                        child: controller.searchCoopBarField,
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: PopupMenuButton<String>(
                                            icon: SvgPicture.asset('images/dot_primary_orange_icon.svg', width: 5, height: 25),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(8))
                                            ),
                                            itemBuilder: (BuildContext context) {
                                                return {'Logout'}.map((String choice) {
                                                    return PopupMenuItem<String>(
                                                        value: choice,
                                                        height: 28,
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                const SizedBox(),
                                                                Text(choice, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                const SizedBox()
                                                            ]
                                                        ),
                                                        onTap: () => GlobalVar.invalidResponse()
                                                    );
                                                }).toList();
                                            }
                                        )
                                    )
                                ]
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: TabBar(
                                controller: controller.tabController,
                                indicatorColor: GlobalVar.primaryOrange,
                                labelColor: GlobalVar.primaryOrange,
                                unselectedLabelColor: GlobalVar.gray,
                                labelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                unselectedLabelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                tabs: const [
                                    Tab(text: "Kandang Aktif"),
                                    Tab(text: "Kandang Rehat")
                                ]
                            ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() =>
                            controller.isLoading.isTrue ? Padding(padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - 80) / 3), child: const ProgressLoading()) :
                            Expanded(
                                child: TabBarView(
                                    controller: controller.tabController,
                                    children: [
                                        RawScrollbar(
                                            thumbVisibility: true,
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            child: ListView.builder(
                                                itemCount: controller.coopFilteredList.length,
                                                itemBuilder: (context, index) => controller.createCoopActiveCard(index)
                                            )
                                        ),
                                        RawScrollbar(
                                            thumbVisibility: true,
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            child: ListView.builder(
                                                itemCount: controller.coopFilteredList.length,
                                                itemBuilder: (context, index) => controller.createCoopIdleCard(index)
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    ]
                )
            )
        );
    }
}