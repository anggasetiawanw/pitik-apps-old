
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/error/error.dart';
import 'package:model/graph_line.dart';
import 'package:model/response/historical_data_response.dart';

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

    void expand() {
        expanded.value = true;
    }
    void collapse() => expanded.value = false;

    GraphView gvSmartMonitoring = GraphView(
        controller: GetXCreator.putGraphViewController("gvSmartMonitoring"),
    );

    void getRealTimeHistoricalData({required String sensorType, required int day, required Coop coop, required String roomId}){
        isLoading.value = true;
        Service.push(
            apiKey: 'smartMonitoringApi',
            service: ListApi.getRealTimeHistorical,
            context: context,
            body: [
                GlobalVar.auth!.token,
                GlobalVar.auth!.id,
                sensorType,
                coop.farmingCycleId,
                day,
                coop.farmId,
                coop.id,
                roomId
            ],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    if ((body as HistoricalDataResponse).data!.isNotEmpty) {
                        historicalList.value.clear();
                        if ((body).data!.length == 1) {
                            body.data!.add(body.data![0]);
                        }

                        for (int i = 0 ; i < (body).data!.length ; i++) {
                            historicalList.value.add(GraphLine(order: i, benchmarkMax: body.data![i]!.benchmarkMax, benchmarkMin: body.data![i]!.benchmarkMin, label: body.data![i]!.label, current: body.data![i]!.current));
                        }
                    }

                    loadData(historicalList, sensorType);
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
                onResponseError: (exception, stacktrace, id, packet) =>isLoading.value = false,
                onTokenInvalid: () => GlobalVar.invalidResponse()
            )
        );
    }

    void loadData(Rx<List<GraphLine>> historicalList, String sensorType) {
        if (sensorType == "temperature" || sensorType == "relativeHumidity" || sensorType == "heatStressIndex") {
            gvSmartMonitoring.controller
                .setUom('\u00B0C')
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
            gvSmartMonitoring.controller.setLineCurrentColor(GlobalVar.primaryOrange).
            setTextColorCurrentTooltip(GlobalVar.primaryOrange);
        } else if (sensorType == "ammonia") {
            gvSmartMonitoring.controller.setLineCurrentColor(GlobalVar.primaryOrange).
            setTextColorCurrentTooltip(GlobalVar.primaryOrange);
        }

        gvSmartMonitoring.controller.clearData();
        gvSmartMonitoring.controller.setupData(historicalList.value);
        historicalList.value.clear();
        historicalList.refresh();
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