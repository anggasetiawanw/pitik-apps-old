import 'dart:io';

import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:engine/imageprocessing/smart_camera_image_processing.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/record_model.dart';
import 'package:model/response/camera_detail_response.dart';
import 'package:permission_handler/permission_handler.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 18/08/23

class HistoricalDataSmartCameraController extends GetxController {
    BuildContext context;
    HistoricalDataSmartCameraController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
    Rx<List<RecordCamera>> recordImages = Rx<List<RecordCamera>>([]);

    var isLoading = false.obs;
    var isLoadMore = false.obs;
    var pageSmartCamera = 1.obs;
    var limit = 10.obs;
    var totalCamera = 0.obs;

    late RecordCamera record;
    late Coop coop;

    late String localPath;
    late bool permissionReady;
    late TargetPlatform? platform;
    bool isTakePicture = false;
    late int indeksCamera = 0;

    late DateTimeField dtftakePicture = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController(
            "dtftakePicture"),
        label: "Jam Ambil Gambar",
        hint: "Pilih Jam Ambil Gambar",
        flag: DateTimeField.ALL_FLAG,
        alertText: "Jam Ambil Gambar harus di isi", onDateTimeSelected: (DateTime time, dateField) {
        GlobalVar.track("Click_time_filter");
        dtftakePicture.controller.setTextSelected("${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}");
    },
    );

    ScrollController scrollCameraController = ScrollController();

    scrollPurchaseListener() async {
        scrollCameraController.addListener(() {
            if (scrollCameraController.position.maxScrollExtent == scrollCameraController.position.pixels) {
                isLoadMore.value = true;
                pageSmartCamera++;
                getCameraImagebyCameraId();
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
        indeksCamera = Get.arguments[3];
        indeksCamera = indeksCamera+1;

    }


    @override
    void onReady() {
        super.onReady();
        if(isTakePicture == false){
            isLoading.value = true;
            record = Get.arguments[1];
            getCameraImagebyCameraId();
        }
        scrollPurchaseListener();
    }

    /// The function `getCameraImagebyCameraId` retrieves camera images based on the
    /// camera ID.
    void getCameraImagebyCameraId(){
        Service.push(
            service: ListApi.getRecordImages,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathCameraImages(coop.coopId!, record.sensor!.id!, coop.room!.id!),
                pageSmartCamera.value,
                limit.value],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                    if ((body as CameraDetailResponse).data!.records!.isNotEmpty) {
                        for (var result in body.data!.records!) {
                            recordImages.value.add(result as RecordCamera);
                        }
                        totalCamera.value = recordImages.value.length;
                        isLoading.value = false;
                        if (isLoadMore.isTrue) {
                            isLoadMore.value = false;
                        }
                    } else {
                        if (isLoadMore.isTrue) {
                            pageSmartCamera.value =
                                (recordImages.value.length ~/ 10).toInt() + 1;
                            isLoadMore.value = false;
                        } else {
                            isLoading.value = false;
                        }
                    }
                },
                onResponseFail: (code, message, body, id, packet){
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;

                }, onTokenInvalid: GlobalVar.invalidResponse())
        );
    }

    /// The function checks if the storage permission is granted on Android and
    /// returns true if it is, otherwise it requests the permission and returns true
    /// if it is granted, otherwise it returns false.
    ///
    /// Returns:
    ///   a `Future<bool>`.
    Future<bool> checkPermission() async {
        if (platform == TargetPlatform.android) {
            final deviceInfo = await DeviceInfoPlugin().androidInfo;
            if (deviceInfo.version.sdkInt > 32) {
                final status = await Permission.photos.status;
                if (status != PermissionStatus.granted) {
                    final result = await Permission.photos.request();
                    if (result == PermissionStatus.granted) {
                        return true;
                    }
                } else {
                    return true;
                }
                // permissionStatus = await Permission.photos.request().isGranted;
            } else {
                final status = await Permission.storage.status;
                if (status != PermissionStatus.granted) {
                    final result = await Permission.storage.request();
                    if (result == PermissionStatus.granted) {
                        return true;
                    }
                } else {
                    return true;
                }
            }

        } else {
            return true;
        }
        return false;
    }



  /// The function `shareFile` downloads an image from a given URL, saves it
  /// locally, and then shares it along with some additional information using the
  /// Share plugin in Dart.
  ///
  /// Args:
  ///   recordCamera (RecordCamera): The `recordCamera` parameter is an object of
  /// type `RecordCamera`. It contains information about a recorded camera, such as
  /// the camera link, sensor information, temperature, humidity, and creation
  /// timestamp.
  Future<void> shareFile(RecordCamera recordCamera, bool isDownload) async {
      permissionReady = await checkPermission();
      if (permissionReady) {
          final DateTime takePictureDate = Convert.getDatetime(recordCamera.createdAt!);
          final imageurl = recordCamera.link!;
          // final imageurl = "https://pitik.id/mitrapeternak/assets/2022/10/gb2.jpg";
          final uri = Uri.parse(imageurl);
          if(await isValidUrl(uri)){
              await SmartCameraImageProcessing().shareImage(
                  url: imageurl,
                  cameraName: '${recordCamera.sensor!.sensorCode}',
                  temperature: recordCamera.temperature ?? 0,
                  humidity: recordCamera.humidity ?? 0,
                  coop: recordCamera.sensor!.room!.building!.name!,
                  floor: recordCamera.sensor!.room!.roomType!.name!,
                  cameraPosition: recordCamera.sensor!.position!,
                  timeTake: '${takePictureDate.day}/${takePictureDate.month}/${takePictureDate.year} ${takePictureDate.hour}:${takePictureDate.minute}',
                  isDownload: isDownload
              );
          }
      }
  }

  /// The function `isValidUrl` checks if a given URL is valid by making an HTTP
  /// request and returning true if the response status code is 200, otherwise it
  /// displays a snack bar message and returns false.
  ///
  /// Args:
  ///   imageUrl (Uri): The imageUrl parameter is of type Uri and represents the URL
  /// of an image.
  ///
  /// Returns:
  ///   a `Future<bool>`.
  Future<bool> isValidUrl(Uri imageUrl) async{
        var response = await http.get(imageUrl);
        if(response.statusCode != 200){
            Get.snackbar(
                "Pesan", "Gambar belum tersedia!",
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
            );
            return false;
        }
        return true;
    }

  /// The function `setContentShare` calls the `shareFile` function with a
  /// `RecordCamera` parameter.
  ///
  /// Args:
  ///   recordCamera (RecordCamera): The parameter "recordCamera" is of type
  /// "RecordCamera".
  void setContentShare(RecordCamera recordCamera, bool isDownload) {
        shareFile(recordCamera, isDownload);
    }

}

class HistoricalDataSmartCameraBindings extends Bindings {
    BuildContext context;

    HistoricalDataSmartCameraBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => HistoricalDataSmartCameraController(context: context));
    }
}