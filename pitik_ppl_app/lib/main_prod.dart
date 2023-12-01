import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_mapping/api_mapping.dart';
import 'app.dart';
import 'flavors.dart';
import 'main.reflectable.dart';

void main() async {
    F.appFlavor = Flavor.PROD;
    ChuckerFlutter.showOnRelease = false;
    initializeReflectable();
    await initPlatformState();
    Service.setApiMapping(ApiMapping());
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: GlobalVar.primaryOrange));
    runApp(const App());
}

Future<void> initPlatformState() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DBLite(tables: GlobalVar.tables, version: 2).create;

    await Firebase.initializeApp();
    FirebaseConfig.setupCrashlytics();
    FirebaseConfig.setupRemoteConfig();

    String? token = await FirebaseConfig.setupCloudMessaging(webCertificate: F.webCert, splashActivity: RoutePage.splashPage);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firebaseToken', token ?? '-');
}
