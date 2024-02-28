import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/error/error.dart';
import 'package:model/record_model.dart';
import 'package:model/response/camera_detail_response.dart';
import 'package:model/response/camera_list_response.dart';

import '../../route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/07/23

class DetailSmartCameraController extends GetxController {
  BuildContext context;
  DetailSmartCameraController({required this.context});

  ScrollController scrollController = ScrollController();
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
  Rx<List<RecordCamera>> sensorCameras = Rx<List<RecordCamera>>([]);
  Rx<List<RecordCamera>> recordImages = Rx<List<RecordCamera>>([]);

  var isLoadMore = false.obs;
  var isLoading = false.obs;
  var pageSmartCamera = 1.obs;
  var totalCamera = 0.obs;
  var deviceUpdatedName = "".obs;
  var limit = 10.obs;
  late Device device;
  late Coop coop;
  late DateTime timeStart;

  ScrollController scrollCameraController = ScrollController();

  scrollHistoryListener() async {
    scrollCameraController.addListener(() {
      if (scrollCameraController.position.maxScrollExtent == scrollCameraController.position.pixels) {
        isLoadMore.value = true;
        pageSmartCamera++;
        getListCamera();
      }
    });
  }

  late ButtonFill bfTakePicture = ButtonFill(
    controller: GetXCreator.putButtonFillController("takePicture"),
    label: "Ambil Gambar",
    onClick: () {},
  );
  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
    GlobalVar.track("Open_smart_camera_page");
    device = Get.arguments[0];
    coop = Get.arguments[1];
    isLoading.value = true;
    getListCamera();
  }

  @override
  void onReady() {
    super.onReady();
    if (!GlobalVar.canModifyInfrasturucture()) {
      bfTakePicture.controller.disable();
    }
  }

  /// The function `getListCamera` makes an API call to retrieve a list of camera
  /// data and handles the response accordingly.
  void getListCamera() {
    Service.push(
        service: ListApi.getListDataCamera,
        context: context,
        body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!, ListApi.pathListCamera(coop.coopId!, coop.room!.id!), pageSmartCamera, limit],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as CameraListResponse).data!.isNotEmpty) {
                for (var result in body.data!) {
                  sensorCameras.value.add(result as RecordCamera);
                }
                totalCamera.value = sensorCameras.value.length;
              }
              DateTime timeEnd = DateTime.now();
              GlobalVar.sendRenderTimeMixpanel("Open_smart_camera_page", timeStart, timeEnd);
              isLoading.value = false;
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = false;
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoading.value = false;
            },
            onTokenInvalid: () => GlobalVar.invalidResponse()));
  }

  /// The function `takePictureSmartCamera` is used to handle the process of
  /// taking pictures with a smart camera, including making API calls and handling
  /// responses.
  void takePictureSmartCamera() {
    isLoading.value = true;
    try {
      Service.push(
        service: ListApi.takePictureSmartCamera,
        context: context,
        body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId, Mapper.asJsonString(Coop(coopId: coop.coopId)), ListApi.pathTakeImage(coop.coopId!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              recordImages.value.clear();
              if ((body as CameraDetailResponse).data!.records!.isNotEmpty) {
                for (var result in body.data!.records!) {
                  recordImages.value.add(result as RecordCamera);
                }
              }
              isLoading.value = false;
              Get.toNamed(RoutePage.takePictureSmartCameraPage, arguments: [true, recordImages, coop])!.then((value) {
                isLoading.value = true;
                sensorCameras.value.clear();
                pageSmartCamera.value = 0;
                Timer(const Duration(milliseconds: 500), () {
                  getListCamera();
                });
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
            onTokenInvalid: () => GlobalVar.invalidResponse()),
      );
    } catch (e, st) {
      Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5), backgroundColor: const Color(0xFFFF0000), colorText: Colors.white);
    }
  }
}

class DetailSmartCameraBindings extends Bindings {
  BuildContext context;

  DetailSmartCameraBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => DetailSmartCameraController(context: context));
  }
}
