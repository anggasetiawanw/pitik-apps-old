import 'dart:async';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/flavors.dart';
import 'package:pitik_ppl_app/main.reflectable.dart';
import 'app.dart';

void main() async {
    F.appFlavor = Flavor.PROD;
    ChuckerFlutter.showOnRelease = false;
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