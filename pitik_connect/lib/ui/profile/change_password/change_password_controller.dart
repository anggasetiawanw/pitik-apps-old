
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/password_field/password_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/password_model.dart';

import '../../../route.dart';


/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 28/07/23
 */

class ChangePasswordController extends GetxController {
    BuildContext context;

    ChangePasswordController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;
    bool isFromLogin = false;

    late ButtonFill bfYesRegBuilding;
    late ButtonOutline boNoRegBuilding;
    late PasswordField efOldPassword = PasswordField(
        controller: GetXCreator.putPasswordFieldController(
            "efOldPassword"),
        label: "Kata sandi saat ini",
        hint: "Tulis kata sandi saat ini",
        alertText: "Kata sandi saat ini tidak boleh kosong",
        maxInput: 20, onTyping: (value ) { 
            if (value.isEmpty){
                efOldPassword.controller.showAlert();
            }
        }
    );
   late PasswordField efNewPassword = PasswordField(controller: GetXCreator.putPasswordFieldController("efNewPassword"), label:
    "Kata sandi baru", hint: "Tulis kata sandi baru", alertText: "Kata sandi baru tidak boleh kosong", maxInput: 29, onTyping: (value) {
        RegExp regexLength = RegExp(r'^.{7,}$');
        RegExp regexPassword = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])');
        if (value.isEmpty){
            efNewPassword.controller.showAlert();
            efNewPassword.controller.hideAlertLength();
            efNewPassword.controller.hideAlertPassword();
        } else {
            efNewPassword.controller.hideAlert();
            efNewPassword.controller.showAlertLength();
            efNewPassword.controller.showAlertPassword();
            if (regexLength.hasMatch(value)){
                efNewPassword.controller.beGoodLength();
            } else {
                efNewPassword.controller.beBadLength();
            }
            if (regexPassword.hasMatch(value)){
                efNewPassword.controller.beGoodPassword();
            } else {
                efNewPassword.controller.beBadPassword();
            }
        }
    },);
    late PasswordField efConfNewPassword = PasswordField(
        controller: GetXCreator.putPasswordFieldController(
            "efConfNewPassword"),
        label: "Konfirmasi kata sandi baru",
        hint: "Konfirmasi kata sandi",
        alertText: "Konfirmasi kata sandi tidak boleh kosong",
        maxInput: 20, onTyping: (value ) { 
            if (value.isEmpty){
                efConfNewPassword.controller.showAlert();
            }
         },
    );


    @override
    void onInit() {
        super.onInit();
        isFromLogin = Get.arguments;
        // isLoading.value = true;
         boNoRegBuilding = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoRegBuilding"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );
        bfYesRegBuilding = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesRegBuilding"),
            label: "Ya",
            onClick: () {
                changePassword();
            },
        );

    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
    }

    /// The function `validation()` checks if three password fields are empty and
    /// returns a list indicating if the validation was successful and an error
    /// message if applicable.
    ///
    /// Returns:
    ///   The function `validation()` returns a list containing two elements: a
    /// boolean value and an empty string.
    List validation() {
        List ret = [true, ""];

        if (efOldPassword
            .getInput()
            .isEmpty) {
            efOldPassword.controller.showAlert();
            Scrollable.ensureVisible(
                efOldPassword.controller.formKey.currentContext!);
            return ret = [false, ""];
        }else if (efNewPassword
            .getInput()
            .isEmpty) {
            efNewPassword.controller.showAlert();
            Scrollable.ensureVisible(
                efNewPassword.controller.formKey.currentContext!);
            return ret = [false, ""];
        }else if (efConfNewPassword
            .getInput()
            .isEmpty) {
                efConfNewPassword.alertText = "Password Harus Di Isi";
            efConfNewPassword.controller.showAlert();
            Scrollable.ensureVisible(
                efConfNewPassword.controller.formKey.currentContext!);
            return ret = [false, ""];
        }else if(efConfNewPassword.getInput() != efNewPassword
            .getInput()){
            efConfNewPassword.alertText = "Konfirmasi kata sandi tidak boleh kosong";
            efConfNewPassword.controller.showAlert();
        }
        return ret;
    }

    /// The function generates a payload containing an old password, a new password,
    /// and a confirmation password.
    ///
    /// Returns:
    ///   A Password object is being returned.
    Password generatePayload(){
        return Password(oldPassword: efOldPassword.getInput(), newPassword: efNewPassword.getInput(), confirmationPassword: efConfNewPassword.getInput());
    }

    /// The function `changePassword()` is responsible for handling the logic to
    /// change a user's password, including validation, making an API request, and
    /// handling different response scenarios.
    void changePassword() {
        Get.back();
        List ret = validation();
        if (ret[0]) {
            isLoading.value = true;
            try {
                Password payload = generatePayload();
                Service.push(
                    service: ListApi.changePassword,
                    context: context,
                    body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId,
                        ListApi.pathChangePassword(),
                        Mapper.asJsonString(payload)],
                    listener:ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if(isFromLogin){
                                Get.offAllNamed(RoutePage.homePage);
                            } else {
                                Get.back();
                            } 
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP,
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert","Terjadi kesalahan internal", snackPosition: SnackPosition.TOP,
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onTokenInvalid: GlobalVar.invalidResponse()
                    ),
                );
            } catch (e,st) {
                Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 5),
                    backgroundColor: Color(0xFFFF0000),
                    colorText: Color(0xFFFFFFFF));
            }

        }
    }

}

class ChangePasswordBindings extends Bindings {
    BuildContext context;

    ChangePasswordBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => ChangePasswordController(context: context));
    }
}

