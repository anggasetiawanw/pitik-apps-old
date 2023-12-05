/// @author [Angga Setiawan Wahyudin]
/// @email [anggasetiaw@gmail.com]
/// @create date 2023-11-15 11:45:02
/// @modify date 2023-11-15 11:45:02
/// @desc [description]
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/report.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_home/daily_report_home_controller.dart';
import 'package:pitik_ppl_app/utils/enums/daily_report_enum.dart';
import 'package:pitik_ppl_app/utils/widgets/status_daily.dart';

class DailyReportHomeActivity extends GetView<DailyReportHomeController> {
  const DailyReportHomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    Widget listCard(Report? report) {
      return GestureDetector(
        onTap: () {
          if (report.status == EnumDailyReport.FILL_SOON) {
            Get.toNamed(RoutePage.dailyReportForm, arguments: [controller.coop!, report])!.then((value) => controller.getDailyReport());
          } else {
            Get.toNamed(RoutePage.dailyReportDetail, arguments: [controller.coop!, report])!.then((value) => controller.getDailyReport());
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: GlobalVar.outlineColor)),
          child: Row(
            children: [
              SvgPicture.asset(
                report?.status == EnumDailyReport.REVIEW_SOON || report?.status == EnumDailyReport.FILL_SOON || report?.status == EnumDailyReport.FILLED || report?.status == EnumDailyReport.REVIEWED
                    ? "images/history_active_icon.svg"
                    : report?.status == EnumDailyReport.FINISHED
                        ? "images/checkbox_circle_green.svg"
                        : "images/alarm_warning.svg",
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Laporan Harian",
                              style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${report?.date}",
                              style: GlobalVar.blackTextStyle.copyWith(fontSize: 12),
                            )
                          ],
                        ),
                        StatusDailyReport(status: report!.status!)
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Laporan harian ${report.status}",
                      style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(preferredSize: const Size.fromHeight(110), child: AppBarFormForCoop(title: 'Laporan Harian', coop: controller.coop!)),
        body: Column(
          children: [
            Obx(() => controller.isLoading.isTrue
                ? const Center(
                    child: ProgressLoading(),
                  )
                : Expanded(
                    child: RawScrollbar(
                      // thumbVisibility: true,
                      thumbColor: GlobalVar.primaryOrange,
                      radius: const Radius.circular(8),
                      child: RefreshIndicator(
                          onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () { controller.getDailyReport();} //GENERATE DATA
                              ),
                          child: controller.isLoadingList.isTrue
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16, top: 16),
                                  child: Image.asset('images/card_height_450_lazy.gif'),
                                )
                              : Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: ListView.builder(physics: const AlwaysScrollableScrollPhysics(), itemCount: controller.reportList.length, itemBuilder: (context, index) => listCard(controller.reportList[index])))),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
