
import 'dart:io';

import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/record_model.dart';
import 'package:components/item_take_picture/item_take_picture.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 10/11/2023

class SmartCameraTakeController extends GetxController {
    BuildContext context;
    SmartCameraTakeController({required this.context});

    var totalCamera = 0.obs;

    late Coop coop;
    late List<RecordCamera> recordImages;

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track("Open_ambil_gambar_page");

        coop = Get.arguments[0];
        recordImages = Get.arguments[1];
        totalCamera.value = recordImages.length;
    }

    Widget listRecordCamera() => ListView.builder(
        itemCount: recordImages.length,
        itemBuilder: (context, index) {
            int length = recordImages.length;
            if (index >= length) {
                return const Column(
                    children: [
                        Center(
                            child: SizedBox(
                                height: 24,
                                width: 24,
                                child: ProgressLoading()
                            )
                        ),
                        SizedBox(height: 120)
                    ]
                );
            }
            return Stack(
                children: [
                    ListTile(
                        title: Column(
                            children: [
                                ItemTakePictureCamera(
                                    controller: GetXCreator.putItemTakePictureController("ItemTakePictureCamera$index",context),
                                    recordCamera: recordImages[index],
                                    index: index,
                                    onOptionTap: () {}
                                ),
                                index == recordImages.length - 1 ? const SizedBox(height: 120) : Container()
                            ]
                        )
                    )
                ]
            );
        }
    );
}

class SmartCameraTakeBinding extends Bindings {
    BuildContext context;
    SmartCameraTakeBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<SmartCameraTakeController>(() => SmartCameraTakeController(context: context));
}