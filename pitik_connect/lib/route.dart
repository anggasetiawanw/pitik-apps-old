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
import 'package:pitik_connect/ui/smartscale/detail_smart_scale/detail_smart_scale_activity.dart';
import 'package:pitik_connect/ui/smartscale/detail_smart_scale/detail_smart_scale_controller.dart';
import 'package:pitik_connect/ui/smartscale/weighing_smart_scale/smart_scale_weighing.dart';
import 'package:pitik_connect/ui/smartscale/weighing_smart_scale/smart_scale_weighing_controller.dart';
import 'package:pitik_connect/ui/splash/splash_activity.dart';

import '../../ui/smartscale/list_smart_scale/list_smart_scale_activity.dart';
import '../../ui/smartscale/list_smart_scale/list_smart_scale_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/07/23

class AppRoutes {
  static const initial = RoutePage.splashPage;

  static final page = [
    GetPage(name: RoutePage.splashPage, page: () => const SplashActivity()),
    GetPage(
      name: RoutePage.loginPage,
      page: () => const LoginActivity(),
      binding: LoginActivityBindings(context: GlobalVar.getContext()),
    ),
    GetPage(name: RoutePage.forgetPassPage, page: () => const ForgetPassword(), binding: ForgetPasswordBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.onBoardingPage, page: () => const OnBoarding(), binding: OnBoardingBindings(context: GlobalVar.getContext())),

    //Home Page
    GetPage(name: RoutePage.homePage, page: () => const DashboardActivity(), binding: DashboardBindings()),
    GetPage(name: RoutePage.licensePage, page: () => const LicenseScreen()),
    GetPage(name: RoutePage.changePassPage, page: () => const ChangePassword(), binding: ChangePasswordBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.privacyPage, page: () => const PrivacyScreen(), binding: PrivacyScreenBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.termPage, page: () => const TermScreen()),
    GetPage(name: RoutePage.aboutUsPage, page: () => const AboutUsScreen()),
    GetPage(name: RoutePage.helpPage, page: () => const HelpScreen()),

    //Register Device Page
    GetPage(name: RoutePage.registerDevicePage, page: () => const RegisterDevice(), binding: RegisterDeviceBindings(context: GlobalVar.getContext())),

    //Register Account Page
    GetPage(name: RoutePage.registerAccountPage, page: () => const RegisterAccount(), binding: RegisterAccountBindings(context: GlobalVar.getContext())),

    //Create Coop Page
    GetPage(name: RoutePage.createCoopPage, page: () => const RegisterCoop(), binding: RegisterCoopBindings(context: GlobalVar.getContext())),

    //Create Floor Page
    GetPage(name: RoutePage.createFloorPage, page: () => const RegisterFLoor(), binding: RegisterFloorBindings(context: GlobalVar.getContext())),

    //Dashboard Device Page
    GetPage(name: RoutePage.dashboardDevicePage, page: () => const DashboardDevice(), binding: DashboardDeviceBindings(context: GlobalVar.getContext())),

    GetPage(name: RoutePage.scanBarcode, page: () => const ScanBarcodeActivity(), binding: ScanBarcodeBindings(context: GlobalVar.getContext())),

    GetPage(name: RoutePage.detailSmartMonitorPage, page: () => const DetailSmartMonitor(), binding: DetailSmartMonitorBindings(context: GlobalVar.getContext())),

    //Smart Controller
    GetPage(name: RoutePage.detailSmartControllerPage, page: () => const DetailSmartController(), binding: DetailSmartControllerBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.growthSetupPage, page: () => const GrowthSetup(), binding: GrowthSetupBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.alarmSetupPage, page: () => const AlarmSetup(), binding: AlarmSetupBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.coolerSetupPage, page: () => const CoolerSetup(), binding: CoolerSetupBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.fanSetupPage, page: () => const FanSetup(), binding: FanSetupBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.fanDashboardPage, page: () => const DashboardFan(), binding: FanDashboardBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.heaterSetupPage, page: () => const HeaterSetup(), binding: HeaterSetupBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.lampDashboardPage, page: () => const DashboardLamp(), binding: LampDashboardBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.lampSetupPage, page: () => const LampSetup(), binding: LampSetupBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.resetTimePage, page: () => const ResetTime(), binding: ResetTimeBindings(context: GlobalVar.getContext())),

    GetPage(name: RoutePage.detailSmartCameraPage, page: () => const DetailSmartCamera(), binding: DetailSmartCameraBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.takePictureSmartCameraPage, page: () => const TakePictureResult(), binding: TakePictureResultBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.historySmartCameraPage, page: () => const HistoricalDataSmartCamera(), binding: HistoricalDataSmartCameraBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.modifySmartMonitorPage, page: () => const ModifyDevice(), binding: ModifyDeviceBindings(context: GlobalVar.getContext())),

    // Smart Scale
    GetPage(name: RoutePage.listSmartScalePage, page: () => ListSmartScaleActivity(), binding: ListSmartScaleBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.weighingSmartScalePage, page: () => SmartScaleWeighingActivity(), binding: SmartScaleWeighingBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.detailSmartScalePage, page: () => DetailSmartScaleActivity(), binding: DetailSmartScaleBinding(context: GlobalVar.getContext())),
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
  static const String changePassPage = "/change-password";
  static const String forgetPassPage = "/forget-password";
  static const String licensePage = "/license";
  static const String privacyPage = "/privacy";
  static const String termPage = "/term";
  static const String aboutUsPage = "/about-us";
  static const String helpPage = "/help";
  static const String onBoardingPage = "/on-boarding";
  static const String newPassword = "/new-password";
}
