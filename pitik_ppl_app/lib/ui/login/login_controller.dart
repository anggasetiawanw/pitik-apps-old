
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/password_field/password_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/auth_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/auth_response.dart';
import 'package:model/response/profile_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class LoginController extends GetxController {
    BuildContext context;
    LoginController({required this.context});

    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    final EditField phoneNumberField = EditField(
        controller: GetXCreator.putEditFieldController("loginPhoneNumber"),
        label: "Nomor Handphone",
        hint: "08x xxx xxx xxx",
        alertText: "Nomor Handphone tidak boleh kosong..!",
        textUnit: "",
        maxInput: 13,
        inputType: TextInputType.phone,
        onTyping: (text, editField) {}
    );

    final PasswordField passwordField = PasswordField(
        controller: GetXCreator.putPasswordFieldController("loginPassword"),
        label: "Kata Sandi",
        hint: "Masukan password anda",
        alertText: "Kata Sandi tidak boleh kosong..!",
        maxInput: 50,
        onTyping: (text) {}
    );

    void login() {
        if (phoneNumberField.getInput().isEmpty) {
            phoneNumberField.getController().showAlert();
        } else if (passwordField.getInput().isEmpty) {
            passwordField.getController().showAlert();
        } else {
            AlertDialog alert = AlertDialog(
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        CircularProgressIndicator(color: GlobalVar.primaryOrange),
                        const SizedBox(width: 16),
                        Text('Mohon Tunggu...', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                    ],),
            );
            showDialog(
                barrierDismissible: false,
                context: Get.context!,
                builder:(BuildContext context) => alert,
            );

            Service.push(
                apiKey: 'userApi',
                service: ListApi.auth,
                context: Get.context!,
                body: [phoneNumberField.getInput(), passwordField.getInput()],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) => _getProfile((body as AuthResponse).data!, body.data!.action),
                    onResponseFail: (code, message, body, id, packet) {
                        Navigator.pop(Get.context!);
                        Get.snackbar(
                            "Pesan",
                            "${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                        );
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        Navigator.pop(Get.context!);
                        Get.snackbar(
                            "Pesan",
                            "Terjadi kesalahan internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                        );
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        }
    }

    void _getProfile(Auth auth, String? action) {
        Service.push(
            apiKey: 'userApi',
            service: ListApi.profile,
            context: Get.context!,
            body: [auth.token, auth.id],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) async {
                    GlobalVar.auth = auth;
                    GlobalVar.profileUser = (body as ProfileResponse).data;

                    ProfileImpl().save(body.data);
                    AuthImpl().save(auth);

                    Future<bool> isFirstLogin = prefs.then((SharedPreferences prefs) => prefs.getBool('isFirstLogin') ?? true);
                    Navigator.pop(Get.context!);

                    if (await isFirstLogin) {
                        Get.toNamed(RoutePage.privacyPage, arguments: [true, RoutePage.coopList]);
                    } else {
                        // if (action == "DEFAULT_PASSWORD") {
                        //     // showInformation();
                        // } else {
                            Get.offAllNamed(RoutePage.coopList);
                        // }
                    }
                },
                onResponseFail: (code, message, body, id, packet) {
                    Navigator.pop(Get.context!);
                    Get.snackbar(
                        "Pesan",
                        "${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    Navigator.pop(Get.context!);
                    Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onTokenInvalid: () => GlobalVar.invalidResponse()
            )
        );

    }
}

class LoginBinding extends Bindings {
    BuildContext context;
    LoginBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<LoginController>(() => LoginController(context: context));
    }
}