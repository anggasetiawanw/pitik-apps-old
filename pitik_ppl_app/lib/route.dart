

import 'package:common_page/profile/about_us_screen.dart';
import 'package:common_page/profile/change_password/change_pass_activity.dart';
import 'package:common_page/profile/change_password/change_password_controller.dart';
import 'package:common_page/profile/help_screen.dart';
import 'package:common_page/profile/license_screen.dart';
import 'package:common_page/profile/privacy/privacy_screen.dart';
import 'package:common_page/profile/privacy/privacy_screen_controller.dart';
import 'package:common_page/profile/term_screen.dart';
import 'package:common_page/smart_monitor/detail_smartmonitor_activity.dart';
import 'package:common_page/smart_monitor/detail_smartmonitor_controller.dart';
import 'package:components/global_var.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/boarding_activity.dart';
import 'package:pitik_ppl_app/ui/coop/coop_activity.dart';
import 'package:pitik_ppl_app/ui/coop/coop_controller.dart';
import 'package:pitik_ppl_app/ui/coop_dashboard/coop_dashboard_activity.dart';
import 'package:pitik_ppl_app/ui/coop_dashboard/coop_dashboard_controller.dart';
import 'package:pitik_ppl_app/ui/login/login_activity.dart';
import 'package:pitik_ppl_app/ui/login/login_controller.dart';
import 'package:pitik_ppl_app/ui/splash_screen.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class AppRoutes {
    static const initial = RoutePage.splashPage;

    static final page = [
        GetPage(name: RoutePage.splashPage, page: () => const SplashScreenActivity()),
        GetPage(name: RoutePage.boardingPage, page: () => const BoardingActivity()),
        GetPage(name: RoutePage.loginPage, page: () => const LoginActivity(), binding: LoginBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.coopList, page: () => const CoopActivity(), binding: CoopBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.coopDashboard, page: () => const CoopDashboardActivity(), binding: CoopDashboardBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.privacyPage, page: ()=> const PrivacyScreen(), binding: PrivacyScreenBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.termPage, page: ()=> const TermScreen()),
        GetPage(name: RoutePage.aboutPage, page: ()=> const AboutUsScreen()),
        GetPage(name: RoutePage.helpPage, page: ()=> const HelpScreen()),
        GetPage(name: RoutePage.licencePage, page: ()=> const LicenseScreen()),
        GetPage(name: RoutePage.changePasswordPage, page: ()=> const ChangePassword(), binding: ChangePasswordBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.monitorPage, page: ()=> const DetailSmartMonitor(), binding: DetailSmartMonitorBindings(context: GlobalVar.getContext())),
    ];
}

class RoutePage {

    static const String splashPage = "/";
    static const String boardingPage = "/boarding";
    static const String loginPage = "/login";
    static const String coopList = "/coopList";
    static const String coopDashboard = "/coopDashboard";
    static const String privacyPage = "/privacy";
    static const String termPage = "/term";
    static const String aboutPage = "/about";
    static const String helpPage = "/help";
    static const String licencePage = "/licence";
    static const String changePasswordPage = "/changePassword";
    static const String monitorPage = "/monitor";
}
