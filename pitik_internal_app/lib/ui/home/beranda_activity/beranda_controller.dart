
// ignore_for_file: use_build_context_synchronously

import 'package:components/custom_dialog.dart';
import 'package:components/listener/custom_dialog_listener.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/response/internal_app/profile_response.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/role.dart';
import 'package:pitik_internal_app/utils/route.dart';
class BerandaController extends GetxController {
    BuildContext context;
    BerandaController({required this.context});
    var isList = true.obs;
    var isLoading = false.obs;
    Rx<List<String?>> listRole = Rx<List<String?>>([]);
    Rx<List<Map>> module = Rx<List<Map>>([]);
    final List<Map> modules = [
        {"iconPath": "images/pembelian_icon.svg","nameModule" :"Purchase Order", "nameIcon": "Pembelian", "homeRoute": RoutePage.purchasePage},           // Number 0
        {"iconPath": "images/penerimaan_icon.svg","nameModule" :"Goods Received", "nameIcon": "Penerimaan", "homeRoute": RoutePage.receivePage},           // Number 1
        {"iconPath": "images/penjualan_icon.svg", "nameModule" :"Sales Order","nameIcon": "Penjualan", "homeRoute": RoutePage.salesOrderPage},          // Number 2
        {"iconPath": "images/customer_icon.svg","nameModule" :"Customer", "nameIcon": "Customer", "homeRoute": RoutePage.homePageCustomer},          // Number 3
        {"iconPath": "images/pengiriman_icon.svg","nameModule" :"Delivery", "nameIcon": "Pengiriman", "homeRoute": RoutePage.homePageDelivery},      // Number 4
        {"iconPath": "images/persediaan_icon.svg","nameModule" :"Stock", "nameIcon": "Persediaan", "homeRoute": RoutePage.homeStock},             // Number 5
        {"iconPath": "images/transfer_icon.svg","nameModule" :"Internal Transfer", "nameIcon": "Transfer", "homeRoute": RoutePage.homeTransfer},              // Number 6
        {"iconPath": "images/manufaktur_icon.svg","nameModule" :"Manufacturing Order", "nameIcon": "Manufaktur", "homeRoute": RoutePage.homeManufacture},       // Number 7
        {"iconPath": "images/pemusnahan_icon.svg", "nameModule" :"Stock Disposal","nameIcon": "Pemusnahan", "homeRoute": RoutePage.homeTerminate},         // Number 8
    ];
    @override
    void onInit() {
        super.onInit();
        isLoading.value = true;
    }
    @override
    void onReady() {
        super.onReady();
        checkVersion(Get.context!);
        getRole();
    }
    void checkRoleBranch(){
        String role = FirebaseRemoteConfig.instance.getString("role_change");
        List<String> roles = role.split(",");
        for(var role in Constant.profileUser!.roles!){
            for(var roleBranch in roles){
                if(role!.name == roleBranch){
                    Constant.isChangeBranch.value = true;
                    Constant.isChangeBranch.refresh();
                }
                if(role.name == RoleEnum.developer){
                    Constant.isDeveloper.value = true;
                    Constant.isDeveloper.refresh();
                }
                if(role.name == RoleEnum.shopkeeper){
                    Constant.isShopKepper.value = true;
                    Constant.isShopKepper.refresh();
                }
                if(role.name == RoleEnum.scRelation){
                    Constant.isScRelation.value = true;
                    Constant.isScRelation.refresh();
                }
            }
        }
    }
    void getRole(){
        Service.push(apiKey: 'userApi', service: ListApi.getSalesProfile, context: context, body: [Constant.auth!.token,Constant.auth!.id, Constant.xAppId!], 
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
                for (var result in (body as ProfileResponse).data!.modules!.downstreamApp){
                    listRole.value.add(result);
                }
                Constant.profileUser = body.data!;
                assignModule();
                
            },
            onResponseFail: (code, message, body, id, packet) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                isLoading.value = false;
            },
            onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()
        ));
    }

    void assignModule(){
        module.value.clear();
        for (var element in modules) {
            if(listRole.value.contains(element['nameModule'])){
                module.value.add(element);
            }
         }
        module.refresh();
        checkRoleBranch();
        isLoading.value = false;
    }

    void checkVersion(BuildContext context) async {
        String version = FirebaseRemoteConfig.instance.getString("pitik_version");
        String suggestionVersion = FirebaseRemoteConfig.instance.getString("pitik_suggestion_version");

        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        bool mustBeUpdate = false;
        bool forceUpdate = false;

        List<String> verCurr = packageInfo.version.split(".");
        List<String> verSuggestion = suggestionVersion.split(".");

        if (double.parse('${verCurr[0]}.${verCurr[1]}') <= double.parse('${verSuggestion[0]}.${verSuggestion[1]}')) {
            if (version != "" && version != "0.0.0") {
                List<String> verPlay = version.split(".");
                // print("$verPlay and $verCurr");
                if (int.parse(verPlay[0]) > int.parse(verCurr[0])) {
                    mustBeUpdate = true;
                    forceUpdate = true;
                } else if (int.parse(verPlay[0]) == int.parse(verCurr[0])) {
                    if (int.parse(verPlay[1]) > int.parse(verCurr[1])) {
                        mustBeUpdate = true;
                    }
                }
            }

            if (mustBeUpdate) {
                if (forceUpdate) {
                    CustomDialog customDialog = CustomDialog(context, Dialogs.YES_OPTION);
                    customDialog.title("Informasi");
                    customDialog.message("Versi terbaru tersedia, mohon lakukan pembaruan aplikasi.");
                    customDialog.listener(DialogUpdateListener());
                    customDialog.show();
                } else {
                    CustomDialog customDialog = CustomDialog(context, Dialogs.YES_NO_OPTION);
                    customDialog.title("Informasi");
                    customDialog.message("Versi terbaru tersedia, mohon lakukan pembaruan aplikasi.");
                    customDialog.listener(DialogUpdateListener());
                    customDialog.show();
                }
            }
        }
    }
}
class BerandaBindings extends Bindings {
    BuildContext context;
    BerandaBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => BerandaController(context: context));
    }
}
class DialogUpdateListener implements CustomDialogListener {    
      @override
      set onDialogCancel(Function(BuildContext context, int id, List packet) onDialogCancel) {
      }
    
      @override
      set onDialogOk(Function(BuildContext context, int id, List packet) onDialogOk) {
            OpenStore.instance.open(
            appStoreId: '284815942',
            androidAppBundleId: 'id.pitik.mobile.mobile_flutter',
        );
      }
      
        @override
        Function(BuildContext context, int id, List packet) get onDialogCancel => throw UnimplementedError();
      
        @override
        Function(BuildContext context, int id, List packet) get onDialogOk => throw UnimplementedError();
}