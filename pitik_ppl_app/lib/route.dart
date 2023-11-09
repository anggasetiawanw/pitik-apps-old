

import 'package:common_page/profile/about_us_screen.dart';
import 'package:common_page/profile/change_password/change_pass_activity.dart';
import 'package:common_page/profile/change_password/change_password_controller.dart';
import 'package:common_page/profile/help_screen.dart';
import 'package:common_page/profile/license_screen.dart';
import 'package:common_page/profile/privacy/privacy_screen.dart';
import 'package:common_page/profile/privacy/privacy_screen_controller.dart';
import 'package:common_page/profile/term_screen.dart';
import 'package:common_page/smart_controller/monitoring/smart_monitor_controller.dart';
import 'package:common_page/smart_controller/monitoring/smart_monitor_controller_activity.dart';
import 'package:components/global_var.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/boarding_activity.dart';
import 'package:pitik_ppl_app/ui/coop/coop_activity.dart';
import 'package:pitik_ppl_app/ui/coop/coop_controller.dart';
import 'package:pitik_ppl_app/ui/coop_dashboard/coop_dashboard_activity.dart';
import 'package:pitik_ppl_app/ui/coop_dashboard/coop_dashboard_controller.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_detail/daily_report_detail_activity.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_detail/daily_report_detail_controller.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_form/daily_report_form_activity.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_form/daily_report_form_controller.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_home/daily_report_home_activity.dart';
import 'package:pitik_ppl_app/ui/daily_report/daily_report_home/daily_report_home_controller.dart';
import 'package:pitik_ppl_app/ui/doc_in/doc_in_activity.dart';
import 'package:pitik_ppl_app/ui/doc_in/doc_in_controller.dart';
import 'package:pitik_ppl_app/ui/gr_confirmation/gr_confirmation_activity.dart';
import 'package:pitik_ppl_app/ui/gr_confirmation/gr_confirmation_controller.dart';
import 'package:pitik_ppl_app/ui/login/login_activity.dart';
import 'package:pitik_ppl_app/ui/login/login_controller.dart';
import 'package:pitik_ppl_app/ui/order/list_order_activity.dart';
import 'package:pitik_ppl_app/ui/order/list_order_controller.dart';
import 'package:pitik_ppl_app/ui/order/order_detail/order_detail_activity.dart';
import 'package:pitik_ppl_app/ui/order/order_detail/order_detail_controller.dart';
import 'package:pitik_ppl_app/ui/order/order_request/order_request_activity.dart';
import 'package:pitik_ppl_app/ui/order/order_request/order_request_controller.dart';
import 'package:pitik_ppl_app/ui/req_doc_in/req_doc_in_activity.dart';
import 'package:pitik_ppl_app/ui/req_doc_in/req_doc_in_controller.dart';
import 'package:pitik_ppl_app/ui/smart_controller/smart_controller_list_activity.dart';
import 'package:pitik_ppl_app/ui/smart_controller/smart_controller_list_controller.dart';
import 'package:pitik_ppl_app/ui/splash_screen/splash_screen.dart';
import 'package:pitik_ppl_app/ui/splash_screen/splash_screen_controller.dart';
import 'package:pitik_ppl_app/ui/transfer/list_transfer_activity.dart';
import 'package:pitik_ppl_app/ui/transfer/list_transfer_controller.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_detail/transfer_detail_activity.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_detail/transfer_detail_controller.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_request/transfer_request_activity.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_request/transfer_request_controller.dart';
import 'package:common_page/smart_controller/detail_smartcontroller_activity.dart';
import 'package:common_page/smart_controller/detail_smartcontroller_controller.dart';
import 'package:common_page/smart_scale/list_smart_scale/list_smart_scale_activity.dart';
import 'package:common_page/smart_scale/list_smart_scale/list_smart_scale_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class AppRoutes {
    static const initial = RoutePage.splashPage;

    static final page = [
        GetPage(name: RoutePage.splashPage, page: () => const SplashScreenActivity(), binding: SplashScreenBindings()),
        GetPage(name: RoutePage.boardingPage, page: () => const BoardingActivity()),
        GetPage(name: RoutePage.loginPage, page: () => const LoginActivity(), binding: LoginBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.coopList, page: () => const CoopActivity(), binding: CoopBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.coopDashboard, page: () => const CoopDashboardActivity(), binding: CoopDashboardBinding(context: GlobalVar.getContext())),

        // Profile Page
        GetPage(name: RoutePage.privacyPage, page: ()=> const PrivacyScreen(), binding: PrivacyScreenBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.termPage, page: ()=> const TermScreen()),
        GetPage(name: RoutePage.aboutPage, page: ()=> const AboutUsScreen()),
        GetPage(name: RoutePage.helpPage, page: ()=> const HelpScreen()),
        GetPage(name: RoutePage.licencePage, page: ()=> const LicenseScreen()),
        GetPage(name: RoutePage.changePasswordPage, page: ()=> const ChangePassword(), binding: ChangePasswordBindings(context: GlobalVar.getContext())),

        // Order Page
        GetPage(name: RoutePage.listOrderPage, page: () => const ListOrderActivity(), binding: ListOrderBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.orderRequestPage, page: () => const OrderRequestActivity(), binding: OrderRequestBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.orderDetailPage, page: () => const OrderDetailActivity(), binding: OrderDetailBinding(context: GlobalVar.getContext())),

        // Transfer Page
        GetPage(name: RoutePage.listTransferPage, page: () => const ListTransferActivity(), binding: ListTransferBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.transferDetailPage, page: () => const TransferDetailActivity(), binding: TransferDetailBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.transferRequestPage, page: () => const TransferRequestActivity(), binding: TransferRequestBinding(context: GlobalVar.getContext())),

        // GR Confirmation Page
        GetPage(name: RoutePage.confirmationReceivedPage, page: () => const GrConfirmationActivity(), binding: GrConfirmationBinding(context: GlobalVar.getContext())),

        // DOC-In Page
        GetPage(name: RoutePage.docInPage, page: () => const DocInActivity(), binding: DocInBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.reqDocInPage, page: ()=> const RequestDocIn(), binding: RequestDocInBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.dailyReport, page: ()=> const DailyReportHomeActivity(), binding: DailyReportHomeBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.dailyReportForm, page: ()=> const DailyReportFormActivity(), binding: DailyReportFormBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.dailyReportDetail, page: ()=> const DailyReportDetailActivity(), binding: DailyReportDetailBindings(context: GlobalVar.getContext())),

        // Smart Controller
        GetPage(name: RoutePage.smartControllerList, page: () => const SmartControllerListActivity(), binding: SmartControllerListBinding(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.smartControllerDashboard, page: () => const SmartControllerDashboard(), binding: DetailSmartControllerBindings(context: GlobalVar.getContext())),
        GetPage(name: RoutePage.smartMonitorController, page: () => const SmartMonitorControllerActivity(), binding: SmartMonitorControllerBinding(context: GlobalVar.getContext())),

        // Smart Scale
        GetPage(name: RoutePage.listSmartScale, page: () => const ListSmartScaleActivity(), binding: ListSmartScaleBinding(context: GlobalVar.getContext())),
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
    static const String listOrderPage = "/listOrder";
    static const String orderRequestPage = "/orderRequest";
    static const String orderDetailPage = "/orderDetail";
    static const String listTransferPage = "/listTransfer";
    static const String transferDetailPage = "/transferDetail";
    static const String transferRequestPage = "/transferRequest";
    static const String confirmationReceivedPage = "/confirmationReceived";
    static const String docInPage = "/docIn";
    static const String reqDocInPage = "/req-docIn";
    static const String dailyReport = "/daily-Report";
    static const String dailyReportForm = "/daily-Report-Form";
    static const String dailyReportDetail = "/daily-Report-Detail";
    static const String smartControllerList = "/smartControllerList";
    static const String smartControllerDashboard = "/smartControllerDashboard";
    static const String smartMonitorController = "/smartMonitorController";
    static const String listSmartScale = "/listSmartScale";
}
