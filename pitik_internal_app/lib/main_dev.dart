import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:flutter/material.dart';

import 'api_mapping/api_mapping.dart';
import 'app.dart';
import 'flavors.dart';
import 'main.reflectable.dart';
import 'utils/constant.dart';

void main() async {
  F.appFlavor = Flavor.DEV;
  ChuckerFlutter.showNotification = true;
  ChuckerFlutter.showOnRelease = true;
  initializeReflectable();
  await initPlatformState();
  Service.setApiMapping(ApiMapping());
  runApp(const App());
}

Future<void> initPlatformState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBLite(tables: Constant.tables, version: Constant.versionSql).create;
//   await Firebase.initializeApp();

//   FirebaseConfig.setupCrashlytics();
//   FirebaseConfig.setupRemoteConfig();

//   final String? token = await FirebaseConfig.setupCloudMessaging(webCertificate: F.webCert, splashActivity: RoutePage.splashPage);
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('firebaseToken', token ?? '-');
}
