import 'package:components/global_var.dart';
import 'package:components/scan_barcodeqr/barcode_scan_activity.dart';
import 'package:components/scan_barcodeqr/barcode_scan_controller.dart';
import 'package:get/get.dart';
import 'package:pitik_connect/ui/dashboard/dashboard_activity.dart';
import 'package:pitik_connect/ui/dashboard/dashboard_controller.dart';
import 'package:pitik_connect/ui/dashboard_device/dashboard_device_activity.dart';
import 'package:pitik_connect/ui/dashboard_device/dashboard_device_controller.dart';
import 'package:pitik_connect/ui/dashboard_fan/dahsboard_fan_activity.dart';
import 'package:pitik_connect/ui/dashboard_fan/dashboard_fan_controller.dart';
import 'package:pitik_connect/ui/dashboard_lamp/dahsboard_lamp_activity.dart';
import 'package:pitik_connect/ui/dashboard_lamp/dashboard_lamp_controller.dart';
import 'package:pitik_connect/ui/detail_smartcamera/detail_smartcamera_activity.dart';
import 'package:pitik_connect/ui/detail_smartcamera/detail_smartcamera_controller.dart';
import 'package:pitik_connect/ui/detail_smartcamera/historical_data_smartcamera/historical_data_smartcamera_activity.dart';
import 'package:pitik_connect/ui/detail_smartcamera/historical_data_smartcamera/historical_data_smartcamera_controller.dart';
import 'package:pitik_connect/ui/detail_smartcamera/take_picture_result/take_picture_result_activity.dart';
import 'package:pitik_connect/ui/detail_smartcamera/take_picture_result/take_picture_result_controller.dart';
import 'package:pitik_connect/ui/detail_smartcontroller/detail_smartcontroller_activity.dart';
import 'package:pitik_connect/ui/detail_smartcontroller/detail_smartcontroller_controller.dart';
import 'package:pitik_connect/ui/detail_smartmonitor/detail_smartmonitor_activity.dart';
import 'package:pitik_connect/ui/detail_smartmonitor/detail_smartmonitor_controller.dart';
import 'package:pitik_connect/ui/login/login_activity.dart';
import 'package:pitik_connect/ui/login/login_controller.dart';
import 'package:pitik_connect/ui/modify_device/modify_device_activity.dart';
import 'package:pitik_connect/ui/modify_device/modify_device_controller.dart';
import 'package:pitik_connect/ui/onboarding/on_boarding_activity.dart';
import 'package:pitik_connect/ui/onboarding/on_boarding_controller.dart';
import 'package:pitik_connect/ui/profile/about_us_screen.dart';
import 'package:pitik_connect/ui/profile/change_password/change_pass_activity.dart';
import 'package:pitik_connect/ui/profile/change_password/change_password_controller.dart';
import 'package:pitik_connect/ui/profile/forget_password/forget_password_activity.dart';
import 'package:pitik_connect/ui/profile/forget_password/forget_password_controller.dart';
import 'package:pitik_connect/ui/profile/help_screen.dart';
import 'package:pitik_connect/ui/profile/license_screen.dart';
import 'package:pitik_connect/ui/profile/privacy_screen.dart';
import 'package:pitik_connect/ui/profile/privacy_screen_controller.dart';
import 'package:pitik_connect/ui/profile/term_screen.dart';
import 'package:pitik_connect/ui/register_account/register_account_activity.dart';
import 'package:pitik_connect/ui/register_account/register_account_controller.dart';
import 'package:pitik_connect/ui/register_coop/register_coop_activity.dart';
import 'package:pitik_connect/ui/register_coop/register_coop_controller.dart';
import 'package:pitik_connect/ui/register_device/register_device_activity.dart';
import 'package:pitik_connect/ui/register_device/register_device_controller.dart';
import 'package:pitik_connect/ui/register_floor/register_floor_activity.dart';
import 'package:pitik_connect/ui/register_floor/register_floor_controller.dart';
import 'package:pitik_connect/ui/setup_alarm/alarm_setup_activity.dart';
import 'package:pitik_connect/ui/setup_alarm/alarm_setup_controller.dart';
import 'package:pitik_connect/ui/setup_cooler/cooler_setup_activity.dart';
import 'package:pitik_connect/ui/setup_cooler/cooler_setup_controller.dart';
import 'package:pitik_connect/ui/setup_fan/fan_setup_activity.dart';
import 'package:pitik_connect/ui/setup_fan/fan_setup_controller.dart';
import 'package:pitik_connect/ui/setup_growth/growth_setup_activity.dart';
import 'package:pitik_connect/ui/setup_growth/growth_setup_controller.dart';
import 'package:pitik_connect/ui/setup_heater/heater_setup_activity.dart';
import 'package:pitik_connect/ui/setup_heater/heater_setup_controller.dart';
import 'package:pitik_connect/ui/setup_lamp/lamp_setup_activity.dart';
import 'package:pitik_connect/ui/setup_lamp/lamp_setup_controller.dart';
import 'package:pitik_connect/ui/setup_reset/reset_time_activity.dart';
import 'package:pitik_connect/ui/setup_reset/reset_time_controller.dart';
import 'package:pitik_connect/ui/smartscale/weighing_smart_scale/smart_scale_weighing.dart';
import 'package:pitik_connect/ui/smartscale/weighing_smart_scale/smart_scale_weighing_controller.dart';
import 'package:pitik_connect/ui/splash/splash_activity.dart';

