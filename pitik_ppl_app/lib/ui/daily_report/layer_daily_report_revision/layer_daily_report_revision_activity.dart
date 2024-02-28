import 'package:common_page/library/component_library.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/check_box/check_box_field.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'layer_daily_report_revision_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 01/02/2024
class LayerDailyReportRevisionActivity extends GetView<LayerDailyReportRevisionController> {
  const LayerDailyReportRevisionActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(preferredSize: const Size.fromHeight(120), child: AppBarFormForCoop(title: 'Laporan Harian', coop: controller.coop, titleStartDate: 'Pullet In')),
        bottomNavigationBar: controller.isLoading.isTrue
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]),
                child: controller.bfRevision,
              ),
        body: controller.isLoading.isTrue
            ? const Center(child: ProgressLoading())
            : RawScrollbar(
                thumbColor: GlobalVar.primaryOrange,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(children: [
                      Container(
                          decoration: BoxDecoration(color: GlobalVar.blueBackground, borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(16),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            SvgPicture.asset('images/information_blue_icon.svg'),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text('Pada Form Revisi, anda harus memastikan bahwa semua data yang diisi adalah benar dan revisi data sudah final dimana tidak ada rekayasa apapun yang dilakukan dalam Kandang',
                                    style: TextStyle(color: GlobalVar.blue, fontSize: 14, fontWeight: GlobalVar.medium)))
                          ])),
                      const SizedBox(height: 16),
                      Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: GlobalVar.outlineColor, width: 1)),
                          padding: const EdgeInsets.all(16),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Kenapa anda harus melakukan Revisi?', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                            const SizedBox(height: 8),
                            GestureDetector(
                                onTap: () => controller.stateReasonRevision.value = 0,
                                child: Row(children: [
                                  controller.stateReasonRevision.value == 0 ? SvgPicture.asset('images/on_spin.svg') : SvgPicture.asset('images/off_spin.svg'),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('Perubahan data recording karena adjustment', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)))
                                ])),
                            const SizedBox(height: 16),
                            GestureDetector(
                                onTap: () => controller.stateReasonRevision.value = 1,
                                child: Row(children: [
                                  controller.stateReasonRevision.value == 1 ? SvgPicture.asset('images/on_spin.svg') : SvgPicture.asset('images/off_spin.svg'),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('Recording tidak jelas karena terkena air coretan', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)))
                                ])),
                            const SizedBox(height: 16),
                            GestureDetector(
                                onTap: () => controller.stateReasonRevision.value = 2,
                                child: Row(children: [
                                  controller.stateReasonRevision.value == 2 ? SvgPicture.asset('images/on_spin.svg') : SvgPicture.asset('images/off_spin.svg'),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('Other', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)))
                                ])),
                            const SizedBox(height: 8),
                            controller.stateReasonRevision.value == 2 ? controller.efOtherReasonRevision : const SizedBox()
                          ])),
                      const SizedBox(height: 16),
                      Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: GlobalVar.outlineColor, width: 1)),
                          padding: const EdgeInsets.all(16),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Revisi apa yang anda lakukan?', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                            const SizedBox(height: 16),
                            CheckBoxField(
                                controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckChangeFeedConsumption'),
                                title: 'Ubah Konsumsi Pakan',
                                onTap: (checkBoxController) => controller.updateRevisionReasonList(reason: 'Ubah Konsumsi Pakan', isAdd: checkBoxController.isChecked.value)),
                            const SizedBox(height: 16),
                            CheckBoxField(
                                controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckChangeReVaccination'),
                                title: 'Re-Vaccination',
                                onTap: (checkBoxController) => controller.updateRevisionReasonList(reason: 'Re-Vaccination', isAdd: checkBoxController.isChecked.value)),
                            const SizedBox(height: 16),
                            CheckBoxField(
                                controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckChangePemberianOVK'),
                                title: 'Pemberian OVK',
                                onTap: (checkBoxController) => controller.updateRevisionReasonList(reason: 'Pemberian OVK', isAdd: checkBoxController.isChecked.value)),
                            const SizedBox(height: 16),
                            CheckBoxField(
                                controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckChangePencegahanPenyakit'),
                                title: 'Pencegahan Penyakit',
                                onTap: (checkBoxController) => controller.updateRevisionReasonList(reason: 'Pencegahan Penyakit', isAdd: checkBoxController.isChecked.value)),
                            const SizedBox(height: 16),
                            CheckBoxField(
                                controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckChangeAbw'),
                                title: 'Ubah ABW',
                                onTap: (checkBoxController) => controller.updateRevisionReasonList(reason: 'Ubah ABW', isAdd: checkBoxController.isChecked.value)),
                            const SizedBox(height: 16),
                            CheckBoxField(
                                controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckChangeMortality'),
                                title: 'Ubah Kematian',
                                onTap: (checkBoxController) => controller.updateRevisionReasonList(reason: 'Ubah Kematian', isAdd: checkBoxController.isChecked.value)),
                            const SizedBox(height: 16),
                            CheckBoxField(
                                controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckChangeCulled'),
                                title: 'Ubah Afkir',
                                onTap: (checkBoxController) => controller.updateRevisionReasonList(reason: 'Ubah Afkir', isAdd: checkBoxController.isChecked.value)),
                            const SizedBox(height: 16),
                            CheckBoxField(
                                controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckChangeTotalEggHarvest'),
                                title: 'Ubah jumlah panen telur',
                                onTap: (checkBoxController) => controller.updateRevisionReasonList(reason: 'Ubah jumlah panen telur', isAdd: checkBoxController.isChecked.value))
                          ])),
                      const SizedBox(height: 16),
                      CheckBoxField(
                          controller: GetXCreator.putCheckBoxFieldController('layerDailyRevisionCheckAgree'),
                          title: 'Dengan ini saya menyatakan bahwa benar ada revisi pada kandang ini',
                          onTap: (checkBoxController) {
                            controller.isAgree.value = checkBoxController.isChecked.value;
                            if (checkBoxController.isChecked.isTrue) {
                              controller.bfRevision.controller.enable();
                            } else {
                              controller.bfRevision.controller.disable();
                            }
                          })
                    ])))));
  }
}
