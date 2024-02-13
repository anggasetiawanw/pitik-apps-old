// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:components/global_var.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/check_version.dart';
import 'package:engine/util/location_permission.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:model/error/error.dart';
import 'package:model/response/internal_app/profile_response.dart';
import 'package:pitik_internal_app/api_mapping/api_mapping.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/flavors.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/deeplink_mapping_argument.dart';
import 'package:pitik_internal_app/utils/enum/role.dart';
import 'package:pitik_internal_app/utils/route.dart';

class BerandaController extends GetxController {
  BuildContext context;
  BerandaController({required this.context});
  var isList = true.obs;
  var isLoading = false.obs;
  RxBool isInit = true.obs;
  Rx<List<String?>> listRole = Rx<List<String?>>([]);
  Rx<List<Map>> module = Rx<List<Map>>([]);
  final List<Map> modules = [
    {"iconPath": "images/pembelian_icon.svg", "nameModule": "Purchase Order", "nameIcon": "Pembelian", "homeRoute": RoutePage.purchasePage}, // Number 0
    {"iconPath": "images/penerimaan_icon.svg", "nameModule": "Goods Received", "nameIcon": "Penerimaan", "homeRoute": RoutePage.receivePage}, // Number 1
    {"iconPath": "images/penjualan_icon.svg", "nameModule": "Sales Order", "nameIcon": "Penjualan", "homeRoute": RoutePage.salesOrderPage}, // Number 2
    {"iconPath": "images/customer_icon.svg", "nameModule": "Customer", "nameIcon": "Customer", "homeRoute": RoutePage.homePageCustomer}, // Number 3
    {"iconPath": "images/pengiriman_icon.svg", "nameModule": "Delivery", "nameIcon": "Pengiriman", "homeRoute": RoutePage.homePageDelivery}, // Number 4
    {"iconPath": "images/persediaan_icon.svg", "nameModule": "Stock", "nameIcon": "Persediaan", "homeRoute": RoutePage.homeStock}, // Number 5
    {"iconPath": "images/transfer_icon.svg", "nameModule": "Internal Transfer", "nameIcon": "Transfer", "homeRoute": RoutePage.homeTransfer}, // Number 6
    {"iconPath": "images/manufaktur_icon.svg", "nameModule": "Manufacturing Order", "nameIcon": "Manufaktur", "homeRoute": RoutePage.homeManufacture}, // Number 7
    {"iconPath": "images/pemusnahan_icon.svg", "nameModule": "Stock Disposal", "nameIcon": "Pemusnahan", "homeRoute": RoutePage.homeTerminate}, // Number 8
  ];

  String mixpanelValue = "";
  //Tracking Variable
  double? latitude = 0;
  double? longitude = 0;
  String? deviceTracking = "";
  String? phoneCarrier = "No Simcard";
  String? osVersion = "";
  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  RxInt countUnreadNotifications = 0.obs;

  CheckVersion checkVersion = CheckVersion(
    appStoreId: F.appStoreId,
    androidAppBundleId: F.androidAppBundleId,
  );

