

import 'package:components/global_var.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/coop/coop_activity.dart';
import 'package:pitik_ppl_app/ui/coop/coop_controller.dart';
import 'package:pitik_ppl_app/ui/coop_dashboard/coop_dashboard_activity.dart';
import 'package:pitik_ppl_app/ui/coop_dashboard/coop_dashboard_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class AppRoutes {
    static const initial = RoutePage.splashPage;

    static final page = [
        GetPage(name: RoutePage.splashPage, page: () => const CoopActivity(), binding: CoopBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.coopDashboard, page: () => CoopDashboardActivity(), binding: CoopDashboardBinding(context: GlobalVar.getContext()))
    ];
}

class RoutePage {

    static const String splashPage = "/";
    static const String coopDashboard = "/coopDashboard";

}
