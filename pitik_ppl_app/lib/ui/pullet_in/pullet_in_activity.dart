
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/pullet_in/pullet_in_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 05/10/2023

class PulletInActivity extends GetView<PulletInController> {
    const PulletInActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize:const Size.fromHeight(60),
                    child: AppBarFormForCoop(title: 'Pullet In', coop: controller.coop, hideCoopDetail: true)
                ),
                bottomNavigationBar: controller.isLoading.isTrue || controller.isAlreadySubmit.isTrue ? const SizedBox() : Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSubmitPulletIn"), label: "Buat Penjualan", onClick: () => controller.submitPulletIn()),
                ),
                body:  controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : Stack(
                    children: [
                        SingleChildScrollView(
                            child: Container(
                                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                child: Column(
                                    children: [
                                        controller.isAlreadySubmit.isTrue ? Column(
                                            children: [
                                                Container(
                                                    decoration: const BoxDecoration(
                                                        color: GlobalVar.greenBackground,
                                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                                    ),
                                                    padding: const EdgeInsets.all(12),
                                                    child: Row(
                                                        children: [
                                                            SvgPicture.asset('images/checkbox_circle_green.svg'),
                                                            const SizedBox(width: 8),
                                                            Text("Kamu sudah selesai melakukan Pullet In", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.green))
                                                        ],
                                                    ),
                                                ),
                                                const SizedBox(height: 16)
                                            ],
                                        ) : const SizedBox(),
                                        // Container(
                                        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        //     decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.circular(8),
                                        //         color: GlobalVar.grayBackground,
                                        //         border: const Border.fromBorderSide(BorderSide(width: 1.4, color: GlobalVar.outlineColor))
                                        //     ),
                                        //     child: Column(
                                        //         children: [
                                        //             Row(
                                        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                 children: [
                                        //                     Text("Detail DOC", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                                        //                     Text(controller.proc.value.deliveryDate != null ?DateFormat("dd/MM/yyyy").format(DateTime.parse(controller.proc.value.deliveryDate ?? "")) : "", style: GlobalVar.blackTextStyle)
                                        //                 ]
                                        //             ),
                                        //             const SizedBox(height: 8),
                                        //             Row(
                                        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                 children: [
                                        //                     Text("Merk DOC", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                        //                     Text(controller.proc.value.details.isNotEmpty ? controller.proc.value.details[0]!.productName! : "", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500))
                                        //                 ]
                                        //             ),
                                        //             const SizedBox(height: 4),
                                        //             Row(
                                        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                 children: [
                                        //                     Text("Total Populasi", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                        //                     Text("${controller.proc.value.details.isNotEmpty? (controller.proc.value.details[0]!.quantity??0).toInt():""} Ekor", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500))
                                        //                 ]
                                        //             )
                                        //         ]
                                        //     )
                                        // )
                                    ]
                                )
                            )
                        )
                    ]
                )
            )
        );
    }
}