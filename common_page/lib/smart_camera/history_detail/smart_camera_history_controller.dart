
import 'dart:io';

import 'package:common_page/smart_camera/bundle/smart_camera_list_bundle.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:engine/imageprocessing/smart_camera_image_processing.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/record_model.dart';
import 'package:model/response/camera_detail_response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:components/item_historical_smartcamera/item_historical_smartcamera.dart';
import 'package:http/http.dart' as http;

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 10/11/2023

class SmartCameraHistoryController extends GetxController {
    BuildContext context;
    SmartCameraHistoryController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
    Rx<List<RecordCamera>> recordImages = Rx<List<RecordCamera>>([]);

    var isLoading = false.obs;
    var isLoadMore = false.obs;
    var pageSmartCamera = 1.obs;
    var limit = 10.obs;
    var totalCamera = 0.obs;

    late SmartCameraBundle bundle;
    late RecordCamera record;

    late String localPath;
    late bool permissionReady;
    late TargetPlatform? platform;

    ScrollController scrollCameraController = ScrollController();

    scrollPurchaseListener() async {
        scrollCameraController.addListener(() {
            if (scrollCameraController.position.maxScrollExtent == scrollCameraController.position.pixels) {
                isLoadMore.value = true;
                pageSmartCamera++;
                _getCameraImageByCameraId();
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

        bundle = Get.arguments[0];
        record = Get.arguments[1];
    }

    @override
    void onReady() {
        super.onReady();
        _getCameraImageByCameraId();
        scrollPurchaseListener();
    }

    /// The function `getCameraImagebyCameraId` retrieves camera images based on the
    /// camera ID.
    void _getCameraImageByCameraId() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'smartCameraApi',
                service: bundle.routeHistoryDetail,
                context: Get.context!,
                body: [
                    'Bearer ${auth.token}',
                    auth.id,
                    GlobalVar.xAppId ?? '-',
                    '${bundle.basePath}${bundle.getCoop.id ?? bundle.getCoop.coopId}/records/${bundle.day != null ? '${bundle.day}/' : ''}${record.sensor!.id!}',
                    bundle.getCoop.room != null && bundle.getCoop.room!.id != null ? bundle.getCoop.room!.id : null,
                    pageSmartCamera.value,
                    limit.value
                ],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
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
                                pageSmartCamera.value = (recordImages.value.length ~/ 10).toInt() + 1;
                                isLoadMore.value = false;
                                isLoading.value = false;
                            } else {
                                isLoading.value = false;
                            }
                        }
                    },
                    onResponseFail: (code, message, body, id, packet) {
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
                        Get.snackbar(
                            "Pesan", "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                        );
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    /// The function checks if the storage permission is granted on Android and
    /// returns true if it is, otherwise it requests the permission and returns true
    /// if it is granted, otherwise it returns false.
    ///
    /// Returns:
    ///   a `Future<bool>`.
    Future<bool> _checkPermission() async {
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
    Future<void> _shareFile(RecordCamera recordCamera, bool isDownload) async {
        permissionReady = await _checkPermission();
        if (permissionReady) {
            final DateTime takePictureDate = Convert.getDatetime(recordCamera.createdAt!);
            final imageUrl = recordCamera.link!;
            final uri = Uri.parse(imageUrl);
            if(await _isValidUrl(uri)){
                await SmartCameraImageProcessing().shareImage(
                    url: imageUrl,
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
    Future<bool> _isValidUrl(Uri imageUrl) async{
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
    void _setContentShare(RecordCamera recordCamera, bool isDownload) => _shareFile(recordCamera, isDownload);

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
                                child: CircularProgressIndicator(color: GlobalVar.primaryOrange)
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
                                ItemHistoricalSmartCamera(
                                    controller: GetXCreator.putHistoricalSmartCameraController("ItemHistoricalSmartCamera$index}",context),
                                    recordCamera: recordImages.value[index],
                                    index: index,
                                    onOptionTap: () {}
                                ),
                                index == recordImages.value.length - 1 ? const SizedBox(height: 120) : Container()
                            ]
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 24, right: 16),
                        child: ListTile(
                            trailing: PopupMenuButton(
                                icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: GlobalVar.primaryLight,
                                        border: const Border(
                                            bottom: BorderSide(color: GlobalVar.primaryOrange, width: 1),
                                            left: BorderSide(color: GlobalVar.primaryOrange, width: 1),
                                            right: BorderSide(color: GlobalVar.primaryOrange, width: 1),
                                            top: BorderSide(color: GlobalVar.primaryOrange, width: 1),
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: SvgPicture.asset("images/dot_primary_orange_icon.svg", height: 24, width: 24,),
                                ),
                                itemBuilder: (context) {
                                    return [
                                        PopupMenuItem(
                                            value: 'Bagikan',
                                            child: Text("Bagikan", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14))
                                        ),
                                        PopupMenuItem(
                                            value: 'Download',
                                            child: Text('Download', style: GlobalVar.blackTextStyle.copyWith(fontSize: 14))
                                        )
                                    ];
                                },
                                onSelected: (String value) {
                                    if (value == "Bagikan") {
                                        GlobalVar.track("Click_option_menu_bagikan");
                                        _setContentShare(recordImages.value[index], false);
                                    } else {
                                        GlobalVar.track("Click_option_menu_download");
                                        _setContentShare(recordImages.value[index], true );
                                    }
                                }
                            )
                        )
                    )
                ]
            );
        }
    );
}

class SmartCameraHistoryBinding extends Bindings {
    BuildContext context;
    SmartCameraHistoryBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<SmartCameraHistoryController>(() => SmartCameraHistoryController(context: context));
}