import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/profile.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/route.dart';

class DashboardSelfRegistrationController extends GetxController {
    BuildContext context;
    DashboardSelfRegistrationController({required this.context});

    RxBool isLoading = false.obs;
    Coop coop = Coop();
    RxList<Profile> listOperators = <Profile>[].obs;

    late ButtonFill btAddOperator = ButtonFill(controller: GetXCreator.putButtonFillController("addOperator"), label: "Tambah Operator Kandang", onClick: ()=> Get.toNamed(RoutePage.addOperatorSelfRegistration, arguments: [coop]));
    late ButtonOutline btAddTask = ButtonOutline(controller: GetXCreator.putButtonOutlineController("btAddTask"), label: "Tugaskan Operator Kandang", onClick: ()=> Get.toNamed(RoutePage.addTaskSelfRegistration, arguments: [coop]));
    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        isLoading.value = true;
        getListOperators();
    }

    // @override
    // void onReady() {
    //     super.onReady();
    // }
    // @override
    // void onClose() {
    //     super.onClose();
    // }

    void getListOperators() {
        AuthImpl().get().then((auth) => {
            if (auth != null)
                {
                Service.push(
                    apiKey: ApiMapping.api,
                    service: ListApi.getListOperator,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetListOperatir(coop.farmingCycleId!)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if (body.data.isNotEmpty) {
                                for (var result in body.data) {
                                    listOperators.add(result as Profile);
                                }
                                isLoading.value = false;
                            }
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                            );
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()))
                }
            else
                {GlobalVar.invalidResponse()}
            });
    }
}

class DashboardSelfRegistrationBindings extends Bindings {
    BuildContext context;
    DashboardSelfRegistrationBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DashboardSelfRegistrationController(context: context));
    }
}
