import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pitik_internal_app/app.dart';
import 'package:pitik_internal_app/flavors.dart';
import 'package:pitik_internal_app/main.reflectable.dart';
import 'package:pitik_internal_app/utils/constant.dart';

void main() async{
    F.appFlavor = Flavor.DEV;
    ChuckerFlutter.showOnRelease = true;
    initializeReflectable();
    await initPlatformState();
    runApp(const App());
}

Future<void> initPlatformState() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DBLite(tables: Constant.tables,version: Constant.versionSql).create;
    await Firebase.initializeApp();

    FirebaseConfig.setupCrashlytics();
    FirebaseConfig.setupRemoteConfig();

    // await FirebaseConfig.setupCloudMessaging();
}