// ignore_for_file: must_be_immutable

import 'package:common_page/library/component_library.dart';
import 'package:common_page/register/register_controller.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 19/02/2024

class RegisterActivity extends GetView<RegisterController> {
  String privacyPolicyRoute;
  String termRoute;
  RegisterActivity({super.key, required this.privacyPolicyRoute, required this.termRoute});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: AppBarFormForCoop(title: 'Kawan Pitik', coop: Coop(), hideCoopDetail: true)),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(children: [
              Text('Yuk Daftar Kawan Pitik!', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 24, fontWeight: GlobalVar.bold)),
              const SizedBox(height: 8),
              Text('Manfaatkan fitur-fitur Pitik untuk meningkatkan pendapatan dari peternakan kamu.', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
              const SizedBox(height: 16),
              controller.efFullName,
              controller.efEmail,
              controller.efPhoneNumber,
              controller.efBusinessYear,
              const SizedBox(height: 16),
              Text('Tipe Kandang', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.medium)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                    onTap: () => controller.coopTypeState.value = 0,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(8)), color: controller.coopTypeState.value == 0 ? GlobalVar.primaryOrange : GlobalVar.primaryLight),
                        child: Text('Open House', style: TextStyle(color: controller.coopTypeState.value == 0 ? Colors.white : GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium)))),
                const SizedBox(width: 8),
                GestureDetector(
                    onTap: () => controller.coopTypeState.value = 1,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(8)), color: controller.coopTypeState.value == 1 ? GlobalVar.primaryOrange : GlobalVar.primaryLight),
                        child: Text('Semi House', style: TextStyle(color: controller.coopTypeState.value == 1 ? Colors.white : GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium)))),
                const SizedBox(width: 8),
                GestureDetector(
                    onTap: () => controller.coopTypeState.value = 2,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(8)), color: controller.coopTypeState.value == 2 ? GlobalVar.primaryOrange : GlobalVar.primaryLight),
                        child: Text('Close House', style: TextStyle(color: controller.coopTypeState.value == 2 ? Colors.white : GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))))
              ]),
              controller.efCoopCapacity,
              controller.efLocation,
              controller.efAddress,
              const SizedBox(height: 16),
              Text('Kecamatan', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.medium)),
              const SizedBox(height: 8),
              controller.googlePlaceAutoCompleteTextField,
              controller.efCity,
              controller.efProvince,
              const SizedBox(height: 24),
              ButtonFill(controller: GetXCreator.putButtonFillController('registerSend'), label: 'Kirim', onClick: () => controller.saveRegister()),
              ButtonOutline(controller: GetXCreator.putButtonOutlineController('registerClose'), label: 'Batal', onClick: () => Get.back()),
              const SizedBox(height: 16),
              Center(child: Text('Dengan kamu menekan tombol kirim,\nberarti kamu setuju dengan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium), textAlign: TextAlign.center)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () => Get.toNamed(privacyPolicyRoute),
                  child: Text('Kebijakan Privasi', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 12, fontWeight: GlobalVar.bold)),
                ),
                Text(' serta ', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                GestureDetector(
                  onTap: () => Get.toNamed(termRoute),
                  child: Text('Syarat & Ketentuan', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 12, fontWeight: GlobalVar.bold)),
                ),
                Text(' kami', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
              ])
            ]))));
  }
}
