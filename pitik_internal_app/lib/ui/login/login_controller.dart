import 'dart:io';

import 'package:components/apple_button/apple_button.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/google_button/google_button.dart';
import 'package:components/password_field/password_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:dao_impl/user_google_impl.dart';
import 'package:dao_impl/x_app_id_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/auth_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/auth_response.dart';
import 'package:model/response/internal_app/profile_response.dart';
import 'package:model/response/token_device_response.dart';
import 'package:model/user_google_model.dart';
import 'package:model/x_app_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_mapping/list_api.dart';
import '../../utils/constant.dart';
import '../../utils/route.dart';

class LoginActivityController extends GetxController {
  BuildContext context;
  LoginActivityController({required this.context});
  final FirebaseAuth auth = FirebaseAuth.instance;
  // User? user;
  var isLoading = false.obs;
  String? error;

  var isDemo = false.obs;

  late EditField efUsername = EditField(controller: GetXCreator.putEditFieldController('efUsername'), label: 'Username', hint: 'Masukan Username', alertText: 'Harap masukan username', textUnit: '', maxInput: 50, onTyping: (value, editfield) {});

  PasswordField efPassword = PasswordField(controller: GetXCreator.putPasswordFieldController('efPassword'), label: 'Password', hint: 'Masukan Password', alertText: 'Harap masukan Password', maxInput: 50, onTyping: (value) {});

  late ButtonFill bfLogin = ButtonFill(
      controller: GetXCreator.putButtonFillController('bfSave'),
      label: 'Login',
      onClick: () async {
        if (efUsername.getInput().isEmpty) {
          efUsername.controller.showAlert();
          await Scrollable.ensureVisible(efUsername.controller.formKey.currentContext!);
          return;
        }
        if (efPassword.getInput().isEmpty) {
          efPassword.controller.showAlert();
          await Scrollable.ensureVisible(efPassword.controller.formKey.currentContext!);
          return;
        }
        await authLogin(efUsername.getInput(), efPassword.getInput());
      });

  late GoogleSignInButton googleLoginButton = GoogleSignInButton(onTapCallback: (accessToken, error) {
    isLoading.value = true;
    if (accessToken == null && error != null) {
      isLoading.value = false;
      Get.snackbar('Pesan', 'Terjadi Kesalahan, $error', duration: const Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM);
    } else {
      loginWithGmail(accessToken!);
    }
  });

  late AppleSignInButton appleLoginButton = AppleSignInButton(onUserResult: (identityToken, error) {
    isLoading.value = true;
    if (identityToken == null && error != null) {
      isLoading.value = false;
      Get.snackbar('Pesan', 'Terjadi Kesalahan, $error', duration: const Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM);
    } else {
      loginWithApple(identityToken!);
    }
  });

  @override
  void onInit() {
    super.onInit();
    final bool demo = FirebaseRemoteConfig.instance.getBool('pitik_demo');
    if (demo) {
      isDemo.value = true;
    }
  }

