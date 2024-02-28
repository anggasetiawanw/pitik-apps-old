import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'smart_scale_harvest_detail_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 29/12/2023

class SmartScaleHarvestDetailActivity extends GetView<SmartScaleHarvestDetailController> {
  const SmartScaleHarvestDetailActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBarFormForCoop(
            title: 'Data Timbang',
            coop: controller.coop,
          ),
        ),
        bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : controller.containerButtonEditAndPreview.value,
        body: Container(
            padding: const EdgeInsets.all(16),
            child: controller.isLoading.isTrue
                ? const Center(child: ProgressLoading())
                : controller.isNext.isTrue
                    ? ListView(children: [
                        Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(color: GlobalVar.grayBackground, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Column(children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Hasil Realisasi', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                controller.getRealizationStatusWidget(statusText: controller.realization.statusText ?? '')
                              ]),
                              const SizedBox(height: 12),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Jumlah Ayam', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.getQuantityText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 8),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Total Tonase', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.getTonnageText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 8),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Berat Rata-Rata', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.getAverageWeightText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ])
                            ])),
                        const SizedBox(height: 16),
                        Text('Data Timbang', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                        const SizedBox(height: 8),
                        Container(
                            width: MediaQuery.of(Get.context!).size.width,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: const BoxDecoration(color: Colors.white, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('No. Timbang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.weighingNumber ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Tanggal Tangkap', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(Convert.getDate(controller.realization.harvestDate), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Nama Kandang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.coopName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Alamat', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.addressName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Jam Tangkap', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.weighingTime ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Jam Berangkat', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.truckDepartingTime ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Bakul', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.bakulName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Nama Sopir', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.driver ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Nopol Kendaraan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.truckLicensePlate ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Text('Pengajuan ${Convert.getDate(controller.realization.harvestRequestDate)}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                              const SizedBox(height: 4),
                              Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                      Text(controller.getBwText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]),
                                    const SizedBox(height: 4),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Jumlah Ayam', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                      Text(controller.getQuantityText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]),
                                    const SizedBox(height: 4),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Alasan Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                      Text(controller.realization.reason ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ])
                                  ]))
                            ])),
                        const SizedBox(height: 16),
                        Text('Saksi Timbang', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                        const SizedBox(height: 8),
                        Container(
                            width: MediaQuery.of(Get.context!).size.width,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: const BoxDecoration(color: Colors.white, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Diketahui Oleh', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.witnessName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Diterima Oleh', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.receiverName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                              const SizedBox(height: 4),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('Ditimbang Oleh', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                Text(controller.realization.weigherName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ])
                            ]))
                      ])
                    : Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          GestureDetector(
                            onTap: () {
                              controller.pageSelected.value = controller.pageSelected.value - 1 > 1 ? controller.pageSelected.value - 1 : 1;
                              controller.generatePaginationNumber();
                            },
                            child: const Icon(Icons.arrow_back_ios, color: GlobalVar.primaryOrange),
                          ),
                          Expanded(child: Center(child: SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(), scrollDirection: Axis.horizontal, child: controller.paginationNumber.value))),
                          GestureDetector(
                            onTap: () {
                              controller.pageSelected.value = controller.pageSelected.value + 1 < controller.paginationNumber.value.children.length ? controller.pageSelected.value + 1 : controller.paginationNumber.value.children.length;
                              controller.generatePaginationNumber();
                            },
                            child: const Icon(Icons.arrow_forward_ios, color: GlobalVar.primaryOrange),
                          )
                        ]),
                        const SizedBox(height: 16),
                        Expanded(
                            child: ListView(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Halaman ${controller.pageSelected.value}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                            Text("NO.${controller.realization.weighingNumber ?? '-'}", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                          ]),
                          if (controller.realization.records.isNotEmpty && controller.realization.records[0]!.details.isNotEmpty) ...[
                            Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  SizedBox(
                                    width: 40,
                                    child: Text('No', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('Jumlah Ayam', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black))),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('Timbangan', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black))),
                                ]))
                          ] else ...[
                            const SizedBox()
                          ],
                          controller.paginationWidget.isNotEmpty ? Column(children: controller.paginationWidget[controller.pageSelected.value - 1]) : const SizedBox()
                        ]))
                      ]))));
  }
}
