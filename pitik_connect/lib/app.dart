import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/util/internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_connect/route.dart';
import 'package:pitik_connect/ui/beranda/beranda_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StreamInternetConnection.init(showDialog: false);
    GlobalVar.setContext(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat_Medium'),
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
      initialRoute: AppRoutes.initial,
      initialBinding: BerandaBindings(context: context),
      getPages: AppRoutes.page,
    );
  }
}
