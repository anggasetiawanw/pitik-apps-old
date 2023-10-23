import 'package:get/get.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_confirm_so/delivery_confirm_so_activity.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_confirm_so/delivery_confirm_so_controller.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_confirm_transer/delivery_confirm_transfer_activity.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_confirm_transer/delivery_confirm_transfer_controller.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_detail_so/delivery_detail_so_activity.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_detail_so/delivery_detail_so_controller.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_detail_transfer/delivery_detail_transfer_activity.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_detail_transfer/delivery_detail_transfer_controller.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_home/delivery_home_activity.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_home/delivery_home_controller.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_return_so/delivert_return_controller.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_return_so/delivery_return_activity.dart';
import 'package:pitik_internal_app/ui/home/dashboard_activity/dashboard_activity.dart';
import 'package:pitik_internal_app/ui/home/dashboard_activity/dashboard_controller.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/about_us_screen.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/change_branch/change_branch.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/change_branch/change_branch_controller.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/help_screen.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/license_screen.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/privacy_screen.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/term_screen.dart';
import 'package:pitik_internal_app/ui/login/login_activity.dart';
import 'package:pitik_internal_app/ui/login/login_controller.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_detail_activity/manufacture_detail_activity.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_detail_activity/manufacture_detail_controller.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_edit_acitivty/manufacture_edit_activity.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_edit_acitivty/manufacture_edit_controller.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_form_acitivty/manufacture_form_activity.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_form_acitivty/manufacture_form_controller.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_home_activity/manufacture_home_activity.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_home_activity/manufacture_home_controller.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_output_activity/manufacture_output_activity.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_output_activity/manufacture_output_controller.dart';
import 'package:pitik_internal_app/ui/purchase_module/data_purchase_activity/data_purchase_activity.dart';
import 'package:pitik_internal_app/ui/purchase_module/data_purchase_activity/data_purchase_controller.dart';
import 'package:pitik_internal_app/ui/purchase_module/detail_purchase_activity/detail_purchase_activity.dart';
import 'package:pitik_internal_app/ui/purchase_module/detail_purchase_activity/detail_purchase_controller.dart';
import 'package:pitik_internal_app/ui/purchase_module/edit_data_purchase_activity/edit_data_purchase_activity.dart';
import 'package:pitik_internal_app/ui/purchase_module/edit_data_purchase_activity/edit_data_purchase_controller.dart';
import 'package:pitik_internal_app/ui/purchase_module/new_data_purchase_activity/new_data_purchase_activity.dart';
import 'package:pitik_internal_app/ui/purchase_module/new_data_purchase_activity/new_data_purchase_controller.dart';
import 'package:pitik_internal_app/ui/receive_module/data_receive_activity/data_receive_activity.dart';
import 'package:pitik_internal_app/ui/receive_module/data_receive_activity/data_receive_controller.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_activity/detail_gr_sales_activity.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_activity/detail_gr_sales_controller.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_purchase/detail_gr_purchase_activity.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_purchase/detail_gr_purchase_controller.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_transfer/detail_gr_transfer_activity.dart';
import 'package:pitik_internal_app/ui/receive_module/detail_receive_transfer/detail_gr_transfer_controller.dart';
import 'package:pitik_internal_app/ui/receive_module/new_data_receive/create_receive_sales.dart';
import 'package:pitik_internal_app/ui/receive_module/new_data_receive/create_receive_sales_controller.dart';
import 'package:pitik_internal_app/ui/receive_module/new_receive_purchase/create_receive_purchase_jagal.dart';
import 'package:pitik_internal_app/ui/receive_module/new_receive_purchase/create_receive_purchase_jagal_controller.dart';
import 'package:pitik_internal_app/ui/receive_module/new_receive_purchase/create_receive_purchase_vendor.dart';
import 'package:pitik_internal_app/ui/receive_module/new_receive_purchase/create_receive_purchase_vendor_controller.dart';
import 'package:pitik_internal_app/ui/receive_module/new_receive_transfer/create_receive_transfer.dart';
import 'package:pitik_internal_app/ui/receive_module/new_receive_transfer/create_receive_transfer_controller.dart';
import 'package:pitik_internal_app/ui/sales_module/customer_detail_activity/customer_detail_activity.dart';
import 'package:pitik_internal_app/ui/sales_module/customer_detail_activity/customer_detail_controller.dart';
import 'package:pitik_internal_app/ui/sales_module/data_visit_activity/data_visit_activity.dart';
import 'package:pitik_internal_app/ui/sales_module/data_visit_activity/data_visit_controller.dart';
import 'package:pitik_internal_app/ui/sales_module/detail_visit_activity/detail_visit_activity.dart';
import 'package:pitik_internal_app/ui/sales_module/detail_visit_activity/detail_visit_controller.dart';
import 'package:pitik_internal_app/ui/sales_module/edit_data_activity/edit_data_activity.dart';
import 'package:pitik_internal_app/ui/sales_module/edit_data_activity/edit_data_controller.dart';
import 'package:pitik_internal_app/ui/sales_module/home_activity/home_activity.dart';
import 'package:pitik_internal_app/ui/sales_module/home_activity/home_controller.dart';
import 'package:pitik_internal_app/ui/sales_module/new_data_activity/new_data_activity.dart';
import 'package:pitik_internal_app/ui/sales_module/new_data_activity/new_data_controller.dart';
import 'package:pitik_internal_app/ui/sales_order_module/edit_data_sales_order/edit_data_sales_order_activity.dart';
import 'package:pitik_internal_app/ui/sales_order_module/edit_data_sales_order/edit_data_sales_order_controller.dart';
import 'package:pitik_internal_app/ui/sales_order_module/new_assign_to_driver/assign_driver.dart';
import 'package:pitik_internal_app/ui/sales_order_module/new_assign_to_driver/assign_driver_controller.dart';
import 'package:pitik_internal_app/ui/sales_order_module/new_book_stock/create_book_stock_activity.dart';
import 'package:pitik_internal_app/ui/sales_order_module/new_book_stock/create_book_stock_controller.dart';
import 'package:pitik_internal_app/ui/sales_order_module/new_sales_order/new_data_sales_order_activity.dart';
import 'package:pitik_internal_app/ui/sales_order_module/new_sales_order/new_data_sales_order_controller.dart';
import 'package:pitik_internal_app/ui/sales_order_module/sales_order_data/sales_order_data_activity.dart';
import 'package:pitik_internal_app/ui/sales_order_module/sales_order_detail/detail_sales_order_activity.dart';
import 'package:pitik_internal_app/ui/sales_order_module/sales_order_detail/detail_sales_order_controller.dart';
import 'package:pitik_internal_app/ui/splash_activity/splash_activity.dart';
import 'package:pitik_internal_app/ui/splash_activity/splash_controller.dart';
import 'package:pitik_internal_app/ui/stock_module/stock_detail_activity/stock_detail_activity.dart';
import 'package:pitik_internal_app/ui/stock_module/stock_detail_activity/stock_detail_controller.dart';
import 'package:pitik_internal_app/ui/stock_module/stock_home_activity/stock_home_activity.dart';
import 'package:pitik_internal_app/ui/stock_module/stock_home_activity/stock_home_controller.dart';
import 'package:pitik_internal_app/ui/stock_module/stock_opname_activity/stock_opname_activity.dart';
import 'package:pitik_internal_app/ui/stock_module/stock_opname_activity/stock_opname_controller.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_detail_activity/terminate_detail_activity.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_detail_activity/terminate_detail_controller.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_form_acitivty/terminate_form_activity.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_form_acitivty/terminate_form_controller.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_home_activity/terminate_home_activity.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_home_activity/terminate_home_controller.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_detail_activity/transfer_detail_activity.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_detail_activity/transfer_detail_controller.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_driver_activity/transfer_driver_activity.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_driver_activity/transfer_driver_controller.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_form_acitivty/transfer_form_activity.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_form_acitivty/transfer_form_controller.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_home_activity/transfer_home_activity.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_home_activity/transfer_home_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class RoutePage {
    static const String splashPage = "/";
    static const String loginPage = "/login";
    static const String homePage = "/beranda";
    static const String licensePage ="/license";
    static const String privacyPage ="/privacy";
    static const String termPage ="/term";
    static const String aboutUsPage ="/about-us";
    static const String helpPage ="/help";
    static const String changeBranch ="/changeBranch";

    //Sales Module
    static const String homePageCustomer = "/homeCustomer";
    static const String customerDetailPage = "/customer-detail";
    static const String visitDetailPage = "/visit-detail";
    static const String newDataCustomer = "/new-customer";
    static const String visitCustomer = "/visit-customer";
    static const String editCustomer = "/edit-customer";

    //Purchase Order
    static const String newDataPurchase = "/new-purchase";
    static const String purchasePage = "/page-purchase";
    static const String purchaseDetailPage = "/purchase-detail";
    static const String purchaseEditPage = "/edit-purchase";

    //Receive Order
    static const String receivePage = "/page-receive";
    static const String grOrderDetail = "/receive-detail";
    static const String grPurchaseDetailPage = "/receive-purchase-detail";
    static const String createGrPurchasePage = "/new-receive-purchase";
    static const String createGrJagalPurchasePage = "/new-receive-jagal-purchase";
    static const String grTransferDetailPage = "/receive-transfer-detail";
    static const String createGrTransferPage = "/new-receive-transfer";
    static const String createGrOrderPage = "/new-receive-order";

    //Sales Order
    static const String salesOrderPage = "/page-sales-order";
    static const String salesOrderDetailPage = "/sales-order-detail";
    static const String newDataSalesOrder = "/new-sales-order";
    static const String newBookStock= "/new-book-stock";
    static const String assignToDriver= "/assign-driver";
    static const String editDataSalesOrder= "/edit-sales-order";

    static const int fromNewCustomerYes = 4;
    static const int fromNewCustomerNot = 3;
    static const int fromDetailCustomer = 2;
    static const int fromHomePage = 1;

    //Delivery Module
    static const String homePageDelivery = "/delivery-home";
    static const String deliveryDetailSO = "/delivery-details-so";
    static const String deliveryConfirmSO = "/delivery-confirm-so";
    static const String deliveryDetailTransfer = "/delivery-detail-transfer";
    static const String deliveryConfirmTransfer = "/delivery-confirm-Transfer";
    static const String deliveryRejectSO = "/delivery-reject-So";

    //Stock Module
    static const String homeStock = "/stock-home";
    static const String stockOpname = "/stock-opname";
    static const String stockDetail = "/stock-detail";
    static const String stockEdit = "/stock-edit";

    //Transfer Module
    static const String homeTransfer = "/transfer-home";
    static const String transferDetail = "/transfer-detail";
    static const String transferForm = "/transfer-form";
    static const String transferDriver = "/transfer-driver";

    //Terminate Module
    static const String homeTerminate = "/terminate-home";
    static const String terminateForm = "/terminate-form";
    static const String terminateDetail = "/terminate-detail";
    static const String terminateEdit = "/terminate-edit";

    //Manufacture Module
    static const String homeManufacture = "/manufacture-home";
    static const String manufactureDetail = "/manufacture-detail";
    static const String manufactureEdit = "/manufacture-edit";
    static const String manufactureForm = "/manufacture-form";
    static const String manufactureOutput = "/manufacture-output";
}

