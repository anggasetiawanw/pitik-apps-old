import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../route.dart';
import '../bundle/harvest_realization_bundle.dart';
import 'harvest_realization_detail_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 23/11/2023

class HarvestRealizationDetailActivity extends GetView<HarvestRealizationDetailController> {
  const HarvestRealizationDetailActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBarFormForCoop(
            title: 'Realisasi Panen',
            coop: controller.coop,
          ),
        ),
        bottomNavigationBar: controller.isLoading.isTrue
            ? const SizedBox()
            : controller.realization.statusText != GlobalVar.SELESAI
                ? SizedBox(
                    child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]),
                        child: SizedBox(
                            width: MediaQuery.of(Get.context!).size.width - 32,
                            child: ButtonFill(
                                controller: GetXCreator.putButtonFillController('btnHarvestRealizationEdit'),
                                label: 'Edit',
                                onClick: () {
                                  GlobalVar.track('Click_button_edit_realisasi');
                                  Get.offNamed(RoutePage.harvestRealizationForm, arguments: HarvestRealizationBundle(getCoop: controller.coop, getRealization: controller.realization));
                                }))))
                : const SizedBox(),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: controller.isLoading.isTrue
                ? const Center(child: ProgressLoading())
                : ListView(children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(color: GlobalVar.grayBackground, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Column(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Informasi Realisasi Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                            controller.getRealizationStatusWidget(statusText: controller.realization.statusText ?? '')
                          ]),
                          const SizedBox(height: 12),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('No. DO', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                            Text(controller.realization.deliveryOrder ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Bakul', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                            Text(controller.realization.bakulName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                            Text(controller.getBwText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Jumlah Ayam', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                            Text(controller.getQuantityText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                          ])
                        ])),
                    const SizedBox(height: 16),
                    Text('Data Timbang', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(color: Colors.white, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Tanggal Tangkap', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.harvestDate ?? '-', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Jam Tangkap', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.weighingTime ?? '-', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Jam Berangkat', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.truckDepartingTime ?? '-', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Nama Sopir', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.driver ?? '-', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Nopol Kendaraan', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.truckLicensePlate ?? '-', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ])
                        ])),
                    const SizedBox(height: 8),
                    Text('Kartu Timbang', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(color: Colors.white, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Nomor Data Timbang', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.records.isNotEmpty && controller.realization.records[0] != null ? controller.realization.records[0]!.weighingNumber ?? '-' : '-',
                                style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Jumlah Ayam', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.quantity != null ? '${Convert.toCurrencyWithoutDecimal(controller.realization.quantity.toString(), '', '.')} Ekor' : '-',
                                style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Total Tonase', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.tonnage != null ? '${Convert.toCurrencyWithDecimalAndPrecision(controller.realization.tonnage.toString(), '', '.', ',', 1)} Kg' : '-',
                                style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ]),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Berat Rata-rata', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(controller.realization.averageChickenWeighed != null ? '${Convert.toCurrencyWithDecimalAndPrecision(controller.realization.averageChickenWeighed!.toString(), '', '.', ',', 1)} Kg' : '-',
                                style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ])
                        ])),
                    const SizedBox(height: 16),
                    Column(
                        children: List.generate(controller.realization.records.isNotEmpty ? controller.realization.records.length : 0, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            controller.realization.records[index] != null && controller.realization.records[index]!.image != null ? controller.realization.records[index]!.image! : '',
                            width: MediaQuery.of(context).size.width - 36,
                            height: MediaQuery.of(context).size.width / 2,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    }))
                  ]))));
  }
}
