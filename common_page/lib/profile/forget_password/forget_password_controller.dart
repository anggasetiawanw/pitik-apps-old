import 'dart:io';

import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ForgetPasswordController extends GetxController {
    BuildContext context;

    ForgetPasswordController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;

    late EditField efNoHp = EditField(
        controller: GetXCreator.putEditFieldController(
            "efNoHpForgetPassword"),
        label: "Nomor Handphone",
        hint: "08xxxx",
        alertText: "Nomer Handphone Tidak Boleh Kosong",
        textUnit: "",
        inputType: TextInputType.number,
        maxInput: 20,
        onTyping: (value, control) {
        }
    );


    /// The function checks if the input for a phone number is empty and shows an
    /// alert if it is, returning false; otherwise, it returns true.
    ///
    /// Returns:
    ///   a boolean value.
    bool validation(){
        if (efNoHp.getInput().isEmpty) {
            efNoHp.controller.showAlert();
            Scrollable.ensureVisible(efNoHp.controller.formKey.currentContext!);
            return false;
        }
        return true;
    }

    /// The function `openWhatsApp()` opens WhatsApp and sends a message with a
    /// forgotten password request, using the provided contact number.
    void openWhatsApp() async{
        var contact = "+6281280709907";
        var androidUrl = "whatsapp://send?phone=$contact&Saya lupa kata sandi untuk Akun ${efNoHp.getInput()}. Minta tolong untuk melakukan penggantian kata sandi";
        var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Saya lupa kata sandi untuk Akun ${efNoHp.getInput()}. Minta tolong untuk melakukan penggantian kata sandi')}";
        try{
            if(Platform.isIOS){
                await launchUrl(Uri.parse(iosUrl));
            }
            else{
                await launchUrl(Uri.parse(androidUrl));
            }
        } on Exception{
            Get.snackbar(
                "Pesan",
                "Aplikasi WhatsApp Tidak Terinstall",
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
            );
        }
    }
}

class ForgetPasswordBindings extends Bindings {
    BuildContext context;

    ForgetPasswordBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => ForgetPasswordController(context: context));
    }
}

