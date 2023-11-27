import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_detail/daily_report_detail_controller.dart';
import 'package:pitik_ppl_app/utils/enums/daily_report_enum.dart';
import 'package:pitik_ppl_app/utils/widgets/status_daily.dart';

class DailyReportDetailActivity extends StatelessWidget {
  const DailyReportDetailActivity({super.key});

  @override
  Widget build(BuildContext context) {
    DailyReportDetailController controller = Get.put(DailyReportDetailController(context: context));

    Widget rowDetail(String title, String? value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),
          ),
          Text(
            "$value",
            style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          )
        ],
      );
    }

    Widget consumtionDetail(String merek, String value) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: GlobalVar.outlineColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Merek",
              style: GlobalVar.subTextStyle.copyWith(fontSize: 12),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              merek,
              style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Total",
              style: GlobalVar.subTextStyle.copyWith(fontSize: 12),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              value,
              style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    Widget bottomNavbar() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.report?.status == EnumDailyReport.FILLED || controller.report?.status == EnumDailyReport.REVIEWED) ...[
                    controller.btEdit
                  ] else if (controller.report?.status == EnumDailyReport.REVIEW_SOON) ...[
                    Expanded(child: controller.btDataBenar),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(child: controller.btEditOutline)
                  ]
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(110),
                child: AppBarFormForCoop(title: 'Laporan Harian', coop: controller.coop!)),
        body: Obx(
          () => controller.isLoading.isTrue
              ? const Center(
                  child: ProgressLoading(),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: GlobalVar.outlineColor), color: GlobalVar.grayBackground),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Detail Laporan Harian", style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(DateFormat("yyyy-MM-dd").format(Convert.getDatetime(controller.coop!.startDate!)), style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 12)),
                                        ],
                                      ),
                                      StatusDailyReport(status: controller.report!.status!)
                                    ]),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: GlobalVar.outlineColor),
                                    ),
                                    child: Column(
                                      children: [
                                        rowDetail("Bobot", "${controller.reportDetail?.averageWeight} gr"),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        rowDetail("Kematian", "${controller.reportDetail?.mortality} ekor"),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        rowDetail("Culling", "${controller.reportDetail?.culling} ekor"),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    "Konsumsi Pakan",
                                    style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (controller.reportDetail!.feedConsumptions!.isNotEmpty) ...[Column(children: controller.reportDetail!.feedConsumptions!.map((e) => consumtionDetail("${e!.subcategoryName} - ${e.productName!}", "${e.quantity} ${e.uom}")).toList())] else ...[Text("-", style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 12))],
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    "Konsumsi OVK",
                                    style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (controller.reportDetail!.ovkConsumptions!.isNotEmpty) ...[Column(children: controller.reportDetail!.feedConsumptions!.map((e) => consumtionDetail("${e!.subcategoryName} - ${e.productName!}", "${e.quantity} ${e.uom}")).toList())] else ...[Container(margin: const EdgeInsets.only(top: 16), child: Text("-", style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 12)))],
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  if (controller.reportDetail!.images!.isNotEmpty) ...[
                                    Column(
                                      children: controller.reportDetail!.images!
                                          .map(
                                            (e) => Container(
                                              width: double.infinity,
                                              // height: 400,
                                              margin: const EdgeInsets.only(bottom: 16),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Image.network(
                                                e!.url!,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      color: GlobalVar.primaryOrange,
                                                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    if (controller.report!.status != EnumDailyReport.FINISHED && controller.report!.status != EnumDailyReport.LATE) bottomNavbar(),
                  ],
                ),
        ));
  }
}
