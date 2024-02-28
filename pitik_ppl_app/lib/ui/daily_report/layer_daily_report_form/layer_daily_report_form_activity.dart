
// ignore_for_file: deprecated_member_use

import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/daily_report/layer_daily_report_form/layer_daily_report_form_controller.dart';
import 'package:pitik_ppl_app/utils/widgets/status_daily.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 29/01/2024

class LayerDailyReportFormActivity extends GetView<LayerDailyReportFormController> {
    const LayerDailyReportFormActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            WillPopScope(
                onWillPop: () async {
                    controller.previousPage();
                    return false;
                },
                child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(120),
                        child: AppBarFormForCoop(
                            title: 'Laporan Harian',
                            coop: controller.coop,
                            onBackPressed: () => controller.previousPage(),
                            titleStartDate: 'Pullet In',
                        )
                    ),
                    bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : Container(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]),
                        child: controller.isSubmitButton.isFalse ? controller.bfNext : controller.bfSubmit,
                    ),
                    body: controller.isLoading.isTrue ? const Center(child: CircularProgressIndicator(color: GlobalVar.primaryOrange)): Column(
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
                                child: Row(
                                    children: [
                                        Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                                controller.barList[0],
                                                controller.pointList[0]
                                            ]
                                        ),
                                        Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                                controller.barList[1],
                                                controller.pointList[1]
                                            ]
                                        ),
                                        controller.pointList[2]
                                    ]
                                ),
                            ),
                            const SizedBox(height: 8),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: controller.getLabelPoint()),
                            const SizedBox(height: 16),
                            Expanded(
                                child: controller.state.value == 0 ? Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                    child: ListView(
                                        children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: GlobalVar.grayBackground,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: GlobalVar.outlineColor, width: 1),
                                                ),
                                                padding: const EdgeInsets.all(16),
                                                child: Column(
                                                    children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        Text("Detail Laporan Harian", style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                                                        const SizedBox(height: 4),
                                                                        Text("${controller.report.date}", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12))
                                                                    ]
                                                                ),
                                                                StatusDailyReport(status: controller.report.status!)
                                                            ]
                                                        )
                                                    ]
                                                )
                                            ),
                                            controller.efWeight,
                                            controller.efCulled,
                                            controller.isLoadingChickDead.isTrue ? SizedBox(
                                                height: 50,
                                                width: MediaQuery.of(context).size.width - 32,
                                                child: Padding(
                                                    padding: const EdgeInsets.only(top: 16),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                            const CircularProgressIndicator(color: GlobalVar.primaryOrange),
                                                            const SizedBox(width: 16),
                                                            Text('Upload foto kematian...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                                        ],
                                                    ),
                                                )
                                            ) : controller.mfChickDead,
                                            const SizedBox(height: 10),
                                            controller.reasonMultipleFormField
                                        ]
                                    )
                                ) : controller.state.value == 1 ? Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                    child: ListView(
                                        children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: GlobalVar.grayBackground,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: GlobalVar.outlineColor, width: 1),
                                                ),
                                                padding: const EdgeInsets.all(16),
                                                child: Column(
                                                    children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        Text("Detail Laporan Harian", style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                                                        const SizedBox(height: 4),
                                                                        Text("${controller.report.date}", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12))
                                                                    ]
                                                                ),
                                                                StatusDailyReport(status: controller.report.status!)
                                                            ]
                                                        )
                                                    ]
                                                )
                                            ),
                                            Column(
                                                children: [
                                                    const SizedBox(height: 32),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            GestureDetector(
                                                                onTap: () => controller.toFeedConsumption(),
                                                                child: Container(
                                                                    width: (MediaQuery.of(context).size.width / 2) - 16,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)),
                                                                        color: controller.isFeed.isTrue ? GlobalVar.primaryLight2 : GlobalVar.primaryLight
                                                                    ),
                                                                    child: Column(
                                                                        children: [
                                                                            Container(
                                                                                padding: const EdgeInsets.only(top: 12, bottom: 12),
                                                                                child: Text(
                                                                                    'Konsumsi Pakan',
                                                                                    style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.isFeed.isTrue ? GlobalVar.primaryOrange : GlobalVar.grayLightText)
                                                                                )
                                                                            ),
                                                                            Container(height: 3, color: controller.isFeed.isTrue ? GlobalVar.primaryOrange : Colors.transparent)
                                                                        ],
                                                                    ),
                                                                ),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () => controller.toOvkConsumption(),
                                                                child: Container(
                                                                    width: (MediaQuery.of(context).size.width / 2) - 16,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
                                                                        color: controller.isFeed.isFalse ? GlobalVar.primaryLight2 : GlobalVar.primaryLight
                                                                    ),
                                                                    child: Column(
                                                                        children: [
                                                                            Container(
                                                                                padding: const EdgeInsets.only(top: 12, bottom: 12),
                                                                                child: Text(
                                                                                    'Konsumsi OVK',
                                                                                    style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.isFeed.isFalse ? GlobalVar.primaryOrange : GlobalVar.grayLightText)
                                                                                )
                                                                            ),
                                                                            Container(height: 3, color: controller.isFeed.isFalse ? GlobalVar.primaryOrange : Colors.transparent)
                                                                        ],
                                                                    ),
                                                                ),
                                                            )
                                                        ],
                                                    ),
                                                    controller.isFeed.isTrue ? controller.feedMultipleFormField : controller.ovkMultipleFormField
                                                ],
                                            )
                                        ]
                                    )
                                ) : Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                    child: ListView(
                                        children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: GlobalVar.grayBackground,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: GlobalVar.outlineColor, width: 1),
                                                ),
                                                padding: const EdgeInsets.all(16),
                                                child: Column(
                                                    children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        Text("Detail Laporan Harian", style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                                                        const SizedBox(height: 4),
                                                                        Text("${controller.report.date}", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12))
                                                                    ]
                                                                ),
                                                                StatusDailyReport(status: controller.report.status!)
                                                            ]
                                                        )
                                                    ]
                                                )
                                            ),
                                            Row(
                                                children: [
                                                    Expanded(child: controller.efUtuhCoklat),
                                                    const SizedBox(width: 8),
                                                    Expanded(child: controller.efUtuhCoklatTotal)
                                                ]
                                            ),
                                            Row(
                                                children: [
                                                    Expanded(child: controller.efUtuhKrem),
                                                    const SizedBox(width: 8),
                                                    Expanded(child: controller.efUtuhKremTotal)
                                                ]
                                            ),
                                            Row(
                                                children: [
                                                    Expanded(child: controller.efRetak),
                                                    const SizedBox(width: 8),
                                                    Expanded(child: controller.efRetakTotal)
                                                ]
                                            ),
                                            Row(
                                                children: [
                                                    Expanded(child: controller.efPecah),
                                                    const SizedBox(width: 8),
                                                    Expanded(child: controller.efPecahTotal)
                                                ]
                                            ),
                                            Row(
                                                children: [
                                                    Expanded(child: controller.efKotor),
                                                    const SizedBox(width: 8),
                                                    Expanded(child: controller.efKotorTotal)
                                                ]
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                            controller.efEggDisposal,
                                            const SizedBox(height: 16),
                                            const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                            controller.spAbnormalEgg,
                                            controller.efTotal,
                                            controller.efBeratTotal,
                                            controller.isLoadingRecodingCard.isTrue ? SizedBox(
                                                height: 50,
                                                width: MediaQuery.of(context).size.width - 32,
                                                child: Padding(
                                                    padding: const EdgeInsets.only(top: 16),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                            const CircularProgressIndicator(color: GlobalVar.primaryOrange),
                                                            const SizedBox(width: 16),
                                                            Text('Upload foto kartu recoding...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                                        ],
                                                    ),
                                                )
                                            ) : controller.mfRecordingCard,
                                            controller.eaDesc
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
            )
        );
    }
}