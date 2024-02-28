import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/building_model.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_summary_model.dart';
import 'package:model/error/error.dart';
import 'package:model/graph_line.dart';
import 'package:model/response/building_response.dart';
import 'package:model/response/latest_condition_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class DetailSmartMonitorController extends GetxController {
  String tag;
  BuildContext context;
  Coop? coop;
  Device? device;
  DeviceSummary? bundleLatestCondition;
  bool? useBundleLatestCondition;
  bool skipLoadBuildings;

  DetailSmartMonitorController({required this.tag, required this.context, this.coop, this.device, this.bundleLatestCondition, this.useBundleLatestCondition, this.skipLoadBuildings = false});

  ScrollController scrollController = ScrollController();
  Rx<DeviceSummary?> deviceSummary = DeviceSummary().obs;
  Rx<List<GraphLine>> historicalList = Rx<List<GraphLine>>([]);
  Rx<SpinnerField> spBuilding = (SpinnerField(controller: GetXCreator.putSpinnerFieldController<Building>("buildingSpField"), label: "", hideLabel: true, hint: "", alertText: "", items: const {}, onSpinnerSelected: (text) {})).obs;
  var deviceUpdatedName = "".obs;

  var isLoadMore = false.obs;
  var pageSmartMonitor = 1.obs;
  var limit = 10.obs;

  ScrollController scrollMonitorController = ScrollController();

  scrollPurchaseListener() async {
    scrollMonitorController.addListener(() {
      if (scrollMonitorController.position.maxScrollExtent == scrollMonitorController.position.pixels) {
        isLoadMore.value = true;
        pageSmartMonitor++;
      }
    });
  }

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getInitialLatestDataSmartMonitor();
  }

  void rejuvenateCoop({required Coop newCoop}) => coop = newCoop;
  void getInitialLatestDataSmartMonitor() {
    if (useBundleLatestCondition == null || !useBundleLatestCondition!) {
      if (skipLoadBuildings) {
        _getLatestDataSmartMonitor('');
      } else {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
              if (auth != null)
                {
                  Service.push(
                      apiKey: 'smartMonitoringApi',
                      service: ListApi.getListBuilding,
                      context: context,
                      body: ['Bearer ${auth.token}', auth.id, 'v2/buildings/coops/${coop!.id ?? coop!.coopId}'],
                      listener: ResponseListener(
                          onResponseDone: (code, message, body, id, packet) {
                            Map<String, bool> data = {};
                            int index = 0;
                            for (var building in (body as BuildingResponse).data) {
                              if (building != null && building.buildingName != null && building.roomTypeName != null) {
                                if (index == 0) {
                                  data.putIfAbsent('${building.buildingName} (${building.roomTypeName})', () => true);
                                } else {
                                  data.putIfAbsent('${building.buildingName} (${building.roomTypeName})', () => false);
                                }
                              }

                              index++;
                            }

                            spBuilding.value = SpinnerField(
                                controller: GetXCreator.putSpinnerFieldController<Building>("buildingSpField"),
                                label: "",
                                hideLabel: true,
                                hint: "",
                                alertText: "",
                                items: data,
                                backgroundField: Colors.white,
                                onSpinnerSelected: (text) => _getLatestDataSmartMonitor(spBuilding.value.getController().selectedObject == null || (spBuilding.value.getController().selectedObject as Building).roomId == null
                                    ? ''
                                    : (spBuilding.value.getController().selectedObject as Building).roomId!));

                            spBuilding.value.getController().generateItems(data);
                            spBuilding.value.getController().setupObjects(body.data);
                            spBuilding.value.getController().rejuvenateObjects();
                            _getLatestDataSmartMonitor(
                                spBuilding.value.getController().selectedObject == null || (spBuilding.value.getController().selectedObject as Building).roomId == null ? '' : (spBuilding.value.getController().selectedObject as Building).roomId!);
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
                          onResponseError: (exception, stacktrace, id, packet) => isLoading.value = false,
                          onTokenInvalid: () => GlobalVar.invalidResponse()))
                }
              else
                {GlobalVar.invalidResponse()}
            });
      }
    } else {
      deviceSummary.value = bundleLatestCondition;
    }
  }

  /// The function `getLatestDataSmartMonitor` retrieves the latest data from a
  /// smart monitor device and updates the device summary.
  void _getLatestDataSmartMonitor(String? roomId) => AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          List request = [];

          if (device == null) {
            request = ['Bearer ${auth.token}', auth.id, coop!.farmingCycleId, roomId];
          } else {
            request = ['Bearer ${auth.token}', auth.id, GlobalVar.xAppId ?? '-', ListApi.pathLatestCondition(device!.deviceId!)];
          }

          Service.push(
              apiKey: 'smartMonitoringApi',
              service: ListApi.getLatestCondition,
              context: context,
              body: request,
              listener: ResponseListener(
                  onResponseDone: (code, message, body, id, packet) {
                    if ((body as LatestConditionResponse).data != null) {
                      deviceSummary.value = body.data;
                    }
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
                    Get.snackbar(
                      "Pesan",
                      "Terjadi Kesalahan Internal",
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      backgroundColor: Colors.red,
                    );
                  },
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        } else {
          GlobalVar.invalidResponse();
        }
      });
}

class DetailSmartMonitorBindings extends Bindings {
  String tag;
  BuildContext context;
  DetailSmartMonitorBindings({required this.tag, required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => DetailSmartMonitorController(tag: tag, context: context));
  }
}
