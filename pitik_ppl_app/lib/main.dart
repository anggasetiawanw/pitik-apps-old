import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:model/password_model.dart';

import 'api_mapping/api_mapping.dart';
import 'flavors.dart';
import 'main.reflectable.dart';

void main() async {
  F.appFlavor = Flavor.PROD;
  ChuckerFlutter.showOnRelease = false;
  initializeReflectable();
  await initPlatformState();
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
    );
  }
}

Future<void> initPlatformState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBLite(tables: GlobalVar.tables, version: 2).create;

  await Firebase.initializeApp();
  FirebaseConfig.setupCrashlytics();
  FirebaseConfig.setupRemoteConfig();

  await FirebaseConfig.setupCloudMessaging(webCertificate: F.webCert);
}
