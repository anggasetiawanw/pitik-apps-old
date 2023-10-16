import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_form/daily_report_form_controller.dart';
import 'package:pitik_ppl_app/widget/common/custom_appbar.dart';
import 'package:pitik_ppl_app/widget/common/status_daily.dart';

class DailyReportFormActivity extends GetView<DailyReportFormController> {
  const DailyReportFormActivity({super.key});

  @override
  Widget build(BuildContext context) {


    Widget tileInfoHeader(String title, String value){
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(title, style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                const SizedBox(height: 4,),
                Text(value, style: GlobalVar.blackTextStyle)
            ],
        );
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40), 
            child: CustomAppbar(title: "Laporan Harian",isFlat: true, 
            onBack: (){
                Get.back();
            },),
        ),
        body: Column(
            children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16, top: 8),
                    decoration: const BoxDecoration(
                        color: GlobalVar.primaryOrange,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                    ),
                    child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text("Kandang 1 (Hari 275)", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 8,),
                                Text("DOC-In 2023-09-01", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12),),
                            ],
                    ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                            children: [
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
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Text("Laporan Harian", style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold),),
                                                            const SizedBox(height: 4,),
                                                            Text("2023-09-11",style: GlobalVar.blackTextStyle.copyWith(fontSize: 12), )
                                                        ],
                                                    ),
                                                    const StatusDailyReport(status: "Segera Isi")
                                                ],
                                            ),
                                            const SizedBox(height: 16,),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text("Daftar Stock", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                                    SvgPicture.asset("images/information_blue_icon.svg")
                                                ],
                                            ),
                                            const SizedBox(height: 16,),
                                            tileInfoHeader("Pre-Starter", "15 karung"),
                                            const SizedBox(height: 8,),
                                            tileInfoHeader("Starter", "15 karung"),
                                            const SizedBox(height: 8,),
                                            tileInfoHeader("Finisher", "15 karung"),
                                            const SizedBox(height: 8,),
                                            tileInfoHeader("OVK", "100 Buah"),
                                        ],
                                    ),
                                ),
                                controller.efBobot,
                                Row(
                                    children: [
                                        Expanded(child: controller.efKematian),
                                        const SizedBox(width: 4,),
                                        Expanded(child: controller.efCulling)
                                    ],
                                ),
                                controller.mfPhoto,
                                // TabBar(
                                //     controller: controller.tabController,
                                //     tabs: const [
                                //     Tab(text : "Konsumsi Pakan"),
                                //     Tab(text : "Konsumsi OVK"),
                                // ]),
                                // Expanded(
                                //   child: TabBarView(
                                //       controller: controller.tabController,
                                //       children: [
                                //       controller.mffKonsumsiPakan,
                                //       controller.mffKonsumsiOVK,
                                //   ]),
                                // )
                                  
                            ],
                    ),
                  ),
                )
            ],
        ),
    );
  }
}