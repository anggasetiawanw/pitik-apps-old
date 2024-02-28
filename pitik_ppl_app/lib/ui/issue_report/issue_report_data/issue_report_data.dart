import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../route.dart';
import 'issue_report_data_controller.dart';

class IssueReportActivity extends StatelessWidget {
  const IssueReportActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final IssueReportDataController controller = Get.put(IssueReportDataController(context: context));
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: AppBarFormForCoop(
              title: 'Laporan Masalah',
              coop: controller.coop,
            )),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: FloatingActionButton(
              elevation: 12,
              onPressed: () => Get.toNamed(RoutePage.issueReportForm, arguments: [controller.coop])!.then((value) => controller.refreshList()),
              backgroundColor: GlobalVar.primaryOrange,
              child: const Icon(Icons.add, color: Colors.white),
            )),
        body: Column(
          children: [
            Expanded(
              child: controller.isLoading.isTrue
                  ? const Center(child: CircularProgressIndicator())
                  : controller.issueList.isEmpty
                      ? Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Image.asset(
                            'images/issue_not_found.png',
                            width: 200,
                            height: 200,
                          ),
                          Text(
                            'Belum ada isu yang di tampilkan',
                            style: GlobalVar.greyTextStyle,
                          )
                        ]))
                      : ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.issueList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Expandable(
                                titleBorderColor: GlobalVar.outlineColor,
                                titleBackgroundColorCollapse: Colors.white,
                                titleBackgroundColorExpand: Colors.white,
                                controller: GetXCreator.putAccordionController('accordion_issue_report_$index'),
                                headerText: 'null',
                                titleWidget: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset('images/issue_report_icon.svg', width: 32, height: 32),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Hari Ke-${controller.issueList[index]?.dayNum}', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium)),
                                        const SizedBox(height: 8),
                                        Text('Kategori:', style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                        Text('${controller.issueList[index]?.text}', style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(Convert.getDate(controller.issueList[index]!.date), style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: const Color(0xFFD0F5FD), width: 1),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: const Text(
                                            'Baru',
                                            style: TextStyle(fontSize: 12, color: Color(0xFF198BDB)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Column(
                                    children: [
                                      Text('Deskripsi', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium)),
                                      const SizedBox(height: 8),
                                      Text('${controller.issueList[index]?.description}', style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                      const SizedBox(height: 16),
                                      Text('Foto', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium)),
                                      const SizedBox(height: 8),
                                      Column(
                                          children: controller.issueList[index]?.photoValue
                                                  ?.map((e) => Image.network(
                                                        e!.url!,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ))
                                                  .toList() ??
                                              [])
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
            controller.isLoadMore.isTrue ? const Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()) : const SizedBox()
          ],
        )));
  }
}
