import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:engine/util/gps_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:model/password_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_mapping/api_mapping.dart';
import 'app.dart';
import 'flavors.dart';
import 'main.reflectable.dart';
import 'route.dart';

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

  // init GPS
  await GpsUtil.onStream();

  final String? token = await FirebaseConfig.setupCloudMessaging(webCertificate: F.webCert, splashActivity: RoutePage.splashPage);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('firebaseToken', token ?? '-');
}
