
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../get_x_creator.dart';
import '../global_var.dart';
import '../graph_view/graph_view.dart';
import '../library/engine_library.dart';
import '../library/model_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ExpandableDeviceController extends GetxController {
    BuildContext context;
    String tag;
    ExpandableDeviceController({required this.tag, required this.context});

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

    /// The function `getHistoricalData` retrieves historical data for a specific
    /// sensor type and device, and updates the `historicalList` with the retrieved
    /// data.
    ///
    /// Args:
    ///   sensorType (String): The sensorType parameter is a String that represents
    /// the type of sensor for which historical data is being retrieved. It could be
    /// something like "temperature", "humidity", "pressure", etc.
    ///   device (Device): The "device" parameter is an object of type "Device"
    /// which represents a specific device. It likely contains information such as
    /// the device ID, name, and other relevant details.
    ///   day (int): The "day" parameter is an integer that represents the number of
    /// days for which historical data needs to be fetched. If the value of "day" is
    /// 0, it means that historical data for all available days should be fetched.
    /// Otherwise, it represents the number of days in the past for which
    void getHistoricalData(String sensorType, Device device, int day){
        isLoading.value = true;
        Service.push(
            service: ListApi.getHistoricalData,
            context: context,
            body: [
                GlobalVar.auth!.token,
                GlobalVar.auth!.id,
                GlobalVar.xAppId!,
                sensorType,
                day == 0 ? "" : day,
                ListApi.pathHistoricalData(device.deviceId!)
            ],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    if ((body as HistoricalDataResponse).data!.isNotEmpty) {
                        historicalList.value.clear();
                        if((body).data!.length == 1){
                            body.data!.add(body.data![0]);
                        }

                        for (int i = 0 ; i< (body).data!.length ; i++) {
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
                onTokenInvalid: GlobalVar.invalidResponse()
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

class ExpandableDeviceBinding extends Bindings {
    BuildContext context;
    ExpandableDeviceBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ExpandableDeviceController>(() => ExpandableDeviceController(tag: "", context:context ));
    }
}