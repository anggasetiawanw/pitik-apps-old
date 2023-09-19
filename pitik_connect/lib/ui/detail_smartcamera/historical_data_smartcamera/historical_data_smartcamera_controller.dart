import 'dart:io';

import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:engine/imageprocessing/smart_camera_image_processing.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/record_model.dart';
import 'package:model/response/camera_detail_response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 18/08/23
 */

class HistoricalDataSmartCameraController extends GetxController {
    BuildContext context;
    HistoricalDataSmartCameraController({required this.context});

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
    late int indeksCamera = 0;

    late DateTimeField dtftakePicture = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("dtftakePicture"),
        label: "Jam Ambil Gambar",
        hint: "Pilih Jam Ambil Gambar",
        flag: DateTimeField.ALL_FLAG,
        alertText: "Jam Ambil Gambar harus di isi", onDateTimeSelected: (time, field) {
        GlobalVar.track("Click_time_filter");
        dtftakePicture.controller.setTextSelected("${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}");
    },
    );

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
        indeksCamera = Get.arguments[3];
        indeksCamera = indeksCamera+1;
        if(isTakePicture == false){
            isLoading.value = true;
            record = Get.arguments[1];
            getCameraImagebyCameraId();
        }

    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
    }

    /// The function `getCameraImagebyCameraId` retrieves camera images based on the
    /// camera ID.
    void getCameraImagebyCameraId(){
        Service.push(
            service: ListApi.getRecordImages,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathCameraImages(coop.coopId!, record.sensor!.id!),
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
                        duration: Duration(seconds: 5),
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

    /// The function prepares a directory for saving files by checking if it exists
    /// and creating it if it doesn't.
    Future<void> prepareSaveDir() async {
        localPath = (await findLocalPath())!;

        print(localPath);
        final savedDir = Directory(localPath);
        bool hasExisted = await savedDir.exists();
        if (!hasExisted) {
            savedDir.create();
        }
    }

    /// The function downloads an image from a given URL and saves it as a file.
    ///
    /// Args:
    ///   url (String): The `url` parameter is a string that represents the URL of
    /// an image file that you want to download.
    ///
    /// Returns:
    ///   a `Future<File>`.
    Future<File> _fileFromImageUrl(String url) async {
        final response = await http.get(Uri.parse(url));
        final documentDirectory = await _getDownloadPath();
        final file = File('$documentDirectory/${DateTime. now(). millisecondsSinceEpoch}.jpg');

        file.writeAsBytesSync(response.bodyBytes);
        Get.snackbar(
            "Message", "Download complete",
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.green,
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
        );
        return file;
    }


    /// The function `_getDownloadPath` returns the path of the download folder on
    /// the device.
    ///
    /// Returns:
    ///   The method is returning a `String` that represents the path to the
    /// download folder. However, the return type is `Future<String?>`, which means
    /// it can also return `null` if the download folder path cannot be obtained.
    Future<String?> _getDownloadPath() async {
        Directory? directory;
        try {
            if (Platform.isIOS) {
                directory = await getApplicationDocumentsDirectory();
            } else {
                directory = Directory('/storage/emulated/0/Download');
                if (!await directory.exists()) directory = await getExternalStorageDirectory();
            }
        } catch (err) {
            Get.snackbar(
                "Message", "Cannot get download folder path",
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.white,
                duration: Duration(seconds: 5),
                backgroundColor: Colors.red,
            );
        }

        return directory?.path;
    }

    /// The function `findLocalPath` returns the local path for storing downloaded
    /// files based on the platform (Android or other platforms).
    ///
    /// Returns:
    ///   The method `findLocalPath()` returns a `Future` object that resolves to a
    /// `String` or `null`.
    Future<String?> findLocalPath() async {
        if (platform == TargetPlatform.android) {
            return "/sdcard/download/";
        } else {
            var directory = await getApplicationDocumentsDirectory();
            return directory.path + Platform.pathSeparator + 'Download';
        }
    }


    /// The function `downloadFile` downloads a file from a given URL and saves it
    /// to a local directory.
    ///
    /// Args:
    ///   url (String): The `url` parameter is a string that represents the URL of
    /// the file that you want to download.
    Future<void> downloadFile(String url) async {
      permissionReady = await checkPermission();
      if (permissionReady) {
          await prepareSaveDir();
          try {
              await Dio().download(url,
                  localPath + "/" + url+".jpg");
              print("Download Completed.");
          } catch (e) {
              Get.snackbar("Download Failed.\n\n", e.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 5),
                  backgroundColor: Color(0xFFFF0000),
                  colorText: Color(0xFFFFFFFF));
          }
      }
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
  Future<void> shareFile(RecordCamera recordCamera) async {
      permissionReady = await checkPermission();
      if (permissionReady) {
          final imageurl = recordCamera.link!;
          final uri = Uri.parse(imageurl);
          // final uri = Uri.parse("https://pitik.id/mitrapeternak/assets/2022/10/gb2.jpg");
          final response = await http.get(uri);
          final bytes = response.bodyBytes;
          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/image_pitik.jpg';
          File(path).writeAsBytesSync(bytes);


          await SmartCameraImageProcessing().downloadImage(
              url: 'https://awsimages.detik.net.id/community/media/visual/2022/02/04/ayam-betina.jpeg?w=600&q=90',
              cameraName: 'ATC-1',
              temperature: 26.9,
              humidity: 90,
              coop: 'COOP-TEST',
              floor: 2,
              cameraPosition: 'Building 3',
              timeTake: '2023-10-10'
          );

          // ignore: deprecated_member_use
          await Share.shareFiles([path], text: 'Nama Kamera : ${recordCamera.sensor!.sensorCode!} \n Kandang : ${recordCamera.sensor!.room!.building!.name!} \n Lantai : ${recordCamera.sensor!.room!.roomType!.name!} \n Jam Ambil Gambar : ${recordCamera.createdAt} \n Temperature : ${recordCamera.temperature} \n Kelembapan : ${recordCamera.humidity} \n');
      }
  }


  /// The function sets a link image by downloading a file.
  ///
  /// Args:
  ///   value (String): The value parameter is a string that represents the URL or
  /// file path of the image that needs to be downloaded.
  void setLinkImage(String value) {
        _fileFromImageUrl(value);
    }

  /// The function `setContentShare` calls the `shareFile` function with a
  /// `RecordCamera` parameter.
  ///
  /// Args:
  ///   recordCamera (RecordCamera): The parameter "recordCamera" is of type
  /// "RecordCamera".
  void setContentShare(RecordCamera recordCamera) {
        shareFile(recordCamera);
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

