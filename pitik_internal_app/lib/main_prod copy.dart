import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pitik_internal_app/api_mapping/api_mapping.dart';
import 'package:pitik_internal_app/flavors.dart';
import 'package:pitik_internal_app/main.reflectable.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main() async{
    F.appFlavor = Flavor.PROD;
    ChuckerFlutter.showNotification = false;
    ChuckerFlutter.showOnRelease = true;
    initializeReflectable();
    await initPlatformState();
    Service.setApiMapping(ApiMapping());
    runApp(const App());
}

Future<void> initPlatformState() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DBLite(tables: Constant.tables,version: Constant.versionSql).create;
    await Firebase.initializeApp();

    FirebaseConfig.setupCrashlytics();
    FirebaseConfig.setupRemoteConfig();

    String? token = await FirebaseConfig.setupCloudMessaging(webCertificate: F.webCert, splashActivity: RoutePage.splashPage);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firebaseToken', token ?? '-');
}