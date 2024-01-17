
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
                                        Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: GlobalVar.grayBackground,
                                                border: const Border.fromBorderSide(BorderSide(width: 1.4, color: GlobalVar.outlineColor))
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text("Detail Pullet In", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                                                    const SizedBox(height: 16),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text("Tanggal Mulai Siklus", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            Text(controller.request.value!.startDate ?? '-', style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                        ]
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text("Tipe Pullet", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            Text('-', style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                        ]
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text("Total Populasi", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            Text('${controller.request.value!.initialPopulation ?? '-'} Ekor', style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                        ]
                                                    )
                                                ]
                                            )
                                        ),
                                        const SizedBox(height: 16),
                                        controller.dtTanggal,
                                        Row(
                                            children: [
                                                Expanded(child: controller.efPopulation),
                                                const SizedBox(width: 8),
                                                Expanded(child: controller.efAge)
                                            ]
                                        ),
                                        Row(
                                            children: [
                                                Expanded(child: controller.efBw),
                                                const SizedBox(width: 8),
                                                Expanded(child: controller.efUniform)
                                            ]
                                        ),
                                        Row(
                                            children: [
                                                Expanded(child: controller.dtTruckGo),
                                                const SizedBox(width: 8),
                                                Expanded(child: controller.dtTruckCome)
                                            ]
                                        ),
                                        controller.dtFinishPulletIn,
                                        controller.eaDesc,
                                        controller.isLoadingSuratJalan.isTrue ? SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context).size.width - 32,
                                            child: Padding(
                                                padding: const EdgeInsets.only(top: 16),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        const CircularProgressIndicator(color: GlobalVar.primaryOrange),
                                                        const SizedBox(width: 16),
                                                        Text('Upload foto Surat Jalan...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                                    ],
                                                ),
                                            )
                                        ) : controller.mfSuratJalan,
                                        controller.isLoadingFormPulletIn.isTrue ? SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context).size.width - 32,
                                            child: Padding(
                                                padding: const EdgeInsets.only(top: 16),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        const CircularProgressIndicator(color: GlobalVar.primaryOrange),
                                                        const SizedBox(width: 16),
                                                        Text('Upload foto Form Pullet In...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                                    ],
                                                ),
                                            )
                                        ) : controller.mfFormPullet,
                                        controller.isLoadingAnotherPullet.isTrue ? SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context).size.width - 32,
                                            child: Padding(
                                                padding: const EdgeInsets.only(top: 16),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        const CircularProgressIndicator(color: GlobalVar.primaryOrange),
                                                        const SizedBox(width: 16),
                                                        Text('Upload foto dokumen lainnya...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                                    ],
                                                ),
                                            )
                                        ) : controller.mfAnotherPullet
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