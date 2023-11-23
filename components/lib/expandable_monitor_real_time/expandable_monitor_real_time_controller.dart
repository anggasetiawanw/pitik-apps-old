
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/graph_line.dart';
import 'package:model/response/historical_data_response.dart';
import 'package:model/response/sensor_position_response.dart';
import 'package:model/sensor_model.dart';

import '../get_x_creator.dart';
import '../global_var.dart';
import '../graph_view/graph_view.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ExpandableMonitorRealTimeController extends GetxController {
    BuildContext context;
    String tag;
    ExpandableMonitorRealTimeController({required this.tag, required this.context});

    var expanded = false.obs;
    var isLoading = false.obs;
    var indexTab = 0.obs;
    Rx<List<GraphLine>> historicalList = Rx<List<GraphLine>>([]);
    Rx<List<GraphView>> graphViews = Rx<List<GraphView>>([]);
    RxList<Sensor?> sensorPositionList = <Sensor?>[].obs;

    late GraphView gvSmartMonitoring;

    @override
    void onInit() {
        super.onInit();
        gvSmartMonitoring = GraphView(
            controller: GetXCreator.putGraphViewController("gvSmartMonitoring$tag"),
        );
    }

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;

    void getRealTimeHistoricalDataForSmartController({required String sensorType, required int day, required String deviceIdForController, required String coopIdForController})  => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            List<dynamic> bodyRequest = ['Bearer ${auth.token}', auth.id, sensorType, deviceIdForController, day, coopIdForController, 'asc'];
            _pushToServerForHistoricalData(
                sensorType: sensorType,
                route: ListApi.getRealTimeHistoricalForSmartController,
                bodyRequest: bodyRequest,
                roomId: ''
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void getRealTimeHistoricalData({required String sensorType, required int day, required Coop coop, required String roomId}) => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            List<dynamic> bodyRequest = ['Bearer ${auth.token}', auth.id, sensorType, coop.farmingCycleId, day, coop.farmId, coop.id, roomId];
            _pushToServerForHistoricalData(
                sensorType: sensorType,
                route: ListApi.getRealTimeHistorical,
                bodyRequest: bodyRequest,
                roomId: roomId
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void _pushToServerForHistoricalData({required String sensorType, required String route, required List<dynamic> bodyRequest, required String roomId}) {
        Service.push(
            apiKey: 'smartMonitoringApi',
            service: route,
            context: context,
            body: bodyRequest,
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    historicalList.value.clear();
                    if ((body as HistoricalDataResponse).data!.isNotEmpty) {
                        if ((body).data!.length == 1) {
                            body.data!.add(body.data![0]);
                        }

                        for (int i = 0 ; i < (body).data!.length ; i++) {
                            historicalList.value.add(GraphLine(order: i, benchmarkMax: body.data![i]!.benchmarkMax, benchmarkMin: body.data![i]!.benchmarkMin, label: body.data![i]!.label, current: body.data![i]!.current));
                        }
                    }

                    loadData(historicalList, sensorType);
                    sensorPositionList.clear();
                    if (sensorType == "temperature" || sensorType == "relativeHumidity") {
                        getSensorPosition(sensorType: sensorType, roomId: roomId);
                    } else {
                        isLoading.value = false;
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
                onResponseError: (exception, stacktrace, id, packet) =>isLoading.value = false,
                onTokenInvalid: () => GlobalVar.invalidResponse()
            )
        );
    }

    void getSensorPosition({String sensorType = "temperature", required String roomId}) {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'smartMonitoringApi',
                    service: ListApi.getSensorPosition,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, roomId, sensorType],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            sensorPositionList.value = (body as SensorPositionResponse).data;
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
                        onResponseError: (exception, stacktrace, id, packet) => isLoading.value = false,
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void loadData(Rx<List<GraphLine>> historicalList, String sensorType) {
        if (sensorType == "temperature" || sensorType == "relativeHumidity" || sensorType == "heatStressIndex") {
            gvSmartMonitoring.controller
                .setUom(sensorType == "temperature" ? '\u00B0C' : sensorType == "relativeHumidity" ? '%' : '')
                .setLineCurrentColor(GlobalVar.primaryOrange)
                .setLineMinColor(GlobalVar.green)
                .setLineMaxColor(GlobalVar.green)
                .setBackgroundMax(const Color.fromARGB(150, 206, 252, 216))
                .setBackgroundCurrentTooltip(const Color(0xFFFFF6ED))
                .setBackgroundMaxTooltip(GlobalVar.green)
                .setBackgroundMinTooltip(GlobalVar.green)
                .setTextColorCurrentTooltip(GlobalVar.primaryOrange)
                .setTextColorMinTooltip(GlobalVar.green)
                .setTextColorMaxTooltip(GlobalVar.green);
        } else if (sensorType == "wind" || sensorType == "lights") {
            gvSmartMonitoring.controller
                .setUom(sensorType == "wind" ? 'm/s' : 'Lux')
                .setLineCurrentColor(GlobalVar.primaryOrange)
                .setTextColorCurrentTooltip(GlobalVar.primaryOrange);
        } else if (sensorType == "ammonia") {
            gvSmartMonitoring.controller
                .setUom('ppm')
                .setLineCurrentColor(GlobalVar.primaryOrange)
                .setTextColorCurrentTooltip(GlobalVar.primaryOrange);
        }

        gvSmartMonitoring.controller.clearData();
        gvSmartMonitoring.controller.setupData(historicalList.value);
        historicalList.value.clear();
        historicalList.refresh();
    }

    void showSensorMappingBottomSheet() {
        showModalBottomSheet(
            isScrollControlled: true,
            context: Get.context!,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                )
            ),
            builder: (context) => Container(
                color: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Container(
                                    width: 60,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        color: GlobalVar.outlineColor
                                    )
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Tata letak sensor dalam kandang", style: GlobalVar.subTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange))
                                )
                            ),
                            const SizedBox(height: 16),
                            GridView(
                                controller: ScrollController(keepScrollOffset: false),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisExtent: 28,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: List.generate(sensorPositionList.length, (index) {
                                    return Row(
                                        children: [
                                            Container(
                                                width: 2,
                                                height: 2,
                                                decoration: const BoxDecoration(
                                                    color: GlobalVar.black,
                                                    shape: BoxShape.circle
                                                ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                                sensorPositionList[index] == null || sensorPositionList[index]!.position == null ? '-' : sensorPositionList[index]!.position!,
                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                            )
                                        ],
                                    );
                                }),
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SvgPicture.asset('images/sensor_mapping.svg'),
                            ),
                            const SizedBox(height: 32)
                        ]
                    )
                )
            )
        );
    }
}

class ExpandableMonitorRealTimeBinding extends Bindings {
    BuildContext context;
    ExpandableMonitorRealTimeBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ExpandableMonitorRealTimeController>(() => ExpandableMonitorRealTimeController(tag: "", context:context ));
    }
}