import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/util/internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_asset/pitik_asset.dart';

import 'route.dart';
import 'ui/coop/coop_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StreamInternetConnection.init();
    GlobalVar.setContext(context);
    return GetMaterialApp(
      title: 'Pitik Smart Broiler App',
      debugShowCheckedModeBanner: false,
      theme: PitikTheme.light(ThemeData.light()).themeData,
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
      initialRoute: AppRoutes.initial,
      initialBinding: CoopBindings(context: context),
      getPages: AppRoutes.page,
    );
  }
}
