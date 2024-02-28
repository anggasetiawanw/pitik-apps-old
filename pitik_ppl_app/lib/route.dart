import 'package:common_page/profile/about_us_screen.dart';
import 'package:common_page/profile/change_password/change_pass_activity.dart';
import 'package:common_page/profile/change_password/change_password_controller.dart';
import 'package:common_page/profile/forget_password/forget_password_activity.dart';
import 'package:common_page/profile/forget_password/forget_password_controller.dart';
import 'package:common_page/profile/help_screen.dart';
import 'package:common_page/profile/license_screen.dart';
import 'package:common_page/profile/privacy/privacy_screen.dart';
import 'package:common_page/profile/privacy/privacy_screen_controller.dart';
import 'package:common_page/profile/term_screen.dart';
import 'package:common_page/register/register_activity.dart';
import 'package:common_page/register/register_controller.dart';
import 'package:common_page/smart_camera/list_history/smart_camera_list_history_activity.dart';
import 'package:common_page/smart_camera/list_history/smart_camera_list_history_controller.dart';
import 'package:common_page/smart_controller/detail_smartcontroller_activity.dart';
import 'package:common_page/smart_controller/detail_smartcontroller_controller.dart';
import 'package:common_page/smart_controller/monitoring/smart_monitor_controller.dart';
import 'package:common_page/smart_controller/monitoring/smart_monitor_controller_activity.dart';
import 'package:common_page/smart_scale/list_smart_scale/list_smart_scale_activity.dart';
import 'package:common_page/smart_scale/list_smart_scale/list_smart_scale_controller.dart';
import 'package:components/global_var.dart';
import 'package:get/get.dart';

