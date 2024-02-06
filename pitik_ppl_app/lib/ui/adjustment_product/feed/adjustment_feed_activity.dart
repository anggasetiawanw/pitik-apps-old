
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:pitik_ppl_app/ui/adjustment_product/feed/adjustment_feed_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 8/12/2023

class AdjustmentFeedActivity extends GetView<AdjustmentFeedController> {
    const AdjustmentFeedActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(140),
                    child: AppBarFormForCoop(
                        title: 'Pencatatan Pakan',
                        coop: controller.coop,
                        actionBars: {'Penyesuaian Pakan'}.map((String choice) {
                            return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                onTap: () => Get.toNamed(RoutePage.adjustmentProduct, arguments: [controller.coop, true])!.then((value) => controller.refreshData()),
                            );
                        }).toList(),
                    )
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnAdjustmentFeedSave"), label: "Simpan", onClick: () => controller.saveAdjustment()),
                ),
                body: controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                        children: [
                            Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                    color: GlobalVar.grayBackground,
                                    border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text('Perkiraan Stok', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Pre-Starter', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(controller.prestarterStockSummary.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                            ]
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Starter', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(controller.starterStockSummary.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                            ]
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Finisher', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(controller.finisherStockSummary.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                            ]
                                        )
                                    ]
                                )
                            ),
                            const SizedBox(height: 12),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: const BoxDecoration(
                                    color: GlobalVar.blueBackground,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                        SvgPicture.asset('images/information_blue_icon.svg'),
                                        const SizedBox(width: 12),
                                        Expanded(
                                            child: Text(
                                                'Pencatatan konsumsi pakan selama satu siklus berlangsung',
                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.blue),
                                                overflow: TextOverflow.clip
                                            )
                                        )
                                    ]
                                )
                            ),
                            controller.eaNotes,
                            const SizedBox(height: 12),
                            controller.feedMultipleFormField
                        ]
                    )
                )
            )
        );
    }
}