import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'api_mapping/api_mapping.dart';
import 'app.dart';
import 'flavors.dart';
import 'main.reflectable.dart';

void main() async {
  F.appFlavor = Flavor.DEV;
  ChuckerFlutter.showOnRelease = true;
  initializeReflectable();
  await initPlatformState();
  Service.setApiMapping(ApiMapping());
  runApp(const App());
}

Future<void> initPlatformState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBLite(tables: GlobalVar.tables, version: 2).create;

  await Firebase.initializeApp();
  FirebaseConfig.setupCrashlytics();
  FirebaseConfig.setupRemoteConfig();

  // await FirebaseConfig.setupCloudMessaging();
}
