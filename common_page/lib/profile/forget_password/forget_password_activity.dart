// ignore_for_file: must_be_immutable

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forget_password_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ForgetPassword extends GetView<ForgetPasswordController> {
  String helpRoute;
  ForgetPassword({super.key, required this.helpRoute});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordController controller = Get.put(ForgetPasswordController(
      context: context,
    ));
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: GlobalVar.primaryOrange,
        centerTitle: true,
        title: Text(
          "Lupa Kata Sandi",
          style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
        ),
      );
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
                  boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                padding: const EdgeInsets.only(top: 65),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ButtonFill(
                      controller: GetXCreator.putButtonFillController("saveChangePassword"),
                      label: "Kirim",
                      onClick: () {
                        if (controller.validation()) {
                          controller.openWhatsApp();
                        }
                        // showBottomDialog(context, controller);
                      },
                    )),
                  ],
                ),
              ),
            ],
          ));
    }

    Widget textBottom() {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ada masalah ?",
                style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
              ),
              GestureDetector(
                  onTap: () {
                    Get.toNamed(helpRoute);
                  },
                  child: Text(
                    "Bantuan",
                    style: GlobalVar.primaryTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                  )),
              const SizedBox(
                height: 64,
              )
            ],
          ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: appBar(),
      ),
      body: Stack(children: [
        Obx(() => controller.isLoading.isTrue
            ? const ProgressLoading()
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 64,
                      ),
                      Text(
                        "Jangan Sampai Lupa!",
                        style: GlobalVar.primaryTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Masukan nomor hp kamu pada di kolom bawah untuk konfirmasi lupa kata sandi.",
                        style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      controller.efNoHp,
                      bottomNavBar()
                    ],
                  ),
                ),
              )),
        textBottom()
      ]),
    );
  }
}
