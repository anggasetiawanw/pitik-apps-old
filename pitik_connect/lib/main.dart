import 'dart:async';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_mapping/api_mapping.dart';
import 'firebase_options.dart';
import 'main.reflectable.dart';

Future<void> main() async {
  ChuckerFlutter.showOnRelease = true;

  initializeReflectable();
  initPlatformState();
  Service.setApiMapping(ApiMapping());
  runApp(const PitikApplication());
}

class PitikApplication extends StatelessWidget {
  const PitikApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalVar.setContext(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat_Medium'),
      //   navigatorObservers: [ChuckerFlutter.navigatorObserver],
      // initialRoute: AppRoutes.initial,
      // getPages: AppRoutes.page,
    );
  }


}

Future<void> initPlatformState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBLite(tables: GlobalVar.tables, version: 2).create;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseConfig.setupCrashlytics();
  FirebaseConfig.setupRemoteConfig();

  // String? token = await FirebaseConfig.setupCloudMessaging();
  // print('token firebase -> $token');
}