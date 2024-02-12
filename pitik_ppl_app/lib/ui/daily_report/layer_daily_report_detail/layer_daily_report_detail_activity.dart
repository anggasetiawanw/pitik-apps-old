
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/daily_report/layer_daily_report_detail/layer_daily_report_detail_controller.dart';
import 'package:pitik_ppl_app/utils/enums/daily_report_enum.dart';
import 'package:pitik_ppl_app/utils/widgets/status_daily.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/01/2024

class LayerDailyReportDetailActivity extends GetView<LayerDailyReportDetailController> {
    const LayerDailyReportDetailActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: AppBarFormForCoop(
                        title: 'Laporan Harian',
                        coop: controller.coop,
                        titleStartDate: 'Pullet In'
                    )
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : controller.isCanRevision.isTrue ? Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]),
                    child: controller.bfRevision,
                ) : controller.reportArguments.status! != EnumDailyReport.LATE && controller.reportArguments.status! != EnumDailyReport.FINISHED && controller.report.value.revisionStatus != 'REVISED' ? Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]),
                    child: controller.bfEdit,
                ) : const SizedBox(),
                body: controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : RawScrollbar(
                    thumbColor: GlobalVar.primaryOrange,
                    child: Padding(
                        padding: const EdgeInsets.all(16),
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
                                                            Text(controller.reportArguments.date ?? '-', style: GlobalVar.blackTextStyle.copyWith(fontSize: 12))
                                                        ]
                                                    ),
                                                    StatusDailyReport(status: controller.reportArguments.status!)
                                                ]
                                            )
                                        ]
                                    )
                                ),
                                const SizedBox(height: 16),
                                Text('Produksi Ayam', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                                const SizedBox(height: 8),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: GlobalVar.outlineColor, width: 1)
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                        children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Bobot', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                    Text('${controller.report.value.averageWeight ?? '-'} gr', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                                ]
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Kematian', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                    Text('${controller.report.value.mortality ?? '-'} Ekor', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                                ]
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Afkir', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                    Text('${controller.report.value.culling ?? '-'} Ekor', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                                ]
                                            )
                                        ]
                                    )
                                ),
                                const SizedBox(height: 16),
                                const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                const SizedBox(height: 16),
                                controller.report.value.mortalityList.isNotEmpty ? Column(
                                    children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: GlobalVar.outlineColor, width: 1)
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: List.generate(controller.report.value.mortalityList.length, (index) => Column(
                                                    children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        Text('Kematian', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                        const SizedBox(height: 4),
                                                                        Text(
                                                                            '${controller.report.value.mortalityList[index]!.quantity ?? '-'} Ekor',
                                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                                        )
                                                                    ]
                                                                ),
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                        Text('Alasan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                        const SizedBox(height: 4),
                                                                        Text(
                                                                            controller.report.value.mortalityList[index]!.cause ?? '-',
                                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        ),
                                                        if (index < controller.report.value.mortalityList.length) ...[
                                                            const SizedBox(height: 8),
                                                            const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                                            const SizedBox(height: 8),
                                                        ]
                                                    ]
                                                ))
                                            )
                                        ),
                                        const SizedBox(height: 16)
                                    ]
                                ) : const SizedBox(),
                                Text('Produksi Telur', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                                const SizedBox(height: 8),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: GlobalVar.outlineColor, width: 1)
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Utuh Coklat', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                            const SizedBox(height: 6),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Text('Total (butir)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggQuantity(productName: 'Telur Utuh Cokelat'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    ),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                            Text('Total (kg)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggWeight(productName: 'Telur Utuh Cokelat'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    )
                                                ]
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                            const SizedBox(height: 16),
                                            Text('Utuh Krem', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                            const SizedBox(height: 6),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Text('Total (butir)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggQuantity(productName: 'Telur Utuh Krem'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    ),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                            Text('Total (kg)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggWeight(productName: 'Telur Utuh Krem'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    )
                                                ]
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                            const SizedBox(height: 16),
                                            Text('Retak', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                            const SizedBox(height: 6),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Text('Total (butir)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggQuantity(productName: 'Telur Retak'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    ),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                            Text('Total (kg)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggWeight(productName: 'Telur Retak'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    )
                                                ]
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                            const SizedBox(height: 16),
                                            Text('Pecah', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                            const SizedBox(height: 6),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Text('Total (butir)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggQuantity(productName: 'Telur Pecah'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    ),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                            Text('Total (kg)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggWeight(productName: 'Telur Pecah'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    )
                                                ]
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                            const SizedBox(height: 16),
                                            Text('Kotor', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                            const SizedBox(height: 6),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Text('Total (butir)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggQuantity(productName: 'Telur Kotor'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    ),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                            Text('Total (kg)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                                controller.getEggWeight(productName: 'Telur Kotor'),
                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            )
                                                        ]
                                                    )
                                                ]
                                            ),
                                            const SizedBox(height: 16),
                                            const Divider(color: GlobalVar.outlineColor, height: 1.4),
                                            const SizedBox(height: 16),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Total', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    Text(
                                                        '- Butir',
                                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                    )
                                                ]
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Berat Total', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    Text(
                                                        '- kg',
                                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                    )
                                                ]
                                            )
                                        ]
                                    )
                                ),
                                const SizedBox(height: 16),
                                Text('Konsumsi Pakan', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                                const SizedBox(height: 8),
                                controller.feedConsumptionWidget.value,
                                const SizedBox(height: 8),
                                Text('Konsumsi OVK', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                                const SizedBox(height: 8),
                                controller.ovkConsumptionWidget.value,
                                const SizedBox(height: 16),
                                Column(
                                    children: List.generate(controller.report.value.images == null || controller.report.value.images!.isEmpty ? 0 : controller.report.value.images!.length, (index) {
                                        return Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                child: Image.network(
                                                    controller.report.value.images![index] != null ? controller.report.value.images![index]!.url! : '',
                                                    width: MediaQuery.of(context).size.width - 36,
                                                    height: MediaQuery.of(context).size.width /2,
                                                    fit: BoxFit.fill,
                                                )
                                            )
                                        );
                                    })
                                )
                            ]
                        )
                    )
                )
            )
        );
    }
}