
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

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
    Rx<List<RecordCamera>> recordImages = Rx<List<RecordCamera>>([]);

    var isLoading = false.obs;
    var isLoadMore = false.obs;
    var pageSmartMonitor = 1.obs;
    var pageSmartController = 1.obs;
    var pageSmartCamera = 1.obs;
    var limit = 10.obs;
    var totalCamera = 0.obs;

    late RecordCamera record;
    late Coop coop;

    late String localPath;
    late bool permissionReady;
    late TargetPlatform? platform;
    bool isTakePicture = false;

    ScrollController scrollCameraController = ScrollController();
    scrollPurchaseListener() async {
        scrollCameraController.addListener(() {
            if (scrollCameraController.position.maxScrollExtent == scrollCameraController.position.pixels) {
                isLoadMore.value = true;
                pageSmartMonitor++;
            }
        });
    }

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track("Open_ambil_gambar_page");
        if (Platform.isAndroid) {
            platform = TargetPlatform.android;
        } else {
            platform = TargetPlatform.iOS;
        }

        isTakePicture = Get.arguments[0];
        coop = Get.arguments[2];

        recordImages.value.clear();
        recordImages = Get.arguments[1];
        totalCamera.value = recordImages.value.length;
    }

    Widget listRecordCamera() => ListView.builder(
        controller: scrollCameraController,
        itemCount: isLoadMore.isTrue ? recordImages.value.length + 1 : recordImages.value.length,
        itemBuilder: (context, index) {
            int length = recordImages.value.length;
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
                                    recordCamera: recordImages.value[index],
                                    index: index,
                                    onOptionTap: () {}
                                ),
                                index == recordImages.value.length - 1 ? const SizedBox(height: 120) : Container()
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