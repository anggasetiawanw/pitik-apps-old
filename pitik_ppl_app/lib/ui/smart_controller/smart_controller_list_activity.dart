import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'smart_controller_list_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 01/11/2023

class SmartControllerListActivity extends GetView<SmartControllerListController> {
  const SmartControllerListActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: AppBarFormForCoop(
              title: 'Smart Controller',
              coop: controller.coop,
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              controller.isLoading.isTrue
                  ? Padding(padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - 80) / 3), child: const Center(child: ProgressLoading()))
                  : Expanded(
                      child: RawScrollbar(
                          thumbColor: GlobalVar.primaryOrange,
                          radius: const Radius.circular(8),
                          child: RefreshIndicator(
                            onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.getFloorList()),
                            child: ListView.builder(physics: const AlwaysScrollableScrollPhysics(), itemCount: controller.floorList.length, itemBuilder: (context, index) => controller.createFloorCard(floor: controller.floorList[index])),
                          )))
            ],
          ),
        ));
  }
}
