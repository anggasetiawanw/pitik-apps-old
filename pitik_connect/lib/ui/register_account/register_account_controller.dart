
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/password_field/password_field.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 07/07/23
 */

class RegisterAccountController extends GetxController {
    BuildContext context;
    RegisterAccountController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;


    late ButtonFill bfYesRegDevice;
    late ButtonOutline boNoRegDevice;

    late SpinnerField spOrganization = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("spOrganization"),
        label: "Organisasi/Perusahaan",
        hint: "Pilih Salah Satu",
        alertText: "Organisasi/Perusahaan harus dipilih!",
        items: {},
        onSpinnerSelected: (value) {
        }
    );
    late EditField efName = EditField(
        controller: GetXCreator.putEditFieldController(
            "efName"),
        label: "Nama Lengkap",
        hint: "Ketik disini",
        alertText: "Nama Lengkap harus di isi",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 20,
        onTyping: (value, control) {
        }
    );
    late EditField efEmail = EditField(
        controller: GetXCreator.putEditFieldController(
            "efEmail"),
        label: "E-mail",
        hint: "Ketik disini",
        alertText: "E-mail Lengkap harus di isi",
        textUnit: "",
        inputType: TextInputType.emailAddress,
        maxInput: 20,
        onTyping: (value, control) {
        }
    );

    late EditField efPhoneNumber = EditField(
        controller: GetXCreator.putEditFieldController(
            "efPhoneNumber"),
        label: "Nomor Hp",
        hint: "08xxxxx",
        alertText: "Nomor Hp Lengkap harus di isi",
        textUnit: "",
        inputType: TextInputType.phone,
        maxInput: 20,
        onTyping: (value, control) {
        }
    );

    late PasswordField efPassword = PasswordField(
        controller: GetXCreator.putPasswordFieldController(
            "efPassword"),
        label: "Kata Sandi",
        hint: "Ketik Kata Sandi",
        alertText: "Password Harus Di Isi",
        maxInput: 20, onTyping: (String ) {  },
    );

    late PasswordField efConfirmPassword = PasswordField(
        controller: GetXCreator.putPasswordFieldController(
            "efConfirmPassword"),
        label: "Konfirmasi Kata Sandi",
        hint: "Ketik Kata Sandi",
        alertText: "Konfirmasi Password Harus Di Isi",
        maxInput: 20, onTyping: (String ) {  },
    );

    @override
    void onInit() {
        super.onInit();
        // isLoading.value = true;
        boNoRegDevice = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoRegDevice"),
            label: "Tidak",
            onClick: () {
                Get.back();
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
        bfYesRegDevice = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesRegDevice"),
            label: "Ya",
            onClick: () {
            },
        );
    }


}

class RegisterAccountBindings extends Bindings {
    BuildContext context;
    RegisterAccountBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => RegisterAccountController(context: context));
    }


}