import 'package:components/library/dao_impl_library.dart';
import 'package:dao_impl/user_google_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:model/auth_model.dart';
import 'package:model/profile.dart';
import 'package:model/user_google_model.dart';
import 'package:model/x_app_model.dart';
import 'package:pitik_internal_app/utils/route.dart';

class Constant {
    static String? mDeviceId;
    static String? mSerial;
    static String? mAndroidId;
    static String? mPlatformVersion;
    static int versionSql = 6;
    static BuildContext? _globalContext;
    static List<String>? inquiryScan = [];
    static List<dynamic> tables = [Auth, Profile, UserGoogle, XAppId];
    static Auth? auth;
    static UserGoogle? userGoogle;
    static Profile? profileUser;
    static String? xAppId;
    static var isChangeBranch = false.obs;
    static var isDeveloper = false.obs;
    static var isShopKepper = false.obs;
    static var isScRelation = false.obs;
    static var isOpsLead = false.obs;
    static var isSales = false.obs;
    static var isSalesLead = false.obs;
    static const double bottomSheetMargin = 24;

    static set deviceId(String deviceId) {
        mDeviceId = deviceId;
    }

    static String get deviceId {
        return mDeviceId!;
    }

    static set serial(String serial) {
        mSerial = serial;
    }

    static String get serial {
        return mSerial!;
    }

    static set androidId(String androidId) {
        mAndroidId = androidId;
    }

    static String get androidId {
        return mAndroidId!;
    }

    static set platformVersion(String platformVersion) {
        mPlatformVersion = platformVersion;
    }

    static String get platformVersion {
        return mPlatformVersion!;
    }

    /// The function sets the global context for the Dart code.
    ///
    /// Args:
    ///   context (BuildContext): The context parameter is an instance of the BuildContext class. It
    /// represents the location in the widget tree where the current widget is being built. It provides
    /// access to various properties and methods related to the current widget and its ancestors.
    static void setContext(BuildContext context) {
        _globalContext = context;
    }

        /// The `getContext()` method is a static method that returns the global context of the application. It
        /// is used to access the current `BuildContext` from anywhere in the codebase. The global context is
        /// set using the `setContext()` method, which takes a `BuildContext` as a parameter.
    static BuildContext getContext() {
        return _globalContext!;
    }

    /// The function `invalidResponse` returns a callback function that deletes user authentication, Google
    /// user data, and user profile data, and then navigates to the login page.
    ///
    /// Returns:
    ///   A `VoidCallback` is being returned.
    static VoidCallback invalidResponse() {
        return () async{
            Get.offAllNamed(RoutePage.loginPage);
            AuthImpl().delete(null, []);
            UserGoogleImpl().delete(null, []);
            ProfileImpl().delete(null, []);
             GoogleSignIn().disconnect();
             FirebaseAuth.instance.signOut();
            isChangeBranch.value = false;
            isDeveloper.value = false;
            isShopKepper.value = false;
            isScRelation.value = false;
            isOpsLead.value = false;
            isSales.value = false;
            isSalesLead.value= false;
        };
    }

    static String getTypePotongan(String type) {
        switch (type) {
            case "REGULER":
                return "Potong Biasa";
            case "BEKAKAK":
                return "Bekakak";
            case "UTUH":
                return "Potong Utuh";
            default:
                return "Potong Biasa";
        }
    }
}