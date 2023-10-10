
import 'package:common_page/library/dao_impl_library.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/library/engine_library.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/coop_active_standard.dart';
import 'package:model/coop_performance.dart';
import 'package:model/response/date_monitoring_response.dart';
import 'package:model/response/monitoring_response.dart';
import 'package:model/response/monitoring_detail_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class PerformanceController extends GetxController {
    BuildContext context;
    Coop? coop;
    PerformanceController({required this.context});

    late SpinnerField performSpField;
    RxList<CoopActiveStandard?> barData = <CoopActiveStandard?> [].obs;
    RxList<List<String>> tableData = <List<String>>[[]].obs;
    Rx<SizedBox> datePerformanceField = (const SizedBox()).obs;
    Rx<CoopPerformance?> detailPerformance = (CoopPerformance()).obs;

    var isTableShow = false.obs;
    var isLoading = false.obs;
    var countRequest = 0.obs;

    @override
    void onInit() {
        super.onInit();
        performSpField = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("historyPerformanceSpinner"),
            label: "",
            hideLabel: true,
            hint: "",
            alertText: "",
            items: const {
                "BW": true,
                "IP": false,
                "FCR": false,
                "Mortality": false
            },
            onSpinnerSelected: (text) => _getBarChartDataByVariable(variable: text)
        );
        performSpField.controller.textSelected.value = "BW";
    }

    String getFeedDatePrediction() {
        if (detailPerformance.value == null || detailPerformance.value!.feed == null || detailPerformance.value!.feed!.stockoutDate == null) {
            return '-';
        } else {
            DateTime dateTime = Convert.getDatetime(detailPerformance.value!.feed!.stockoutDate!);
            return '${Convert.getDay(dateTime)}/${Convert.getMonthNumber(dateTime)}/${Convert.getYear(dateTime)}';
        }
    }

    void _getDetailMonitoringByTicketId({required String ticketId, bool isRequestBundling = false}) {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getDetailMonitoring,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop!.farmingCycleId}/daily-monitorings/$ticketId'],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            detailPerformance.value = (body as MonitoringDetailResponse).data;

                            if (isRequestBundling) {
                                _checkIsStillLoadingOrNot();
                            } else {
                                isLoading.value = false;
                            }
                        },
                        onResponseFail: (code, message, body, id, packet)  {
                            if (isRequestBundling) {
                                _checkIsStillLoadingOrNot();
                            } else {
                                isLoading.value = false;
                            }
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            if (isRequestBundling) {
                                _checkIsStillLoadingOrNot();
                            } else {
                                isLoading.value = false;
                            }
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void generateData(Coop coop) {
        isLoading.value = true;
        this.coop = coop;

        // FOR REQUEST TABLE DATA
        _getAllDataForTable();

        // FOR REQUEST BAR CHART DATA
        _getBarChartDataByVariable(variable: performSpField.controller.textSelected.value, isRequestBundling: true);

        // FOR GET DATE LIST MONITORING
        _getDateMonitoring();
    }

    void _getAllDataForTable() {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getAllDataMonitoring,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop!.farmingCycleId}/daily-monitorings'],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            tableData.value = [["Hari", "Bobot", "Pakan", "Kematian", "Culling", "OVK", "FCR", "IP"]];
                            for (var coopPerformance in (body as DateMonitoringResponse).data) {
                                tableData.add([
                                    coopPerformance!.day!.toString(),
                                    coopPerformance.bw!.actual == null ? '0' : coopPerformance.bw!.actual!.roundToDouble().toStringAsFixed(2),
                                    coopPerformance.feedIntake!.actual == null ? '0' : coopPerformance.feedIntake!.actual!.roundToDouble().toStringAsFixed(2),
                                    coopPerformance.mortality!.actual == null ? '0' : coopPerformance.mortality!.actual!.roundToDouble().toStringAsFixed(2),
                                    coopPerformance.population == null || coopPerformance.population!.culled == null ? '0' : coopPerformance.population!.culled!.roundToDouble().toStringAsFixed(2),
                                    coopPerformance.ovk == null || coopPerformance.ovk!.consumption == null ? '0' : coopPerformance.ovk!.consumption!.roundToDouble().toStringAsFixed(2),
                                    coopPerformance.fcr!.actual == null ? '0' : coopPerformance.fcr!.actual!.roundToDouble().toStringAsFixed(2),
                                    coopPerformance.ip!.actual == null ? '0' : coopPerformance.ip!.actual!.roundToDouble().toStringAsFixed(2),
                                ]);
                            }

                            _checkIsStillLoadingOrNot();
                        },
                        onResponseFail: (code, message, body, id, packet)  => _checkIsStillLoadingOrNot(),
                        onResponseError: (exception, stacktrace, id, packet) => _checkIsStillLoadingOrNot(),
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void _getBarChartDataByVariable({String variable = "bw", bool isRequestBundling = false}) {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getMonitoringByVariable,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop!.farmingCycleId}/daily-monitorings/variables/${variable.toLowerCase()}'],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            barData.value = (body as MonitorResponse).data;
                            _reconditionEmptySpaceBar();

                            if (isRequestBundling) {
                                _checkIsStillLoadingOrNot();
                            } else {
                                isLoading.value = false;
                            }
                        },
                        onResponseFail: (code, message, body, id, packet)  {
                            if (isRequestBundling) {
                                _checkIsStillLoadingOrNot();
                            } else {
                                isLoading.value = false;
                            }
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            if (isRequestBundling) {
                                _checkIsStillLoadingOrNot();
                            } else {
                                isLoading.value = false;
                            }
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void _getDateMonitoring() {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getDateMonitoring,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop!.farmingCycleId}/daily-monitorings/date'],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Map<String, CoopPerformance> dates = {};
                            Map<String, bool> dateData = {};
                            int index = 0;
                            String value = "";

                            for (var dateMonitoring in (body as DateMonitoringResponse).data) {
                                DateTime date = Convert.getDatetime(dateMonitoring!.date!);
                                dateData.putIfAbsent('${Convert.getDay(date)}/${Convert.getMonthNumber(date)}', () => index == body.data.length - 1 ? true : false);
                                dates.putIfAbsent('${Convert.getDay(date)}/${Convert.getMonthNumber(date)}', () => dateMonitoring);

                                if (index == body.data.length - 1) {
                                    value = '${Convert.getDay(date)}/${Convert.getMonthNumber(date)}';
                                }

                                index++;
                            }

                            SpinnerField spinner = SpinnerField(controller: GetXCreator.putSpinnerFieldController("datePerformanceField"), label: "", hideLabel: true, hint: "", alertText: "", items: dateData,
                                onSpinnerSelected: (text) {
                                    _getDetailMonitoringByTicketId(ticketId: dates[text]!.taskTicketId!);
                                }
                            );

                            datePerformanceField.value = SizedBox(
                                width: 120,
                                child: spinner
                            );

                            _getDetailMonitoringByTicketId(ticketId: dates[value]!.taskTicketId!, isRequestBundling: true);
                            _checkIsStillLoadingOrNot();
                        },
                        onResponseFail: (code, message, body, id, packet)  => _checkIsStillLoadingOrNot(),
                        onResponseError: (exception, stacktrace, id, packet) {
                            print('$exception -> $stacktrace');
                            _checkIsStillLoadingOrNot();
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void _checkIsStillLoadingOrNot() {
        countRequest++;
        if (countRequest.value == 4) {
            countRequest.value= 0;
            isLoading.value = false;
        }
    }

    /// The function calculates the width of a bar based on the screen width and the
    /// length of the bar data.
    ///
    /// Args:
    ///   widthScreen (double): The parameter "widthScreen" represents the width of
    /// the screen or container where the bar chart will be displayed.
    ///
    /// Returns:
    ///   a double value.
    double getBarWidth(double widthScreen) {
        if (((56 * barData.length) + 100) < widthScreen) {
            return widthScreen + 16;
        } else {
            return((56 * barData.length) + 100);
        }
    }

    void _reconditionEmptySpaceBar() {
        double outstanding = (((56 * barData.length) + 100) / MediaQuery.of(Get.context!).size.width);
        if (outstanding < 1) {
            double addEmptyData = (((MediaQuery.of(Get.context!).size.width - 100) / 56) - barData.length).roundToDouble();
            for (int i = 1; i <= addEmptyData; i++) {
                barData.add(
                    CoopActiveStandard(day: barData.length + i, actual: 0, standard: 0)
                );
            }
        }
    }
}

class PerformanceBinding extends Bindings {
    BuildContext context;
    PerformanceBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<PerformanceController>(() => PerformanceController(context: context));
    }
}