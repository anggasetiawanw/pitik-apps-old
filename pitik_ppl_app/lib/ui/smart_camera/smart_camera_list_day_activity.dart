import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'smart_camera_list_day_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 10/11/2023

class SmartCameraListDayActivity extends GetView<SmartCameraListDayController> {
  const SmartCameraListDayActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBarFormForCoop(
              title: 'Smart Camera',
              coop: controller.coop,
              hideCoopDetail: true,
            ),
          ),
          body: controller.isLoading.isTrue
              ? // IF LOADING IS RUNNING
              const Center(child: ProgressLoading())
              : RefreshIndicator(
                  child: controller.dayList.isEmpty
                      ? // IF LOADING IS DONE AND DATA EMPTY
                      Column(
                          children: [
                            const SizedBox(height: 16),
                            ListView(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height - 210,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('images/empty_icon.svg'),
                                      const SizedBox(height: 17),
                                      Text('Belum ada data', textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium))
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      : Column(children: [
                          const SizedBox(height: 16),
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                                  child: ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: controller.dayList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: controller.addCard(smartCameraDay: controller.dayList[index]!, isRedChild: index == 0),
                                        );
                                      })))
                        ]),
                  onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.getDayList())),
        ));
  }
}
