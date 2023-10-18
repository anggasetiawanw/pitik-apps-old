import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_home/daily_report_home_controller.dart';
import 'package:pitik_ppl_app/widget/common/custom_appbar.dart';

class DailyReportHomeActivity extends GetView<DailyReportHomeController> {
  const DailyReportHomeActivity
({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(40), child: CustomAppbar(title: "Laporan Harian",isFlat: true, onBack: (){
            Get.back();
            },)
        ),
    body: Column(children: [
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
        RawScrollbar(
            controller: controller.scrollController,
            scrollbarOrientation: ScrollbarOrientation.right,
            thumbVisibility: true,
            thumbColor: GlobalVar.primaryOrange,
            radius: const Radius.circular(8),
            child: RefreshIndicator(
                onRefresh: () => Future.delayed(
                    const Duration(milliseconds: 200), (){} //GENERATE DATA
                ),
                child: controller.isLoadingList.isTrue ? Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: Image.asset('images/card_height_450_lazy.gif'),
                ) :
                // ListView.builder(
                //     physics: const AlwaysScrollableScrollPhysics(),
                //     itemCount: 1,
                //     controller: controller.performanceScrollController,
                //     itemBuilder: (context, index) => historyController.performanceActivity
                // )
               ListView(
                children: const [
                    
                ],
               )
            ),
        )
        ],),
    );
  }
}