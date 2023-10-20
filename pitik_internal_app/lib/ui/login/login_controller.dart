import 'package:components/button_fill/button_fill.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/password_field/password_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:dao_impl/user_google_impl.dart';
import 'package:dao_impl/x_app_id_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:model/error/error.dart';
import 'package:model/response/auth_response.dart';
import 'package:model/response/internal_app/profile_response.dart';
import 'package:model/user_google_model.dart';
import 'package:model/x_app_model.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginActivityController extends GetxController {
    BuildContext context;
    LoginActivityController({required this.context});
    GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;
    // User? user;
    var isLoading = false.obs;
    String? error;

    var isDemo = false.obs;

    late EditField efUsername = EditField(controller: GetXCreator.putEditFieldController("efUsername"), label: "Username", hint: "Masukan Username", alertText: "Harap masukan username", textUnit: "", maxInput: 50, onTyping: (value,editfield){

    });

    PasswordField efPassword = PasswordField(controller: GetXCreator.putPasswordFieldController("efPassword"), label: "Password", hint: "Masukan Password", alertText: "Harap masukan Password", maxInput: 50, onTyping: (value){

    });

    late ButtonFill bfLogin = ButtonFill(controller: GetXCreator.putButtonFillController("bfSave"), label: "Login", onClick: ()async{
        if(efUsername.getInput().isEmpty) {
            efUsername.controller.showAlert();
            Scrollable.ensureVisible(efUsername.controller.formKey.currentContext!);
            return;
        }
        if(efPassword.getInput().isEmpty) {
            efPassword.controller.showAlert();
            Scrollable.ensureVisible(efPassword.controller.formKey.currentContext!);
            return;
        }
        authLogin(efUsername.getInput(), efPassword.getInput());

    });

    @override
    void onInit(){
        super.onInit();
        bool demo = FirebaseRemoteConfig.instance.getBool("pitik_demo");
        if(demo) {
            isDemo.value = true;
        }
    }

    Future<void> loginWithGmail() async {
        try {
            final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
            final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
            isLoading.value = true;

            AuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleSignInAuthentication.accessToken,
                idToken: googleSignInAuthentication.idToken,
            );

            final UserCredential userCredential = await auth.signInWithCredential(credential);
            Constant.userGoogle = UserGoogle(
                accessToken: userCredential.credential!.accessToken,
                email: userCredential.user!.email
            );
            String appId = FirebaseRemoteConfig.instance.getString("appId");
            if(appId.isEmpty) {
                appId = FirebaseRemoteConfig.instance.getString("appId");
            }
            if(await XAppIdImpl().getById(appId) ==null ) XAppIdImpl().save(XAppId(appId: appId));
            Constant.xAppId = appId;
            // ignore: use_build_context_synchronously
            Service.push(apiKey: 'userApi', service: ListApi.loginWithGoogle, context: context, body: [googleSignInAuthentication.accessToken], 
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Constant.auth = (body as AuthResponse).data;
                    UserGoogleImpl().save(Constant.userGoogle);
                    AuthImpl().save(body.data);
                    Service.push(apiKey: 'userApi', service: ListApi.getSalesProfile, context: context, body: [body.data!.token, body.data!.id, appId], 
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            ProfileImpl().save((body as ProfileResponse).data);
                            Constant.profileUser = body.data;

                            Get.offAllNamed(RoutePage.homePage);
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                            );
                            isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi kesalahan internal",
                                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                            );
                            isLoading.value = false;
                        },
                        onTokenInvalid: () {}
                    ));
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan",
                        "Fail, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                    Get.snackbar("Pesan", "Error, $stacktrace",
                        duration: const Duration(seconds: 5), snackPosition: SnackPosition.TOP);
                },
                onTokenInvalid: Constant.invalidResponse()
            ));
        } catch (err, st) {
            isLoading.value = false;
            Get.snackbar("Pesan", "$st",
                        duration: const Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM);
        }
    }


    void loginWithApple() async {
        try {
            final _ = await SignInWithApple.getAppleIDCredential(
                scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
            );

            // final signInWithAppleEndpoint = Uri(
            //     scheme: 'https',
            //     host: 'flutter-sign-in-with-apple-example.glitch.me',
            //     path: '/sign_in_with_apple',
            //     queryParameters: <String, String>{
            //         'code': credential.authorizationCode,
            //         if (credential.givenName != null) 'firstName': credential.givenName!,
            //         if (credential.familyName != null) 'lastName': credential.familyName!,
            //         'useBundleId': 'true',
            //         if (credential.state != null) 'state': credential.state!,
            //     },
            // );

            // final _ = await http.Client().post(
            //     signInWithAppleEndpoint,
            // );
            Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan Internal",
                        duration: const Duration(seconds: 5),
                snackPosition: SnackPosition.TOP,
            );
        } catch (e) {
            Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan Internal",
                        duration: const Duration(seconds: 5),
                snackPosition: SnackPosition.TOP,
            );
        }
    }

    Future<void> authLogin(String username,String password)async {
        try {
            isLoading.value = true;
            String appId = FirebaseRemoteConfig.instance.getString("appId");
            if(appId.isEmpty) {
                appId = FirebaseRemoteConfig.instance.getString("appId");
            }
            if(await XAppIdImpl().getById(appId) ==null ) XAppIdImpl().save(XAppId(appId: appId));
            Constant.xAppId = appId;
            // ignore: use_build_context_synchronously
            Service.push(apiKey: 'userApi', service: ListApi.login, context: context, body: [username,password], 
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Constant.auth = (body as AuthResponse).data;
                    // UserGoogleImpl().save(Constant.userGoogle);
                    AuthImpl().save(body.data);
                    Service.push(apiKey: 'userApi', service: ListApi.getSalesProfile, context: context, body: [body.data!.token, body.data!.id, appId], 
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            ProfileImpl().save((body as ProfileResponse).data);
                            Constant.profileUser = body.data;
                            Get.offAllNamed(RoutePage.homePage);
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                            );
                            isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi kesalahan internal",
                                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                            );
                            isLoading.value = false;
                        },
                        onTokenInvalid: () {}
                    ));
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan",
                        "Fail, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                    Get.snackbar("Pesan", "Error, $stacktrace",
                        duration: const Duration(seconds: 5), snackPosition: SnackPosition.TOP);
                },
                onTokenInvalid: Constant.invalidResponse()
            ));
        } catch (err, st) {
            isLoading.value = false;
            Get.snackbar("Pesan", "$st",
                        duration: const Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM);
        }
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
