
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_connect/ui/register_account/register_account_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 07/07/23


class RegisterAccount extends GetView<RegisterAccountController>{
    const RegisterAccount({
        super.key
    });

    @override
    Widget build(BuildContext context) {
        RegisterAccountController controller = Get.put(RegisterAccountController(context: context));

        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                        Navigator.pop(context);
                    }),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title: Text(
                    "Daftar Akun",
                    style: GlobalVar.whiteTextStyle
                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
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
                                            controller: GetXCreator.putButtonFillController("saveAccount"),
                                            label: "Buat Akun",
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
                    Obx(() => controller.isLoading.isTrue ?
                    const Center(
                        child: ProgressLoading(),
                    )
                        :
                    SingleChildScrollView(
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const SizedBox(
                                        height: 20,),
                                   controller.spOrganization,
                                   controller.efName,
                                   controller.efEmail,
                                   controller.efPhoneNumber,
                                   controller.efPassword,
                                   controller.efConfirmPassword,
                                    const SizedBox(
                                        height: 120,
                                    )],
                            ),
                        ),
                    )
                    ),
                    bottomNavBar()
                ],

            ));

    }

    showBottomDialog(BuildContext context, RegisterAccountController controller) {
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
                                margin: const EdgeInsets.only(top: 12),
                                child: SvgPicture.asset(
                                    "images/launcher_logo_pitik_connect.svg"
                                    , width: 148, height: 148
                                ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: controller.bfYesRegDevice),
                                        const SizedBox(
                                            width: 16,
                                        ),
                                        Expanded(
                                            child: controller.boNoRegDevice,
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


}
