import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/password_field/password_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:dao_impl/x_app_id_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:model/auth_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/auth_response.dart';
import 'package:model/response/profile_response.dart';
import 'package:model/x_app_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/07/23

class LoginController extends GetxController {
  BuildContext context;
  LoginController({required this.context});
  // GoogleSignIn googleSignIn = GoogleSignIn();
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // User? user;
  var isLoading = false.obs;
  String? error;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late Future<bool> isFirstLogin;

  late EditField efNoHp = EditField(
      controller: GetXCreator.putEditFieldController('efNoHp'),
      label: 'Nomor Handphone',
      hint: '08xxxx',
      alertText: 'Nomer Handphone Harus Di Isi',
      textUnit: '',
      inputType: TextInputType.number,
      maxInput: 20,
      action: TextInputAction.next,
      onTyping: (value, control) {});
  late PasswordField efPassword = PasswordField(
    controller: GetXCreator.putPasswordFieldController('efPassword'),
    label: 'Password',
    hint: 'Ketik Kata Sandi',
    alertText: 'Password Harus Di Isi',
    action: TextInputAction.done,
    maxInput: 20,
    onTyping: (value) {},
  );
  late ButtonFill bfLogin = ButtonFill(
    controller: GetXCreator.putButtonFillController('bfLogin'),
    label: 'Masuk',
    onClick: () {
      getAuth();
    },
  );
  late ButtonOutline boRegister = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController('bfRegister'),
    label: 'Daftar',
    onClick: () {
      Get.offNamed(RoutePage.registerAccountPage);
    },
  );

  /// The function `getAuth()` retrieves the appId from Firebase Remote Config,
  /// saves it if it doesn't exist, generates a login payload, and makes an API
  /// call to authenticate the user.
  Future<void> getAuth() async {
    if (validation()) {
      isLoading.value = true;
      String appId = FirebaseRemoteConfig.instance.getString('appId');
      if (appId.isEmpty) {
        appId = FirebaseRemoteConfig.instance.getString('appId');
      }
      if (await XAppIdImpl().getById(appId) == null) {
        await XAppIdImpl().save(XAppId(appId: appId));
      }
      GlobalVar.xAppId = appId;

      // ignore: use_build_context_synchronously
      Service.push(
          apiKey: 'userApi',
          service: ListApi.auth,
          context: context,
          body: [efNoHp.getInput(), efPassword.getInput()],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                GlobalVar.auth = (body as AuthResponse).data;
                AuthImpl().save(body.data);
                getProfile(body.data!, appId, body.data!.action);
              },
              onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.snackbar(
                  'Pesan',
                  'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
              onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                Get.snackbar(
                  'Pesan',
                  'Terjadi kesalahan internal',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
              onTokenInvalid: () => GlobalVar.invalidResponse()));
    }
  }

  /// The function checks if the input fields for phone number and password are
  /// empty and returns true if they are not empty.
  ///
  /// Returns:
  ///   a boolean value. If both `efNoHp.getInput()` and `efPassword.getInput()`
  /// are not empty, the function will return `true`. Otherwise, it will return
  /// `false`.
  bool validation() {
    if (efNoHp.getInput().isEmpty) {
      efNoHp.controller.showAlert();
      Scrollable.ensureVisible(efNoHp.controller.formKey.currentContext!);
      return false;
    }
    if (efPassword.getInput().isEmpty) {
      efPassword.controller.showAlert();
      Scrollable.ensureVisible(efPassword.controller.formKey.currentContext!);
      return false;
    }
    return true;
  }

  /// The `getProfile` function retrieves the user's profile information and
  /// handles the response accordingly.
  ///
  /// Args:
  ///   auth (Auth): The `auth` parameter is an object of type `Auth` which
  /// contains the authentication token and user ID needed for the API request.
  ///   appId (String): The `appId` parameter is a string that represents the ID
  /// of the application. It is used as a parameter in the API request to retrieve
  /// the user's profile information.
  ///
  /// Returns:
  ///   The function does not have a return type specified, so it does not return
  /// anything.
  void getProfile(Auth auth, String appId, String? action) {
    Service.push(
        apiKey: 'userApi',
        service: ListApi.profile,
        context: context,
        body: [
          auth.token,
          auth.id,
          appId,
        ],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) async {
              isLoading.value = false;
              await ProfileImpl().save((body as ProfileResponse).data);
              GlobalVar.profileUser = body.data;
              isFirstLogin = prefs.then((SharedPreferences prefs) {
                return prefs.getBool('isFirstLogin') ?? true;
              });
              if (await isFirstLogin) {
                await Get.toNamed(RoutePage.privacyPage, arguments: true);
              } else {
                if (action == 'DEFAULT_PASSWORD') {
                  showInformation();
                } else {
                  await Get.offAllNamed(RoutePage.homePage);
                }
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = false;
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoading.value = false;
              Get.snackbar(
                'Pesan',
                'Terjadi kesalahan internal',
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onTokenInvalid: () => GlobalVar.invalidResponse()));
  }

  void showInformation() {
    Get.dialog(
        Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'images/error_icon.svg',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Perhatian!',
                      style: GlobalVar.blackTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, decoration: TextDecoration.none),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Kata Sandi bawaan harus segera ganti',
                  style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 32,
                      width: 100,
                      color: Colors.transparent,
                    ),
                    SizedBox(
                      width: 100,
                      child: ButtonFill(controller: GetXCreator.putButtonFillController('Dialog'), label: 'OK', onClick: () => {Get.offAllNamed(RoutePage.changePassPage, arguments: true)}),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }
}

class LoginActivityBindings extends Bindings {
  BuildContext context;

  LoginActivityBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(context: context));
  }
}
