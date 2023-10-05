import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:components/global_var.dart';
import 'package:engine/util/internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/route.dart';

class App extends StatelessWidget {
    const App({super.key});

    @override
    Widget build(BuildContext context) {
        StreamInternetConnection.init();
        GlobalVar.setContext(context);
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Montserrat_Medium'),
            navigatorObservers: [ChuckerFlutter.navigatorObserver],
            initialRoute: AppRoutes.initial,
            // initialBinding: BerandaBindings(context: context),
            getPages: AppRoutes.page,
        );
    }
}