import 'ui/adjustment_product/adjustment_product_activity.dart';
import 'ui/adjustment_product/adjustment_product_controller.dart';
import 'ui/adjustment_product/feed/adjustment_feed_activity.dart';
import 'ui/adjustment_product/feed/adjustment_feed_controller.dart';
import 'ui/adjustment_product/ovk/adjustment_ovk_activity.dart';
import 'ui/adjustment_product/ovk/adjustment_ovk_controller.dart';
import 'ui/boarding_activity.dart';
import 'ui/coop/coop_activity.dart';
import 'ui/coop/coop_controller.dart';
import 'ui/daily_report/daily_report_detail/daily_report_detail_activity.dart';
import 'ui/daily_report/daily_report_detail/daily_report_detail_controller.dart';
import 'ui/daily_report/daily_report_form/daily_report_form_activity.dart';
import 'ui/daily_report/daily_report_form/daily_report_form_controller.dart';
import 'ui/daily_report/daily_report_home/daily_report_home_activity.dart';
import 'ui/daily_report/daily_report_home/daily_report_home_controller.dart';
import 'ui/daily_report/layer_daily_report_detail/layer_daily_report_detail_activity.dart';
import 'ui/daily_report/layer_daily_report_detail/layer_daily_report_detail_controller.dart';
import 'ui/daily_report/layer_daily_report_form/layer_daily_report_form_activity.dart';
import 'ui/daily_report/layer_daily_report_form/layer_daily_report_form_controller.dart';
import 'ui/daily_report/layer_daily_report_revision/layer_daily_report_revision_activity.dart';
import 'ui/daily_report/layer_daily_report_revision/layer_daily_report_revision_controller.dart';
import 'ui/dashboard/coop_dashboard/coop_dashboard_activity.dart';
import 'ui/dashboard/coop_dashboard/coop_dashboard_controller.dart';
import 'ui/dashboard/farming_dashboard/farming_dashboard_activity.dart';
import 'ui/dashboard/farming_dashboard/farming_dashboard_controller.dart';
import 'ui/dashboard/layer_dashboard/layer_dashboard_activity.dart';
import 'ui/dashboard/layer_dashboard/layer_dashboard_controller.dart';
import 'ui/doc_in/doc_in_activity.dart';
import 'ui/doc_in/doc_in_controller.dart';
import 'ui/farm_closing/farm_closing_activity.dart';
import 'ui/farm_closing/farm_closing_controller.dart';
import 'ui/gr_confirmation/gr_confirmation_activity.dart';
import 'ui/gr_confirmation/gr_confirmation_controller.dart';
import 'ui/harvest/harvest_deal/harvest_deal_detail_activity.dart';
import 'ui/harvest/harvest_deal/harvest_deal_detail_controller.dart';
import 'ui/harvest/harvest_realization/detail/harvest_realization_detail_activity.dart';
import 'ui/harvest/harvest_realization/detail/harvest_realization_detail_controller.dart';
import 'ui/harvest/harvest_realization/form/harvest_realization_form_activity.dart';
import 'ui/harvest/harvest_realization/form/harvest_realization_form_controller.dart';
import 'ui/harvest/harvest_submitted/detail/harvest_submitted_detail_activity.dart';
import 'ui/harvest/harvest_submitted/detail/harvest_submitted_detail_controller.dart';
import 'ui/harvest/harvest_submitted/form/harvest_submitted_form_activity.dart';
import 'ui/harvest/harvest_submitted/form/harvest_submitted_form_controller.dart';
import 'ui/harvest/list_harvest/harvest_list_activity.dart';
import 'ui/harvest/list_harvest/harvest_list_controller.dart';
import 'ui/issue_report/issue_report_data/issue_report_data.dart';
import 'ui/issue_report/issue_report_data/issue_report_data_controller.dart';
import 'ui/issue_report/issue_report_form/issue_report_form.dart';
import 'ui/issue_report/issue_report_form/issue_report_form_controller.dart';
import 'ui/login/login_activity.dart';
import 'ui/login/login_controller.dart';
import 'ui/notification/notification_activity.dart';
import 'ui/notification/notification_controller.dart';
import 'ui/order/list_order_activity.dart';
import 'ui/order/list_order_controller.dart';
import 'ui/order/order_detail/order_detail_activity.dart';
import 'ui/order/order_detail/order_detail_controller.dart';
import 'ui/order/order_request/order_request_activity.dart';
import 'ui/order/order_request/order_request_controller.dart';
import 'ui/pullet_in/pullet_in_activity.dart';
import 'ui/pullet_in/pullet_in_controller.dart';
import 'ui/req_doc_in/req_doc_in_activity.dart';
import 'ui/req_doc_in/req_doc_in_controller.dart';
import 'ui/self_registration/add_operator_self_registration/add_operator_self_registration.dart';
import 'ui/self_registration/add_operator_self_registration/add_operator_self_registration_controller.dart';
import 'ui/self_registration/dashboard_self_registration/dashboard_self_registration.dart';
import 'ui/self_registration/dashboard_self_registration/dashboard_self_registration_controller.dart';
import 'ui/self_registration/task_self_registration/task_self_registration.dart';
import 'ui/self_registration/task_self_registration/task_self_registration_controller.dart';
import 'ui/smart_camera/smart_camera_list_day_activity.dart';
import 'ui/smart_camera/smart_camera_list_day_controller.dart';
import 'ui/smart_controller/smart_controller_list_activity.dart';
import 'ui/smart_controller/smart_controller_list_controller.dart';
import 'ui/smart_scale_harvest/detail/smart_scale_harvest_detail_activity.dart';
import 'ui/smart_scale_harvest/detail/smart_scale_harvest_detail_controller.dart';
import 'ui/smart_scale_harvest/form/smart_scale_harvest_form_activity.dart';
import 'ui/smart_scale_harvest/form/smart_scale_harvest_form_controller.dart';
import 'ui/smart_scale_harvest/list/smart_scale_harvest_list_activity.dart';
import 'ui/smart_scale_harvest/list/smart_scale_harvest_list_controller.dart';
import 'ui/splash_screen/splash_screen.dart';
import 'ui/splash_screen/splash_screen_controller.dart';
import 'ui/transfer/list_transfer_activity.dart';
import 'ui/transfer/list_transfer_controller.dart';
import 'ui/transfer/transfer_detail/transfer_detail_activity.dart';
import 'ui/transfer/transfer_detail/transfer_detail_controller.dart';
import 'ui/transfer/transfer_request/transfer_request_activity.dart';
import 'ui/transfer/transfer_request/transfer_request_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class AppRoutes {
  static const initial = RoutePage.splashPage;

  static final page = [
    GetPage(name: RoutePage.splashPage, page: () => const SplashScreenActivity(), binding: SplashScreenBindings()),
    GetPage(name: RoutePage.boardingPage, page: () => const BoardingActivity()),
    GetPage(name: RoutePage.registerPage, page: () => RegisterActivity(privacyPolicyRoute: RoutePage.privacyPage, termRoute: RoutePage.termPage), binding: RegisterBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.loginPage, page: () => const LoginActivity(), binding: LoginBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.farmingDashboard, page: () => const FarmingDashboardActivity(), binding: FarmingDashboardBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.coopList, page: () => const CoopActivity(), binding: CoopBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.coopDashboard, page: () => const CoopDashboardActivity(), binding: CoopDashboardBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.layerDashboard, page: () => const LayerDashboardActivity(), binding: LayerDashboardBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.notification, page: () => const NotificationActivity(), binding: NotificationBindings(context: GlobalVar.getContext())),

    // Profile Page
    GetPage(name: RoutePage.privacyPage, page: () => const PrivacyScreen(), binding: PrivacyScreenBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.termPage, page: () => const TermScreen()),
    GetPage(name: RoutePage.aboutPage, page: () => const AboutUsScreen()),
    GetPage(name: RoutePage.helpPage, page: () => const HelpScreen()),
    GetPage(name: RoutePage.licencePage, page: () => const LicenseScreen()),
    GetPage(name: RoutePage.changePasswordPage, page: () => const ChangePassword(), binding: ChangePasswordBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.forgetPasswordPage, page: () => ForgetPassword(helpRoute: RoutePage.helpPage), binding: ForgetPasswordBindings(context: GlobalVar.getContext())),

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
    GetPage(name: RoutePage.reqDocInPage, page: () => const RequestDocIn(), binding: RequestDocInBindings(context: GlobalVar.getContext())),

    // Daily Report
    GetPage(name: RoutePage.dailyReport, page: () => const DailyReportHomeActivity(), binding: DailyReportHomeBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.dailyReportForm, page: () => const DailyReportFormActivity(), binding: DailyReportFormBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.dailyReportDetail, page: () => const DailyReportDetailActivity(), binding: DailyReportDetailBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.layerDailyReportForm, page: () => const LayerDailyReportFormActivity(), binding: LayerDailyReportFormBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.layerDailyReportDetail, page: () => const LayerDailyReportDetailActivity(), binding: LayerDailyReportDetailBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.layerDailyReportRevision, page: () => const LayerDailyReportRevisionActivity(), binding: LayerDailyReportRevisionBinding(context: GlobalVar.getContext())),

    // Smart Controller
    GetPage(name: RoutePage.smartControllerList, page: () => const SmartControllerListActivity(), binding: SmartControllerListBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.smartControllerDashboard, page: () => const SmartControllerDashboard(), binding: DetailSmartControllerBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.smartMonitorController, page: () => const SmartMonitorControllerActivity(), binding: SmartMonitorControllerBinding(context: GlobalVar.getContext())),

    // Smart Scale
    GetPage(name: RoutePage.listSmartScale, page: () => const ListSmartScaleActivity(), binding: ListSmartScaleBinding(context: GlobalVar.getContext())),

    // Smart Camera
    GetPage(name: RoutePage.listSmartCameraDay, page: () => const SmartCameraListDayActivity(), binding: SmartCameraListDayBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.listSmartCameraHistory, page: () => const SmartCameraListHistoryActivity(), binding: SmartCameraListHistoryBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.listSmartScaleHarvest, page: () => const SmartScaleHarvestListActivity(), binding: SmartScaleHarvestBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.smartScaleHarvestForm, page: () => const SmartScaleHarvestFormActivity(), binding: SmartScaleHarvestFormBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.smartScaleHarvestDetail, page: () => const SmartScaleHarvestDetailActivity(), binding: SmartScaleHarvestDetailBinding(context: GlobalVar.getContext())),

    // Harvest
    GetPage(name: RoutePage.listHarvest, page: () => const HarvestListActivity(), binding: HarvestListBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.harvestSubmittedDetail, page: () => const HarvestSubmittedDetailActivity(), binding: HarvestSubmittedDetailBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.harvestSubmittedForm, page: () => const HarvestSubmittedFormActivity(), binding: HarvestSubmittedFormBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.harvestDealDetail, page: () => const HarvestDealDetailActivity(), binding: HarvestDealDetailBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.harvestRealizationForm, page: () => const HarvestRealizationFormActivity(), binding: HarvestRealizationFormBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.harvestRealizationDetail, page: () => const HarvestRealizationDetailActivity(), binding: HarvestRealizationDetailBinding(context: GlobalVar.getContext())),

    // Farm Closing
    GetPage(name: RoutePage.farmClosing, page: () => const FarmClosingActivity(), binding: FarmClosingBinding(context: GlobalVar.getContext())),

    // Adjustment Product
    GetPage(name: RoutePage.adjustmentFeed, page: () => const AdjustmentFeedActivity(), binding: AdjustmentFeedBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.adjustmentOvk, page: () => const AdjustmentOvkActivity(), binding: AdjustmentOvkBinding(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.adjustmentProduct, page: () => const AdjustmentProductActivity(), binding: AdjustmentProductBinding(context: GlobalVar.getContext())),

    // Self Registration
    GetPage(name: RoutePage.dashboardSelfRegistration, page: () => const DashboardSelfRegistration(), binding: DashboardSelfRegistrationBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.addOperatorSelfRegistration, page: () => const AddOperatorSelfRegistration(), binding: AddOperatorSelfRegistrationBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.addTaskSelfRegistration, page: () => const TaskSelfRegistration(), binding: TaskSelfRegistrationBindings(context: GlobalVar.getContext())),

    // Issue Report
    GetPage(name: RoutePage.issueReport, page: () => const IssueReportActivity(), binding: IssueReportDataBindings(context: GlobalVar.getContext())),
    GetPage(name: RoutePage.issueReportForm, page: () => const IssueReportForm(), binding: IssueReportFormBindings(context: GlobalVar.getContext())),

    // Pullet In
    GetPage(name: RoutePage.pulletInForm, page: () => const PulletInActivity(), binding: PulletInBinding(context: GlobalVar.getContext())),
  ];
}