class AppRoutes {
    static const initial = RoutePage.splashPage;

    static final page = [
        //SALES MODULE PAGE
        GetPage(name: RoutePage.splashPage, page: () => const SplashActivity(), binding: SplashBindings()),
        GetPage(name: RoutePage.loginPage,page: () => const LoginPage(),binding: LoginActivityBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.homePageCustomer,page: () => const HomePageCustomer(),binding: HomePageBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.purchasePage,page: () => const PurchasePage(),binding: PurchasePageBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.customerDetailPage,page: () => const CustomerDetail(),binding: CustomerDetailBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.visitDetailPage,page: () => const DetailVisitCustomer(),binding: DetailVisitBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.newDataCustomer,page: () => const NewData(),bindings: [ NewDataBindings(context: Constant.getContext()),],),
        GetPage(name: RoutePage.visitCustomer,page: () => const VisitActivity(),binding: VisitBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.editCustomer,page: () => const EditData(),binding: EditDataBindings(context: Constant.getContext()),),

        //Purchase Module
        GetPage(name: RoutePage.newDataPurchase,page: () => const NewDataPurchase(),bindings: [ NewDataPurchaseBindings(context: Constant.getContext()),],),
        GetPage(name: RoutePage.purchaseDetailPage,page: () => const DetailPurchase(),binding: DetailPurchaseBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.purchaseEditPage,page: () => const EditDataPurchase(),binding: EditDataPurchaseBindings(context: Constant.getContext()),),

       //Receive Module
        GetPage(name: RoutePage.receivePage,page: () => const ReceiveActivity(),binding: ReceiveBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.grOrderDetail,page: () => const DetailGrOrder(),binding: DetailGrOrderBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.grPurchaseDetailPage,page: () => const DetailGrPurchase(),binding: DetailGrPurchaseBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.createGrPurchasePage,page: () => const CreateGrPurchase(),binding: CreateGrPurchaseBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.createGrJagalPurchasePage,page: () => const CreateGrPurchaseJagal(),binding: CreateGrJagalPurchaseBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.grTransferDetailPage,page: () => const DetailGRTransfer(),binding: DetailGRTransferBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.createGrTransferPage,page: () => const CreateGrTransfer(),binding: CreateGrTransferBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.createGrOrderPage,page: () => const CreateGrOrder(),binding: CreateGrOrderBindings(context: Constant.getContext()),),

        //Sales Oder Module
        GetPage(name: RoutePage.salesOrderPage,page: () => const SalesOrderPage(),binding: ReceiveBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.salesOrderDetailPage,page: () => const DetailSalesOrder(),binding: DetailSalesOrderBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.newDataSalesOrder,page: () => const NewDataSalesOrder(),binding: NewDataSalesOrderBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.newBookStock,page: () => const CreateBookStockPage(),binding: BookStockBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.assignToDriver,page: () => const AssignDriverPage(),binding: AssignDriverBindings(context: Constant.getContext()),),
        GetPage(name: RoutePage.editDataSalesOrder,page: () => const EditDataSalesOrder(),binding: EditDataSalesOrderBindings(context: Constant.getContext()),),

        //Home Page
        GetPage(name: RoutePage.homePage , page: ()=> const DashboardPage(), binding: DashboardBinding()),
        GetPage(name: RoutePage.licensePage, page: ()=> const LicenseScreen()),
        GetPage(name: RoutePage.privacyPage, page: ()=> const PrivacyScreen()),
        GetPage(name: RoutePage.termPage, page: ()=> const TermScreen()),
        GetPage(name: RoutePage.aboutUsPage, page: ()=> const AboutUsScreen()),
        GetPage(name: RoutePage.helpPage, page: ()=> const HelpScreen()),
        GetPage(name: RoutePage.changeBranch, page: ()=> const ChangeBranchActivity(), binding: ChangeBranchBindings(context: Constant.getContext())),

        //Delivery Module Internal
        GetPage(name: RoutePage.homePageDelivery, page: ()=> DeliveryHomeActivity(), binding: DeliveryHomeBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.deliveryConfirmSO, page: ()=> const DeliveryConfirmSO(), binding: DeliveryConfirmSOBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.deliveryDetailTransfer, page: ()=> const DeliveryDetailTransfer(), binding: DeliveryDetailTransferBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.deliveryConfirmTransfer, page: ()=> const DeliveryConfirmTransfer(), binding: DeliveryConfirmTransferBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.deliveryRejectSO, page: ()=> const DeliveryRejectSO(), binding: DeliveryRejectSOBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.deliveryDetailSO, page: ()=> const DeliveryDetailSO(), binding: DeliveryDetailSOBindings(context: Constant.getContext())),
    
        //Stock Module
        GetPage(name: RoutePage.homeStock, page: ()=>const StockHomeActivity(), binding: StockHomeBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.stockOpname, page: ()=>const StockOpnameActivity(),binding: StockOpnameBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.stockDetail, page: ()=>const StockDetailActivity(),binding: StockDetailBindings(context: Constant.getContext())),

        //Transfer Module
        GetPage(name: RoutePage.homeTransfer, page: ()=>const TransferHomeActivity(), binding: TransferHomeBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.transferDetail, page: ()=>const TransferDetailActivity(),binding: TransferDetailBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.transferForm, page: ()=>const TransferFormActivity(),binding: TransferFormBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.transferDriver, page: ()=>const TransferDriverDetail(),binding: TransferDriverBindings(context: Constant.getContext())),

        //Terminate Module
        GetPage(name: RoutePage.homeTerminate, page: ()=>const TerminateHomeAcitivity(),binding: TerminateHomeBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.terminateForm, page: ()=>const TerminateFormActivity(), binding: TerminateFormBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.terminateDetail, page: ()=>const TerminateDetailActivity(), binding: TerminateDetailBindings(context: Constant.getContext())),

        //Manufacture Module
        GetPage(name: RoutePage.homeManufacture, page: ()=> const ManufactureHomeActivity(), binding: ManufactureHomeBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.manufactureForm, page: ()=>const ManufactureFormActivity(), binding: ManufactureFormBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.manufactureDetail, page: ()=>const ManufactureDetailActivity(), binding:ManufactureDetailBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.manufactureEdit, page:()=> const ManufactureEditFormActivity(), binding: ManufactureEditFormBindings(context: Constant.getContext())),
        GetPage(name: RoutePage.manufactureOutput, page:()=> const ManufactureOutputActivity(), binding: ManufactureOutputBindings(context: Constant.getContext())),
    ];
}