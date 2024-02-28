import 'dart:async';

import 'package:common_page/smart_camera/bundle/smart_camera_list_bundle.dart';
import 'package:common_page/smart_camera/history_detail/smart_camera_history_activity.dart';
import 'package:common_page/smart_camera/take_picture/smart_camera_take_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/record_model.dart';
import 'package:model/response/camera_detail_response.dart';
import 'package:components/item_detail_smartcamera/item_detail_smartcamera.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 10/11/2023

class SmartCameraListHistoryController extends GetxController {
  BuildContext context;
  SmartCameraListHistoryController({required this.context});

  ScrollController scrollController = ScrollController();
  RxMap<String, bool> mapList = <String, bool>{}.obs;
  RxList<RecordCamera> sensorCameras = <RecordCamera>[].obs;

  var isLoadMore = false.obs;
  var isLoading = false.obs;
  var pageSmartCamera = 1.obs;
  var totalCamera = 0.obs;
  var deviceUpdatedName = "".obs;
  var limit = 10.obs;

  late SmartCameraBundle<SmartCameraListHistoryController> bundle;
  late DateTime timeStart;

  ScrollController scrollCameraController = ScrollController();

  scrollHistoryListener() async {
    scrollCameraController.addListener(() {
      if (scrollCameraController.position.maxScrollExtent == scrollCameraController.position.pixels) {
        isLoadMore.value = true;
        pageSmartCamera++;
        bundle.onGetData(this);
      }
    });
  }

  late ButtonFill bfTakePicture = ButtonFill(controller: GetXCreator.putButtonFillController("takePicture"), label: "Ambil Gambar", onClick: () {});

  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
    GlobalVar.track("Open_smart_camera_page");
    bundle = Get.arguments;

    bundle.onGetData(this);
  }

  @override
  void onReady() {
    super.onReady();
    if (!GlobalVar.canModifyInfrasturucture()) {
      bfTakePicture.controller.disable();
    }
  }

  /// The function `takePictureSmartCamera` is used to handle the process of
  /// taking pictures with a smart camera, including making API calls and handling
  /// responses.
  void _takePictureSmartCamera() => AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          GlobalVar.track("Click_button_ambil_gambar");

          Service.push(
              apiKey: 'smartCameraApi',
              service: ListApi.takePictureSmartCamera,
              context: context,
              body: ['Bearer ${auth.token}', auth.id, GlobalVar.xAppId ?? '-', '${bundle.basePath}jobs/${bundle.getCoop.id ?? bundle.getCoop.coopId}', Mapper.asJsonString(Coop(coopId: bundle.getCoop.id ?? bundle.getCoop.coopId))],
              listener: ResponseListener(
                  onResponseDone: (code, message, body, id, packet) {
                    List<RecordCamera> recordImages = [];
                    if ((body as CameraDetailResponse).data!.records!.isNotEmpty) {
                      for (var result in body.data!.records!) {
                        recordImages.add(result as RecordCamera);
                      }
                    }

                    isLoading.value = false;
                    Get.to(const SmartCameraTakeActivity(), arguments: [bundle.getCoop, recordImages])!.then((value) {
                      isLoading.value = true;
                      sensorCameras.clear();
                      pageSmartCamera.value = 0;
                      Timer(const Duration(milliseconds: 500), () => bundle.onGetData(this));
                    });
                  },
                  onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
                  },
                  onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                    Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
                  },
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        } else {
          GlobalVar.invalidResponse();
        }
      });

  Widget bottomNavBar() => Align(
      alignment: Alignment.bottomCenter,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: ButtonFill(controller: GetXCreator.putButtonFillController("smartCameraTakePicture"), label: "Ambil Gambar", onClick: () => _takePictureSmartCamera()))]))
      ]));

  Widget listSmartCamera() => Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: ListView.builder(
          controller: scrollCameraController,
          itemCount: isLoadMore.isTrue ? sensorCameras.length + 1 : sensorCameras.length,
          itemBuilder: (context, index) {
            int length = sensorCameras.length;
            if (index >= length) {
              return const Column(children: [Center(child: SizedBox(height: 24, width: 24, child: ProgressLoading())), SizedBox(height: 120)]);
            }
            return Column(children: [
              ItemDetailSmartCamera(
                  camera: sensorCameras[index],
                  indeksCamera: index,
                  onTap: () {
                    GlobalVar.track("Click_card_camera");
                    Get.to(const SmartCameraHistoryActivity(), arguments: [bundle, sensorCameras[index]])!.then((value) {
                      isLoading.value = true;
                      sensorCameras.clear();
                      pageSmartCamera.value = 0;
                      Timer(const Duration(milliseconds: 500), () => bundle.onGetData(this));
                    });
                  }),
              index == sensorCameras.length - 1 ? const SizedBox(height: 120) : Container()
            ]);
          }));
}

class SmartCameraListHistoryBinding extends Bindings {
  BuildContext context;
  SmartCameraListHistoryBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<SmartCameraListHistoryController>(() => SmartCameraListHistoryController(context: context));
}