class RoutePage {
  static const String splashPage = '/';
  static const String boardingPage = '/boarding';
  static const String registerPage = '/registerPage';
  static const String loginPage = '/login';
  static const String farmingDashboard = '/farmingDashboard';
  static const String coopList = '/coopList';
  static const String coopDashboard = '/coopDashboard';
  static const String layerDashboard = '/layerDashboard';
  static const String privacyPage = '/privacy';
  static const String termPage = '/term';
  static const String aboutPage = '/about';
  static const String helpPage = '/help';
  static const String licencePage = '/licence';
  static const String changePasswordPage = '/changePassword';
  static const String forgetPasswordPage = '/forgetPasswordPage';
  static const String listOrderPage = '/listOrder';
  static const String orderRequestPage = '/orderRequest';
  static const String orderDetailPage = '/orderDetail';
  static const String listTransferPage = '/listTransfer';
  static const String transferDetailPage = '/transferDetail';
  static const String transferRequestPage = '/transferRequest';
  static const String confirmationReceivedPage = '/confirmationReceived';
  static const String docInPage = '/docIn';
  static const String reqDocInPage = '/req-docIn';
  static const String dailyReport = '/daily-Report';
  static const String dailyReportForm = '/daily-Report-Form';
  static const String dailyReportDetail = '/daily-Report-Detail';
  static const String layerDailyReportForm = '/layerDailyReportForm';
  static const String layerDailyReportDetail = '/layerDailyReportDetail';
  static const String layerDailyReportRevision = '/layerDailyReportRevision';
  static const String smartControllerList = '/smartControllerList';
  static const String smartControllerDashboard = '/smartControllerDashboard';
  static const String smartMonitorController = '/smartMonitorController';
  static const String listSmartScale = '/listSmartScale';
  static const String listSmartCameraDay = '/listSmartCameraDay';
  static const String listSmartCameraHistory = '/listSmartCameraHistory';
  static const String listHarvest = '/listHarvest';
  static const String listSmartScaleHarvest = '/listSmartScaleHarvest';
  static const String smartScaleHarvestForm = '/smartScaleHarvestForm';
  static const String smartScaleHarvestDetail = '/smartScaleHarvestDetail';
  static const String harvestSubmittedDetail = '/harvestSubmittedDetail';
  static const String harvestSubmittedForm = '/harvestSubmittedForm';
  static const String harvestDealDetail = '/harvestDealDetail';
  static const String harvestRealizationForm = '/harvestRealizationForm';
  static const String harvestRealizationDetail = '/harvestRealizationDetail';
  static const String farmClosing = '/farmClosing';
  static const String notification = '/notificationList';
  static const String adjustmentFeed = '/adjustmentFeed';
  static const String adjustmentOvk = '/adjustmentOvk';
  static const String adjustmentProduct = '/adjustmentProduct';
  static const String dashboardSelfRegistration = '/dashboardSelfRegistration';
  static const String addOperatorSelfRegistration = '/addOperatorSelfRegistration';
  static const String addTaskSelfRegistration = '/addTaskSelfRegistration';
  static const String issueReport = '/issueReport';
  static const String issueReportForm = '/issueReportForm';
  static const String pulletInForm = '/pulletInForm';
}
