import 'package:components/library/dao_impl_library.dart';
import 'package:dao_impl/user_google_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:model/auth_model.dart';
import 'package:model/error/error.dart';
import 'package:model/profile.dart';
import 'package:model/token_device.dart';
import 'package:model/user_google_model.dart';
import 'package:model/x_app_model.dart';
import 'package:pitik_internal_app/api_mapping/api_mapping.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/route.dart';

class Constant {
  static String? mDeviceId;
  static String? mSerial;
  static String? mAndroidId;
  static String? mPlatformVersion;
  static int versionSql = 8;
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
  static var isScFleet = false.obs;
  static const double bottomSheetMargin = 24;
  static TokenDevice? tokenDevice;
  static RxString pushNotifPayload = "".obs;

  static Mixpanel? mixpanel;

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
    return () async {
      Get.offAllNamed(RoutePage.loginPage);
      Service.push(
          apiKey: ApiMapping.userApi,
          service: ListApi.deleteDevice,
          context: Get.context!,
          body: [auth!.token, auth!.id, "v2/devices/${tokenDevice!.id}"],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {},
              onResponseFail: (code, message, body, id, packet) {
                Get.snackbar(
                  "Pesan",
                  "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
              onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                  "Pesan",
                  "Terjadi Kesalahan Internal",
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
              onTokenInvalid: (){}));
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
      isSalesLead.value = false;
    };
  }

  static String getTypePotongan(String type) {
    switch (type) {
      case "REGULAR":
        return "Potong Biasa";
      case "BEKAKAK":
        return "Bekakak";
      case "UTUH":
        return "Utuh";
      default:
        return "Potong Biasa";
    }
  }

  static bool havePotongan(String? categoryName) {
    switch (categoryName) {
      case AppStrings.BRANGKAS:
        return true;
      case AppStrings.AYAM_UTUH:
        return true;
      case AppStrings.KARKAS:
        return true;
    }
    return false;
  }

  /// The function initializes Mixpanel with a token and sets base properties, and
  /// if a user profile exists, it identifies the user and sets their name and
  /// email.
  ///
  /// Args:
  ///   token (String): The "token" parameter is a string that represents the
  /// Mixpanel project token. This token is used to identify and connect your
  /// application to a specific Mixpanel project.
  ///   baseProperties (Map<String, dynamic>): The `baseProperties` parameter is a
  /// map that contains key-value pairs representing the base properties that you
  /// want to set for your Mixpanel instance. These properties will be sent with
  /// every event that you track using Mixpanel.
  static void initMixpanel(String token, Map<String, dynamic> baseProperties) async {
    mixpanel = await Mixpanel.init(token, trackAutomaticEvents: true);
    mixpanel!.registerSuperProperties(baseProperties);

    if (profileUser != null) {
      mixpanel!.identify(profileUser!.phoneNumber!);
      mixpanel!.getPeople().set("\$name", profileUser!.phoneNumber!);
      mixpanel!.getPeople().set("\$email", profileUser!.email!);
    }
  }

  /// The function `track` tracks an event using Mixpanel if it is not null.
  ///
  /// Args:
  ///   eventName (String): The eventName parameter is a string that represents
  /// the name of the event that you want to track.
  static void track(String eventName) {
    if (mixpanel != null) {
      mixpanel!.track(eventName);
    }
  }

  /// The function `trackWithMap` tracks an event with Mixpanel using a provided
  /// event name and a map of properties.
  ///
  /// Args:
  ///   eventName (String): The eventName parameter is a String that represents
  /// the name of the event you want to track. It is used to identify the event in
  /// your analytics system.
  ///   map (Map<String, dynamic>): The `map` parameter is a `Map` object that
  /// contains key-value pairs. The keys represent property names, and the values
  /// represent the corresponding property values. These properties are additional
  /// data that you want to include when tracking the event with Mixpanel.
  static void trackWithMap(String eventName, Map<String, dynamic> map) {
    if (mixpanel != null) {
      mixpanel!.track(eventName, properties: map);
    }
  }

  /// The function `trackWithMap` tracks an event with Mixpanel using a provided
  /// event name and a map of properties.
  ///
  /// Args:
  ///   eventName (String): The eventName parameter is a String that represents
  /// the name of the event you want to track. It is used to identify the event in
  /// your analytics system.
  ///   map (Map<String, dynamic>): The `map` parameter is a `Map` object that
  /// contains key-value pairs. The keys represent property names, and the values
  /// represent the corresponding property values. These properties are additional
  /// data that you want to include when tracking the event with Mixpanel.
  static void trackRenderTime(String pageName, Duration totalTime) {
    if (mixpanel != null) {
      mixpanel!.track("Render_Time", properties: {'Page': pageName, 'value': "${totalTime.inHours} hours : ${totalTime.inMinutes} minutes : ${totalTime.inSeconds} seconds : ${totalTime.inMilliseconds} miliseconds"});
    }
  }

  /// The function sends the render time of a page to Mixpanel with the page name
  /// and the total time in hours, minutes, seconds, and milliseconds.
  ///
  /// Args:
  ///   page (String): The "page" parameter represents the name or identifier of
  /// the page for which the render time is being tracked. It is used to identify
  /// the specific page in the Mixpanel event.
  ///   timeStart (DateTime): The start time of the rendering process.
  ///   timeEnd (DateTime): The time when the rendering process ends.
  static void sendRenderTimeMixpanel(String page, DateTime timeStart, DateTime timeEnd) {
    Duration totalTime = timeEnd.difference(timeStart);
    trackWithMap("Render_Time", {'Page': page, 'value': "${totalTime.inHours} hours : ${totalTime.inMinutes} minutes : ${totalTime.inSeconds} seconds : ${totalTime.inMilliseconds} miliseconds"});
  }
}
