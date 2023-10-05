

import 'package:get/get.dart';
import 'package:pitik_ppl_app/app.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class AppRoutes {
    static const initial = RoutePage.splashPage;

    static final page = [
        GetPage(name: RoutePage.splashPage, page: () => const App()),
    ];
}

class RoutePage {

    static const String splashPage = "/";
    static const String loginPage = "/login";
    static const String homePage = "/beranda";
    static const String registerDevicePage = "/register-device";
    static const String registerAccountPage = "/register-account";
    static const String createCoopPage = "/create-coop";
    static const String createFloorPage = "/create-floor";
    static const String dashboardDevicePage = "/dashboard-device";
    static const String scanBarcode = "/scan-barcode";
    static const String detailSmartMonitorPage = "/detail-smart-monitor";
    static const String modifySmartMonitorPage = "/modify-smart-monitor";
    static const String detailSmartControllerPage = "/detail-smart-controller";
    static const String detailSmartCameraPage = "/detail-smart-camera";
    static const String listSmartScalePage = "/list-smart-scale";
    static const String takePictureSmartCameraPage = "/take-picture-smart-camera";
    static const String historySmartCameraPage = "/history-smart-camera";
    static const String weighingSmartScalePage = "/weighing-smart_scale";
    static const String detailSmartScalePage = "/detail-smart-scale";
    static const String growthSetupPage = "/growth-form";
    static const String fanSetupPage = "/fan-setup";
    static const String fanDashboardPage = "/fan-dashboard";
    static const String lampDashboardPage = "/lamp-dashboard";
    static const String lampSetupPage = "/lamp-setup";
    static const String heaterSetupPage = "/heater-setup";
    static const String coolerSetupPage = "/cooler-setup";
    static const String alarmSetupPage = "/alarm-setup";
    static const String resetTimePage = "/reset-time-setup";
    static const String changePassPage ="/change-password";
    static const String forgetPassPage ="/forget-password";
    static const String licensePage ="/license";
    static const String privacyPage ="/privacy";
    static const String termPage ="/term";
    static const String aboutUsPage ="/about-us";
    static const String helpPage ="/help";
    static const String onBoardingPage ="/on-boarding";
    static const String newPassword ="/new-password";

}