  List<SimCard> simCard = <SimCard>[];
  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
  }

  @override
  void onReady() async {
    super.onReady();
    await checkVersion.check(context);
    getRole();
    getUnreadNotif();
  }

  void refreshHome(BuildContext context) async{
    isLoading.value = true;
    await checkVersion.check(context);
    getRole();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  /// The function `initMobileNumberState` initializes the mobile number state by
  /// retrieving the SIM card information and setting the phone carrier name.
  Future<void> initMobileNumberState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      if (simCard.isNotEmpty) {
        simCard = (await MobileNumber.getSimCards)!;
        phoneCarrier = simCard[0].carrierName;
      }
    } on PlatformException catch (_) {}
  }

  /// The function `initValueMixpanel()` initializes the value for Mixpanel by
  /// checking phone access permission and retrieving carrier information for iOS
  /// devices.
  Future<void> initValueMixpanel() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    if (Platform.isAndroid) {
      // final hasPermission = await handlePermissionPhoneAccess();
      // if (hasPermission) {
      initMobileNumberState();
      // }
    } else if (Platform.isIOS) {
      phoneCarrier = "No Simcard";
    }
    initMixpanel();
  }

  /// The `initMixpanel` function initializes the Mixpanel analytics library,
  /// requests location permission, retrieves the device information, registers
  /// super properties, identifies the user, sets user properties, and tracks
  /// events.
  Future<void> initMixpanel() async {
    final hasPermission = await handleLocationPermission();
    if (hasPermission) {
      const timeLimit = Duration(seconds: 10);
      await FlLocation.getLocation(timeLimit: timeLimit).then((position) async {
        if (position.isMock) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, Gps Mock Detected",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        } else {
          latitude = position.latitude;
          longitude = position.longitude;
        }
      });
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceTracking = androidInfo.model;
      osVersion = Platform.operatingSystemVersion;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceTracking = iosInfo.model;
      osVersion = Platform.operatingSystem;
    }

    Constant.mixpanel = await Mixpanel.init(F.tokenMixpanel, trackAutomaticEvents: true);
    Constant.mixpanel!.registerSuperProperties({
      "Phone_Number": Constant.profileUser!.phoneNumber,
      "Username": Constant.profileUser!.phoneNumber,
      "Location": "$latitude,$longitude",
      "Device": deviceTracking,
      "Phone_Carrier": phoneCarrier,
      "OS": osVersion,
      "Role": Constant.profileUser?.roles?.map((e) => e?.name).toList(),
    });
    Constant.mixpanel!.identify(Constant.profileUser!.phoneNumber!);

    Constant.mixpanel!.getPeople().set("\$name", Constant.profileUser!.phoneNumber!);
    Constant.mixpanel!.getPeople().set("\$email", Constant.profileUser!.email!);

    GlobalVar.mixpanel = Constant.mixpanel;

    Constant.trackWithMap("Open_Beranda", {'Day_Value': 0});
  }

  void checkRoleBranch() {
    String role = FirebaseRemoteConfig.instance.getString("role_change");
    List<String> roles = role.split(",");
    for (var role in Constant.profileUser!.roles!) {
      for (var roleBranch in roles) {
        if (role!.name == roleBranch) {
          Constant.isChangeBranch.value = true;
          Constant.isChangeBranch.refresh();
        }
        if (role.name == RoleEnum.developer) {
          Constant.isDeveloper.value = true;
          Constant.isDeveloper.refresh();
        }
        if (role.name == RoleEnum.shopkeeper) {
          Constant.isShopKepper.value = true;
          Constant.isShopKepper.refresh();
        }
        if (role.name == RoleEnum.scRelation) {
          Constant.isScRelation.value = true;
          Constant.isScRelation.refresh();
        }
        if (role.name == RoleEnum.opsLead) {
          Constant.isOpsLead.value = true;
          Constant.isOpsLead.refresh();
        }
        if (role.name == RoleEnum.sales) {
          Constant.isSales.value = true;
          Constant.isSales.refresh();
        }
        if (role.name == RoleEnum.salesLead) {
          Constant.isSalesLead.value = true;
          Constant.isSalesLead.refresh();
        }
        if (role.name == RoleEnum.scFleet) {
          Constant.isScFleet.value = true;
          Constant.isScFleet.refresh();
        }
      }
    }
  }

  void getRole() {
    Service.push(
        apiKey: 'userApi',
        service: ListApi.getSalesProfile,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              for (var result in (body as ProfileResponse).data!.modules!.downstreamApp) {
                listRole.value.add(result);
              }
              Constant.profileUser = body.data!;
              assignModule();
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
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
            onTokenInvalid: Constant.invalidResponse()));
  }

  void assignModule() async {
    module.value.clear();
    for (var element in modules) {
      if (listRole.value.contains(element['nameModule'])) {
        module.value.add(element);
      }
    }
    module.refresh();
    checkRoleBranch();
    if (isInit.value) {
      await initValueMixpanel();
      checkDeepLink();
      isInit.value = false;

      timeEnd = DateTime.now();
      Duration totalTime = timeEnd.difference(timeStart);
      Constant.trackWithMap("Render_Time", {'Page': "Beranda", 'value': "${totalTime.inHours} hours : ${totalTime.inMinutes} minutes : ${totalTime.inSeconds} seconds : ${totalTime.inMilliseconds} miliseconds"});
    }
    isLoading.value = false;
  }
  void checkDeepLink() {
    if (Constant.pushNotifPayload.isNotEmpty) {
      DeepLinkUtils.process(Constant.pushNotifPayload.value).then((value) => refreshHome(context));
    }
  }
   void getUnreadNotif() {
    Service.push(
        apiKey: ApiMapping.userApi,
        service: ListApi.countUnreadNotifications,
        context: Get.context!,
        body: [Constant.auth!.token, Constant.auth!.id],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              countUnreadNotifications.value = (body.data);
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar("Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}", snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar("Pesan", "Terjadi Kesalahan Internal", snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
            },
            onTokenInvalid: () => Constant.invalidResponse()));
  }
}

class BerandaBindings extends Bindings {
  BuildContext context;
  BerandaBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => BerandaController(context: context));
  }
}