  Future<void> loginWithGmail(String accessToken) async {
    try {
      Constant.userGoogle = UserGoogle(
        accessToken: accessToken,
      );
      String appId = FirebaseRemoteConfig.instance.getString('appId');
      if (appId.isEmpty) {
        appId = FirebaseRemoteConfig.instance.getString('appId');
      }
      if (await XAppIdImpl().getById(appId) == null) {
        await XAppIdImpl().save(XAppId(appId: appId));
      }
      Constant.xAppId = appId;
      // ignore: use_build_context_synchronously
      Service.push(
          apiKey: 'userApi',
          service: ListApi.loginWithGoogle,
          context: context,
          body: [accessToken],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Constant.auth = (body as AuthResponse).data;
                UserGoogleImpl().save(Constant.userGoogle);
                AuthImpl().save(body.data);
                _sendFirebaseTokenToServer(Auth(token: body.data!.token, id: body.data!.id));
                Service.push(
                    apiKey: 'userApi',
                    service: ListApi.getSalesProfile,
                    context: context,
                    body: [body.data!.token, body.data!.id, appId],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                          ProfileImpl().save((body as ProfileResponse).data);
                          Constant.profileUser = body.data;

                          Get.offAllNamed(RoutePage.homePage);
                          isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                          Get.snackbar(
                            'Pesan',
                            'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                          );
                          isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                          Get.snackbar(
                            'Pesan',
                            'Terjadi kesalahan internal',
                            snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                          );
                          isLoading.value = false;
                        },
                        onTokenInvalid: () {}));
              },
              onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.snackbar(
                  'Pesan',
                  'Fail, ${(body as ErrorResponse).error!.message}',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
              onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                Get.snackbar('Pesan', 'Error, $stacktrace', duration: const Duration(seconds: 5), snackPosition: SnackPosition.TOP);
              },
              onTokenInvalid: Constant.invalidResponse()));
    } catch (err, st) {
      isLoading.value = false;
      Get.snackbar('Pesan', 'Terjadi Kesalah Internal, $err', duration: const Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM);
      await FirebaseCrashlytics.instance.recordError('Errors On Login Google : $err', st, fatal: false);
      await FirebaseCrashlytics.instance.log('Errors On Login Google : $err');
    }
  }

  Future<void> loginWithApple(String identityToken) async {
    try {
      String appId = FirebaseRemoteConfig.instance.getString('appId');
      if (appId.isEmpty) {
        appId = FirebaseRemoteConfig.instance.getString('appId');
      }
      if (await XAppIdImpl().getById(appId) == null) {
        await XAppIdImpl().save(XAppId(appId: appId));
      }
      Constant.xAppId = appId;
      // ignore: use_build_context_synchronously
      Service.push(
          apiKey: 'userApi',
          service: ListApi.loginWithApple,
          context: context,
          body: [identityToken],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Constant.auth = (body as AuthResponse).data;
                AuthImpl().save(body.data);
                Service.push(
                    apiKey: 'userApi',
                    service: ListApi.getSalesProfile,
                    context: context,
                    body: [body.data!.token, body.data!.id, appId],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                          ProfileImpl().save((body as ProfileResponse).data);

                          Constant.profileUser = body.data;

                          Get.offAllNamed(RoutePage.homePage);
                          isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                          Get.snackbar(
                            'Pesan',
                            'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                          );
                          isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                          Get.snackbar(
                            'Pesan',
                            'Terjadi kesalahan internal',
                            snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                          );
                          isLoading.value = false;
                        },
                        onTokenInvalid: () {}));
              },
              onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.snackbar(
                  'Pesan',
                  'Fail, ${(body as ErrorResponse).error!.message}',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
              onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                Get.snackbar('Pesan', 'Error, $stacktrace', duration: const Duration(seconds: 5), snackPosition: SnackPosition.TOP);
              },
              onTokenInvalid: Constant.invalidResponse()));
    } catch (err) {
      isLoading.value = false;
      Get.snackbar('Pesan', 'Terjadi Kesalahan Internal, $err', duration: const Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> authLogin(String username, String password) async {
    try {
      isLoading.value = true;
      String appId = FirebaseRemoteConfig.instance.getString('appId');
      if (appId.isEmpty) {
        appId = FirebaseRemoteConfig.instance.getString('appId');
      }
      if (await XAppIdImpl().getById(appId) == null) {
        await XAppIdImpl().save(XAppId(appId: appId));
      }
      Constant.xAppId = appId;
      // ignore: use_build_context_synchronously
      Service.push(
          apiKey: 'userApi',
          service: ListApi.login,
          context: context,
          body: [username, password],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Constant.auth = (body as AuthResponse).data;
                // UserGoogleImpl().save(Constant.userGoogle);
                _sendFirebaseTokenToServer(Auth(token: body.data!.token, id: body.data!.id));
                AuthImpl().save(body.data);
                Service.push(
                    apiKey: 'userApi',
                    service: ListApi.getSalesProfile,
                    context: context,
                    body: [body.data!.token, body.data!.id, appId],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                          ProfileImpl().save((body as ProfileResponse).data);
                          Constant.profileUser = body.data;
                          Get.offAllNamed(RoutePage.homePage);
                          isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                          Get.snackbar(
                            'Pesan',
                            'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                          );
                          isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                          Get.snackbar(
                            'Pesan',
                            'Terjadi kesalahan internal',
                            snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                          );
                          isLoading.value = false;
                        },
                        onTokenInvalid: () {}));
              },
              onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.snackbar(
                  'Pesan',
                  'Fail, ${(body as ErrorResponse).error!.message}',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
              onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                Get.snackbar('Pesan', 'Error, $stacktrace', duration: const Duration(seconds: 5), snackPosition: SnackPosition.TOP);
              },
              onTokenInvalid: Constant.invalidResponse()));
    } catch (err, st) {
      isLoading.value = false;
      Get.snackbar('Pesan', '$st', duration: const Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _sendFirebaseTokenToServer(Auth auth) async {
    final Map<dynamic, dynamic> deviceInfo = (await DeviceInfoPlugin().deviceInfo).data;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String osVersion = Platform.operatingSystemVersion;

    Service.push(
        apiKey: 'userApi',
        service: ListApi.addDevice,
        context: Get.context!,
        body: [auth.token, auth.id, prefs.getString('firebaseToken') ?? '-', Platform.isAndroid ? 'android' : 'ios', osVersion, deviceInfo['model'] ?? '-'],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(Constant.deviceIdRegister, (body as TokenDeviceResponse).data!.id!);
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                'Pesan',
                '${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi kesalahan internal',
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onTokenInvalid: () => Constant.invalidResponse()));
  }
}

class LoginActivityBindings extends Bindings {
  BuildContext context;
  LoginActivityBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => LoginActivityController(context: context));
  }
}
