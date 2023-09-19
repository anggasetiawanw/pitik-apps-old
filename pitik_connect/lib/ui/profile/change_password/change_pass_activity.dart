
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../route.dart';
import 'change_password_controller.dart';


///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 02/08/23


class ChangePassword extends GetView<ChangePasswordController> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
      final ChangePasswordController controller = Get.put(ChangePasswordController(
          context: context,
      ));
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
             if(controller.isFromLogin){
                Get.offAllNamed(RoutePage.homePage);
             } else {
                Get.back();
             } 
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: GlobalVar.primaryOrange,
        centerTitle: true,
        title: Text(
          "Ubah Kata Sandi",
          style: GlobalVar.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
        ),
      );
    }

      showBottomDialog(BuildContext context, ChangePasswordController controller) {
          return showModalBottomSheet(
              isScrollControlled: true,
              useRootNavigator: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                  return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                          ),
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  width: 60,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: GlobalVar.outlineColor,
                                      borderRadius: BorderRadius.circular(2),
                                  ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                                  child: Text(
                                      "Apakah kamu yakin data yang dimasukan sudah benar?",
                                      style: GlobalVar.primaryTextStyle
                                          .copyWith(fontSize: 21, fontWeight: GlobalVar.bold),
                                  ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                                  child: const Text(
                                      "Pastikan semua data yang kamu masukan semua sudah benar",
                                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  child: SvgPicture.asset(
                                      "images/ask_bottom_sheet_1.svg",
                                  ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                          Expanded(child: controller.bfYesRegBuilding),
                                          const SizedBox(
                                              width: 16,
                                          ),
                                          Expanded(
                                              child: controller.boNoRegBuilding,
                                          ),
                                      ],
                                  ),
                              ),
                              const SizedBox(height: GlobalVar.bottomSheetMargin,)
                          ],
                      ),
                  );
              });
      }


      Widget bottomNavBar() {
          return Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(20, 158, 157, 157),
                                      blurRadius: 5,
                                      offset: Offset(0.75, 0.0))
                              ],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                          ),
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Expanded(
                                      child: ButtonFill(
                                          controller: GetXCreator.putButtonFillController("saveChangePassword"),
                                          label: "Simpan",
                                          onClick: () {
                                              showBottomDialog(context, controller);
                                          },
                                      )),
                              ],
                          ),
                      ),
                  ],
              ));
      }

      return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: appBar(),
          ),
          body: Stack(
              children: [
                  Obx(() => controller.isLoading.isTrue ? const Center(
                      child: ProgressLoading(),
                  ) :
                  SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.only(top: 16),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text("Kata Sandi Baru", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 8),
                                  Text("Perubahan kata sandi diperlukan untuk meningkatkan keamanan Akun Anda. Kata sandi baru Anda harus menggunakan kombinasi huruf dan angka yang unik dengan jumlah karakter minimum 6 dan maksimum 20.", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),),
                                  controller.efOldPassword,
                                  controller.efNewPassword,
                                  controller.efConfNewPassword,
                                  const SizedBox(
                                      height: 90,
                                  )
                              ],),
                      ),
                  )
                ),bottomNavBar()
                ]

            ),
    );
  }
}