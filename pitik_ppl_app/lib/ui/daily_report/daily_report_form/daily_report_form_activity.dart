import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/widgets/status_daily.dart';
import 'daily_report_form_controller.dart';

class DailyReportFormActivity extends GetView<DailyReportFormController> {
  const DailyReportFormActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final DailyReportFormController controller = Get.put(DailyReportFormController(context: context));

    Widget tileInfoHeader(String title, String value) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)), const SizedBox(height: 4), Text(value, style: GlobalVar.blackTextStyle)]);
    }

    return Obx(() => SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(preferredSize: const Size.fromHeight(120), child: AppBarFormForCoop(title: 'Laporan Harian', coop: controller.coop)),
            bottomNavigationBar: controller.isLoading.isTrue
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]),
                    child: controller.bfSimpan,
                  ),
            body: controller.isLoading.isTrue
                ? const Center(child: CircularProgressIndicator(color: GlobalVar.primaryOrange))
                : Stack(children: [
                    SingleChildScrollView(
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: GlobalVar.grayBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: GlobalVar.outlineColor, width: 1),
                                ),
                                child: Column(
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text('Laporan Harian', style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text('${controller.report.date}', style: GlobalVar.blackTextStyle.copyWith(fontSize: 12))
                                      ]),
                                      StatusDailyReport(status: controller.report.status!)
                                    ]),
                                    const SizedBox(height: 16),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Daftar Stock', style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                      GestureDetector(onTap: () => controller.showStockSummary(), child: SvgPicture.asset('images/information_blue_icon.svg'))
                                    ]),
                                    const SizedBox(height: 16),
                                    tileInfoHeader('Pre-Starter', '${controller.prestarterStockSummary} karung'),
                                    const SizedBox(height: 8),
                                    tileInfoHeader('Starter', '${controller.starterStockSummary} karung'),
                                    const SizedBox(height: 8),
                                    tileInfoHeader('Finisher', '${controller.finisherStockSummary} karung'),
                                    const SizedBox(height: 8),
                                    tileInfoHeader('OVK', '${controller.ovkStockSummary}'),
                                  ],
                                ),
                              ),
                              controller.efBobot,
                              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: controller.efKematian), const SizedBox(width: 4), Expanded(child: controller.efCulling)]),
                              controller.mfPhoto,
                              Column(children: [
                                const SizedBox(height: 32),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  GestureDetector(
                                      onTap: () => controller.isFeed.value = true,
                                      child: Container(
                                          width: (MediaQuery.of(context).size.width / 2) - 16,
                                          decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)), color: controller.isFeed.isTrue ? GlobalVar.primaryLight2 : GlobalVar.primaryLight),
                                          child: Column(children: [
                                            Container(
                                                padding: const EdgeInsets.only(top: 12, bottom: 12),
                                                child: Text('Konsumsi Pakan', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.isFeed.isTrue ? GlobalVar.primaryOrange : GlobalVar.grayLightText))),
                                            Container(height: 3, color: controller.isFeed.isTrue ? GlobalVar.primaryOrange : Colors.transparent)
                                          ]))),
                                  GestureDetector(
                                      onTap: () => controller.isFeed.value = false,
                                      child: Container(
                                          width: (MediaQuery.of(context).size.width / 2) - 16,
                                          decoration: BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10)), color: controller.isFeed.isFalse ? GlobalVar.primaryLight2 : GlobalVar.primaryLight),
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                                                  child:
                                                      Text('Konsumsi OVK', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.isFeed.isFalse ? GlobalVar.primaryOrange : GlobalVar.grayLightText))),
                                              Container(height: 3, color: controller.isFeed.isFalse ? GlobalVar.primaryOrange : Colors.transparent)
                                            ],
                                          )))
                                ]),
                                Obx(() => controller.isFeed.isTrue ? controller.mffKonsumsiPakan : controller.mffKonsumsiOVK)
                              ])
                            ])))
                  ]))));
  }
}
