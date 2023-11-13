
import 'package:common_page/library/model_library.dart';
import 'package:common_page/smart_camera/bundle/smart_camera_list_bundle.dart';
import 'package:common_page/smart_camera/list_history/smart_camera_list_history_activity.dart';
import 'package:common_page/smart_camera/list_history/smart_camera_list_history_controller.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/sensor_position_response.dart';
import 'package:model/response/smart_camera_day_list_response.dart';
import 'package:model/smart_camera/smart_camera_day_model.dart';
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 10/11/2023

class SmartCameraListDayController extends GetxController {
    BuildContext context;
    SmartCameraListDayController({required this.context});

    late Coop coop;

    RxList<SmartCameraDay?> dayList = <SmartCameraDay?>[].obs;
    var isLoading = false.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments;
        getDayList();
    }

    void getDayList() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'smartCameraApi',
                service: ListApi.getSmartCameraListDay,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, 'v2/smart-camera/${coop.id}/records'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as SmartCameraDayListResponse).data.isNotEmpty) {
                            dayList.value = body.data.reversed.toList();
                        }

                        isLoading.value = false;
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

    SmartCameraBundle<SmartCameraListHistoryController> _smartCameraListBundle(int day) => SmartCameraBundle<SmartCameraListHistoryController>(
        getCoop: coop,
        routeHistoryDetail: ListApi.getRecordImages,
        basePath: 'v2/smart-camera/',
        day: day,
        onGetData: (controller) => AuthImpl().get().then((auth) {
            if (auth != null) {
                controller.isLoading.value = true;
                Service.push(
                    apiKey: 'smartCameraApi',
                    service: ListApi.getListDataCamera,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, GlobalVar.xAppId ?? '-', 'v2/smart-camera/${coop.id}/cameras/$day'],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if ((body as SensorPositionResponse).data.isNotEmpty) {
                                controller.totalCamera.value = body.data.length;
                                controller.sensorCameras.clear();
                                for (var result in body.data) {
                                    controller.sensorCameras.add(RecordCamera(sensor: result, recordCount: result == null ? 0 : result.recordCount));
                                }
                            }

                            DateTime timeEnd = DateTime.now();
                            GlobalVar.sendRenderTimeMixpanel("Open_smart_camera_page", controller.timeStart, timeEnd);
                            controller.isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            controller.isLoading.value = false;
                            Get.snackbar(
                                "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            controller.isLoading.value = false;
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
        })
    );

    Widget addCard({bool isRedChild = false, required SmartCameraDay smartCameraDay}) {
        DateTime date = Convert.getDatetime(smartCameraDay.date!);
        return GestureDetector(
            onTap: () => Get.toNamed(RoutePage.listSmartCameraHistory, arguments: _smartCameraListBundle(smartCameraDay.day ?? -1)),
            child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(width: isRedChild ? 0 : 1.4, color: GlobalVar.outlineColor),
                    borderRadius: BorderRadius.circular(8),
                    color: isRedChild ? GlobalVar.redBackground : Colors.transparent
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text("Hari Ke ${smartCameraDay.day}", style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 16, overflow: TextOverflow.clip, color: isRedChild ? GlobalVar.red : GlobalVar.black)),
                                                        Text("${Convert.getYear(date)}-${Convert.getMonthNumber(date)}-${Convert.getDay(date)}", style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 10, overflow: TextOverflow.clip, color: GlobalVar.grayText)),
                                                    ],
                                                ),
                                                const SizedBox(height: 6),
                                                smartCameraDay.recordCount == null || smartCameraDay.recordCount == 0 ? Text(
                                                    "Belum ada record",
                                                    style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip, color: isRedChild ? GlobalVar.red : GlobalVar.black)
                                                ) : Expanded(
                                                    child: Row(
                                                        children: [
                                                            Text("Jumlah Record:", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                            const SizedBox(width: 4),
                                                            Text("${smartCameraDay.recordCount} Ekor", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                        ],
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }
}

class SmartCameraListDayBinding extends Bindings {
    BuildContext context;
    SmartCameraListDayBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<SmartCameraListDayController>(() => SmartCameraListDayController(context: context));
}