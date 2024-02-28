import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:engine/dao/db_lite.dart';
import 'package:engine/request/service.dart';
import 'package:engine/util/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api_mapping/api_mapping.dart';
import 'main.reflectable.dart';
import 'utils/constant.dart';
import 'utils/route.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

Future<void> main() async {
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
    Constant.setContext(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat_Medium'),
      //   navigatorObservers: [ChuckerFlutter.navigatorObserver],
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.page,
    );
  }
}

Future<void> initPlatformState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBLite(tables: Constant.tables, version: Constant.versionSql).create;
  await Firebase.initializeApp();

  FirebaseConfig.setupCrashlytics();
  FirebaseConfig.setupRemoteConfig();

  // String? token = await FirebaseConfig.setupCloudMessaging();
  // print('token firebase -> $token');
}
