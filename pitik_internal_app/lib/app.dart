import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:engine/util/internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pitik_internal_app/ui/home/beranda_activity/beranda_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StreamInternetConnection.init();
    Constant.setContext(context);
    initializeDateFormatting('id_ID', null);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat_Medium',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
      initialRoute: AppRoutes.initial,
      initialBinding: BerandaBindings(context: context),
      getPages: AppRoutes.page,
    );
  }
}
