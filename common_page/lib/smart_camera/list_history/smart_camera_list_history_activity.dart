import 'package:common_page/smart_camera/list_history/smart_camera_list_history_controller.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 10/11/2023

class SmartCameraListHistoryActivity extends GetView<SmartCameraListHistoryController> {
  const SmartCameraListHistoryActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBarFormForCoop(
                title: 'Smart Camera',
                coop: controller.bundle.getCoop,
                hideCoopDetail: true,
              ),
            ),
            body: Stack(children: [
              controller.isLoading.isTrue
                  ? const Center(child: ProgressLoading())
                  : controller.sensorCameras.isEmpty
                      ? Center(
                          child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                              margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                              child: Column(children: [
                                SvgPicture.asset("images/empty_icon.svg"),
                                const SizedBox(height: 17),
                                Text("Data Camera Belum Ada", textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium))
                              ])))
                      : Column(children: [
                          const SizedBox(height: 16),
                          Container(
                              decoration: BoxDecoration(color: GlobalVar.primaryLight, borderRadius: BorderRadius.circular(8), border: Border.all(width: 1, color: GlobalVar.outlineColor)),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(12),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [Expanded(child: Text("Detail Gambar ", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium)))],
                                ),
                                const SizedBox(height: 12),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(child: Text("Total Kamera", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium))),
                                  Text("${controller.totalCamera}", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium), overflow: TextOverflow.clip)
                                ])
                              ])),
                          Container(
                              margin: const EdgeInsets.only(right: 16, left: 16, top: 16),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: GlobalVar.blueLights, borderRadius: BorderRadius.circular(8)),
                              child: Row(children: [
                                SvgPicture.asset("images/information_blue_icon.svg"),
                                const SizedBox(width: 8),
                                Expanded(child: Text("Silahkan ambil gambar terlebih dahulu", style: GlobalVar.blueTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium)))
                              ])),
                          Expanded(child: controller.listSmartCamera())
                        ]),
              controller.bundle.isCanTakePicture ? controller.bottomNavBar() : const SizedBox()
            ]))));
  }
}
