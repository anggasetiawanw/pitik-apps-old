
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 05/10/2023

class PulletInController extends GetxController {
    BuildContext context;
    PulletInController({required this.context});

    late Coop coop;

    var isLoading = false.obs;
    var isAlreadySubmit = false.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
    }

    void submitPulletIn() => AuthImpl().get().then((auth) {
        if (auth != null) {

        } else {
            GlobalVar.invalidResponse();
        }
    });
}

class PulletInBinding extends Bindings {
    BuildContext context;
    PulletInBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<PulletInController>(() => PulletInController(context: context));
}