import '../../ui/smartscale/list_smart_scale/list_smart_scale_activity.dart';
import '../../ui/smartscale/list_smart_scale/list_smart_scale_controller.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */

class AppRoutes {
    static final initial = RoutePage.splashPage;

    static final page = [
        GetPage(name: RoutePage.splashPage, page: () => const SplashActivity()),
        GetPage(name: RoutePage.loginPage,page: () => LoginActivity(),binding: LoginActivityBindings(context: GlobalVar.getContext()),),
        GetPage(name: RoutePage.forgetPassPage, page: ()=> ForgetPassword(), binding: ForgetPasswordBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.onBoardingPage, page: ()=> OnBoarding(), binding: OnBoardingBindings(context: GlobalVar.getContext())),

        //Home Page
        GetPage(name: RoutePage.homePage , page: ()=> DashboardActivity(), binding: DashboardBindings()),
        GetPage(name: RoutePage.licensePage, page: ()=> LicenseScreen()),
        GetPage(name: RoutePage.changePassPage, page: ()=> ChangePassword(), binding: ChangePasswordBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.privacyPage, page: ()=> PrivacyScreen(), binding: PrivacyScreenBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.termPage, page: ()=> TermScreen()),
        GetPage(name: RoutePage.aboutUsPage, page: ()=> AboutUsScreen()),
        GetPage(name: RoutePage.helpPage, page: ()=> HelpScreen()),

        //Register Device Page
        GetPage(name: RoutePage.registerDevicePage , page: ()=> RegisterDevice(), binding: RegisterDeviceBindings(context: GlobalVar.getContext())),

        //Register Account Page
        GetPage(name: RoutePage.registerAccountPage , page: ()=> RegisterAccount(), binding: RegisterAccountBindings(context: GlobalVar.getContext())),

        //Create Coop Page
        GetPage(name: RoutePage.createCoopPage , page: ()=> RegisterCoop(), binding: RegisterCoopBindings(context: GlobalVar.getContext())),

        //Create Floor Page
        GetPage(name: RoutePage.createFloorPage , page: ()=> RegisterFLoor(), binding: RegisterFloorBindings(context: GlobalVar.getContext())),

        //Dashboard Device Page
        GetPage(name: RoutePage.dashboardDevicePage , page: ()=> DashboardDevice(), binding: DashboardDeviceBindings(context: GlobalVar.getContext())),

        GetPage(name: RoutePage.scanBarcode , page: ()=> ScanBarcodeActivity(), binding: ScanBarcodeBindings(context: GlobalVar.getContext())),

        GetPage(name: RoutePage.detailSmartMonitorPage , page: ()=> DetailSmartMonitor(), binding: DetailSmartMonitorBindings(context: GlobalVar.getContext())),

        //Smart Controller
        GetPage(name: RoutePage.detailSmartControllerPage , page: ()=> DetailSmartController(), binding: DetailSmartControllerBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.growthSetupPage , page: ()=> GrowthSetup(), binding: GrowthSetupBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.alarmSetupPage , page: ()=> AlarmSetup(), binding: AlarmSetupBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.coolerSetupPage , page: ()=> CoolerSetup(), binding: CoolerSetupBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.fanSetupPage , page: ()=> FanSetup(), binding: FanSetupBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.fanDashboardPage , page: ()=> DashboardFan(), binding: FanDashboardBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.heaterSetupPage , page: ()=> HeaterSetup(), binding: HeaterSetupBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.lampDashboardPage , page: ()=> DashboardLamp(), binding: LampDashboardBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.lampSetupPage , page: ()=> LampSetup(), binding: LampSetupBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.resetTimePage , page: ()=> ResetTime(), binding: ResetTimeBindings(context: GlobalVar.getContext())),

        GetPage(name: RoutePage.detailSmartCameraPage , page: ()=> DetailSmartCamera(), binding: DetailSmartCameraBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.takePictureSmartCameraPage , page: ()=> TakePictureResult(), binding: TakePictureResultBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.HistorySmartCameraPage , page: ()=> HistoricalDataSmartCamera(), binding: HistoricalDataSmartCameraBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.modifySmartMonitorPage , page: ()=> ModifyDevice(), binding: ModifyDeviceBindings(context: GlobalVar.getContext())),

        // Smart Scale
        GetPage(name: RoutePage.listSmartScalePage , page: ()=> ListSmartScaleActivity(), binding: ListSmartScaleBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.weighingSmartScalePage , page: ()=> SmartScaleWeighing(), binding: SmartScaleWeighingBinding(context: GlobalVar.getContext())),
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
    static const String listSmartScalePage = "/detail-smart-scale";
    static const String takePictureSmartCameraPage = "/take-picture-smart-camera";
    static const String HistorySmartCameraPage = "/history-smart-camera";
    static const String weighingSmartScalePage = "/weighing-smart_scale";
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
