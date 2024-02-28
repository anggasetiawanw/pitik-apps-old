import 'dart:io';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/password_field/password_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:engine/model/string_model.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/auth_model.dart';
import 'package:model/error/error.dart';
import 'package:model/profile.dart';
import 'package:model/response/auth_response.dart';
import 'package:model/response/profile_response.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class LoginController extends GetxController {
  BuildContext context;
  LoginController({required this.context});

  int startTime = DateTime.now().millisecondsSinceEpoch;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  final EditField phoneNumberField = EditField(
      controller: GetXCreator.putEditFieldController('loginPhoneNumber'),
      label: 'Nomor Handphone',
      hint: '08x xxx xxx xxx',
      alertText: 'Nomor Handphone tidak boleh kosong..!',
      textUnit: '',
      maxInput: 13,
      inputType: TextInputType.phone,
      onTyping: (text, editField) {});

  final PasswordField passwordField =
      PasswordField(controller: GetXCreator.putPasswordFieldController('loginPassword'), label: 'Kata Sandi', hint: 'Masukan password anda', alertText: 'Kata Sandi tidak boleh kosong..!', maxInput: 50, onTyping: (text) {});

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      prefs.then((SharedPreferences prefs) => phoneNumberField.setInput(prefs.getString('loginStorePhoneNumber') ?? ''));
      GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'Page': 'Login_Page'});
    });
  }

  void login() {
    if (phoneNumberField.getInput().isEmpty) {
      phoneNumberField.getController().showAlert();
    } else if (passwordField.getInput().isEmpty) {
      passwordField.getController().showAlert();
    } else {
      GlobalVar.track('Click_Masuk');
      final AlertDialog alert = AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: GlobalVar.primaryOrange),
            const SizedBox(width: 16),
            Text('Mohon Tunggu...', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (BuildContext context) => alert,
      );

      Service.push(
          apiKey: 'userApi',
          service: ListApi.auth,
          context: Get.context!,
          body: [phoneNumberField.getInput(), passwordField.getInput()],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                _getProfile((body as AuthResponse).data!, body.data!.action);
              },
              onResponseFail: (code, message, body, id, packet) {
                Navigator.pop(Get.context!);
                Get.snackbar(
                  'Pesan',
                  '${(body as ErrorResponse).error!.message}',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
              onResponseError: (exception, stacktrace, id, packet) {
                Navigator.pop(Get.context!);
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

  Future<void> _sendFirebaseTokenToServer(Auth auth) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final Map<dynamic, dynamic> deviceInfo = (await DeviceInfoPlugin().deviceInfo).data;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Service.push(
        apiKey: 'userApi',
        service: ListApi.addDevice,
        context: Get.context!,
        body: [auth.token, auth.id, prefs.getString('firebaseToken') ?? '-', Platform.isAndroid ? 'android' : 'ios', packageInfo.version, deviceInfo['model'] ?? '-'],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) async {
              final StringModel payload = body as StringModel;
              await prefs.setString('registrationTokenFirebase', payload.data['id']);
            },
            onResponseFail: (code, message, body, id, packet) => Get.snackbar(
                  'Pesan',
                  '${(body as ErrorResponse).error!.message}',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                ),
            onResponseError: (exception, stacktrace, id, packet) => Get.snackbar(
                  'Pesan',
                  'Terjadi kesalahan internal',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                ),
            onTokenInvalid: () => GlobalVar.invalidResponse()));
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

              await ProfileImpl().save(body.data);
              await AuthImpl().save(auth);

              await prefs.then((SharedPreferences prefs) => prefs.setString('loginStorePhoneNumber', body.data != null && body.data!.phoneNumber != null ? body.data!.phoneNumber ?? '' : ''));
              final Future<bool> isFirstLogin = prefs.then((SharedPreferences prefs) => prefs.getBool('isFirstLogin') ?? true);
              Navigator.pop(Get.context!);
              await _sendFirebaseTokenToServer(auth);

              if (await isFirstLogin) {
                await Get.toNamed(RoutePage.privacyPage, arguments: [true, Convert.isUsePplApps(body.data!.userType ?? '') ? RoutePage.coopList : RoutePage.farmingDashboard]);
              } else {
                if (action == 'DEFAULT_PASSWORD') {
                  showInformation(body.data!);
                } else {
                  await Get.offAllNamed(Convert.isUsePplApps(body.data!.userType ?? '') ? RoutePage.coopList : RoutePage.farmingDashboard);
                }
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              Navigator.pop(Get.context!);
              Get.snackbar(
                'Pesan',
                '${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Navigator.pop(Get.context!);
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

  void showInformation(Profile profile) {
    Get.dialog(
        Center(
            child: Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    SvgPicture.asset('images/error_icon.svg', height: 24, width: 24),
                    const SizedBox(width: 10),
                    Text('Perhatian!', style: GlobalVar.blackTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, decoration: TextDecoration.none))
                  ]),
                  const SizedBox(height: 10),
                  Text('Kata Sandi bawaan harus segera ganti', style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none)),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                      height: 32,
                      width: 100,
                      color: Colors.transparent,
                    ),
                    SizedBox(
                        width: 100,
                        child: ButtonFill(
                            controller: GetXCreator.putButtonFillController('Dialog'),
                            label: 'OK',
                            onClick: () => Get.offAllNamed(RoutePage.changePasswordPage, arguments: [true, Convert.isUsePplApps(profile.userType ?? '') ? RoutePage.coopList : RoutePage.farmingDashboard])))
                  ])
                ]))),
        barrierDismissible: false);
  }
}

class LoginBinding extends Bindings {
  BuildContext context;
  LoginBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<LoginController>(() => LoginController(context: context));
}
