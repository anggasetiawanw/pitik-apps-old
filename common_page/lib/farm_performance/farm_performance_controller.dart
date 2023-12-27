
import 'package:common_page/farm_performance/actual/farm_performance_actual_activity.dart';
import 'package:common_page/farm_performance/actual/farm_performance_actual_controller.dart';
import 'package:common_page/farm_performance/projection/farm_performance_projection_activity.dart';
import 'package:common_page/farm_performance/projection/farm_performance_projection_controller.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/farm_day_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/farm_projection/farm_projection_detail_model.dart';
import 'package:model/farm_projection/farm_projection_model.dart';
import 'package:model/response/farm_actual_response.dart';
import 'package:model/response/farm_day_history_response.dart';
import 'package:model/response/farm_projection_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 18/12/2023

class FarmPerformanceController extends GetxController {
    String tag;
    BuildContext context;
    FarmPerformanceController({required this.tag, required this.context});

    late FarmPerformanceActualActivity performanceActualActivity;
    late FarmPerformanceProjectionActivity performanceProjectionActivity;

    var isLoading = false.obs;
    var isLoadMore = false.obs;
    var isActual = true.obs;
    var page = 1.obs;
    var tabProjectionSelected = 0.obs;

    Rx<Coop?> coop = (Coop()).obs;
    Rx<FarmProjection?> projectionData = (FarmProjection()).obs;
    RxList<FarmDayHistory?> farmPerformanceHistory = <FarmDayHistory?>[].obs;

    var actualAverageWeight = '- Gram'.obs;
    var targetAverageWeight = '- Gram'.obs;
    var actualMortality = '- %'.obs;
    var targetMortality = '- %'.obs;
    var actualConsumption = '- Gram'.obs;
    var targetConsumption = '- Gram'.obs;
    var cycleDate = '-'.obs;
    var fcr = '-'.obs;
    var mortality = '-'.obs;
    var ipProjection = '-'.obs;

    @override
    void onInit() {
        super.onInit();

        Get.put(FarmPerformanceActualController(context: Get.context!));
        Get.put(FarmPerformanceProjectionController(context: Get.context!));

        performanceActualActivity = const FarmPerformanceActualActivity();
        performanceProjectionActivity = const FarmPerformanceProjectionActivity();
    }

    void refreshData() {
        if (isActual.isTrue) {
            toActual();
        } else {
            toProjection();
        }
    }

    void _resetActualData() {
        actualAverageWeight.value = '- Gram';
        targetAverageWeight.value = '- Gram';
        actualMortality.value = '- %';
        targetMortality.value = '- %';
        actualConsumption.value = '- Gram';
        targetConsumption.value = '- Gram';
        cycleDate.value = '-';
        fcr.value = '-';
        mortality.value = '-%';
        ipProjection.value = '-';
    }

    void toActual()  => AuthImpl().get().then((auth) {
        isActual.value = true;
        if (auth != null) {
            if (coop.value != null && coop.value!.farmingCycleId != null) {
                isLoading.value = true;
                _resetActualData();

                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getFarmActual,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, coop.value!.farmingCycleId],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if ((body as FarmActualResponse).data != null) {
                                // average weight
                                actualAverageWeight.value = body.data!.abw != null && body.data!.abw!.actual != null ? '${body.data!.abw!.actual!.toStringAsFixed(2)} Gram' : '- Gram';
                                targetAverageWeight.value = body.data!.abw != null && body.data!.abw!.target != null ? '${body.data!.abw!.target!.min!.toStringAsFixed(2)} Gram' : '- Gram';

                                // mortality
                                actualMortality.value = body.data!.mortality != null && body.data!.mortality!.actual != null ? '${body.data!.mortality!.actual!.toStringAsFixed(2)}%' : '- %';
                                targetMortality.value = body.data!.mortality != null && body.data!.mortality!.target != null ? '${body.data!.mortality!.target!.min!.toStringAsFixed(2)} %' : '- %';

                                // consumption
                                actualConsumption.value = body.data!.feedConsumption != null && body.data!.feedConsumption!.actual != null ? '${body.data!.feedConsumption!.actual!.toStringAsFixed(2)} Gram' : '- Gram';
                                targetConsumption.value = body.data!.feedConsumption != null && body.data!.feedConsumption!.target != null ? '${body.data!.feedConsumption!.target!.min!.toStringAsFixed(2)} Gram' : '- Gram';

                                // cycle
                                cycleDate.value = body.data!.date ?? '-';
                                fcr.value = body.data!.cycle != null && body.data!.cycle!.fcr != null ? body.data!.cycle!.fcr!.toStringAsFixed(2) : '-';
                                mortality.value = body.data!.cycle != null && body.data!.cycle!.mortality != null ? '${body.data!.cycle!.mortality!.toStringAsFixed(2)}%' : '- %';
                                ipProjection.value = body.data!.cycle != null && body.data!.cycle!.ipProjection != null ? body.data!.cycle!.ipProjection!.toStringAsFixed(2) : '-';
                            }

                            getPerformHistory();
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            getPerformHistory();
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            getPerformHistory();
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                );
            } else {
                Get.snackbar(
                    "Pesan",
                    "Data Kandang masih di proses, silahkan kembali ke beranda, lalu buka Performa kembali setelah data kandang telah selesai di proses..!",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red
                );
            }
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void toProjection() => AuthImpl().get().then((auth) {
        isActual.value = false;
        if (auth != null) {
            if (coop.value != null && coop.value!.farmingCycleId != null) {
                isLoading.value = true;
                projectionData.value = FarmProjection();

                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getFarmProjection,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, coop.value!.farmingCycleId],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if ((body as FarmProjectionResponse).data != null) {
                                projectionData.value = body.data;
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
                                backgroundColor: Colors.red
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                );
            } else {
                Get.snackbar(
                    "Pesan",
                    "Data Kandang masih di proses, silahkan kembali ke beranda, lalu buka Performa kembali setelah data kandang telah selesai di proses..!",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red
                );
            }
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void getPerformHistory({int page = 1}) => AuthImpl().get().then((auth) {
        if (auth != null) {
            if (coop.value != null && coop.value!.farmingCycleId != null) {
                isLoadMore.value = true;
                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getPerformHistory,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, coop.value!.farmingCycleId, page, 10, 'DESC'],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if ((body as FarmDayHistoryResponse).data.isNotEmpty) {
                                if (page == 1) {
                                    this.page.value = 1;
                                    farmPerformanceHistory.clear();
                                }

                                farmPerformanceHistory.addAll(body.data);
                            }

                            isLoadMore.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoadMore.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            print('$exception -> $stacktrace');
                            isLoadMore.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                );
            }
        } else {
            GlobalVar.invalidResponse();
        }
    });

    String getDayNum({FarmProjectionDetail? data, bool isCurrent = true}) {
        if (data != null) {
            if (isCurrent) {
                return data.topGraph!.current == null ? '-' : '${data.topGraph!.current!.dayNum}';
            } else {
                return data.topGraph!.current == null ? '-' : '${data.topGraph!.projected!.dayNum}';
            }
        } else {
            return '-';
        }
    }

    String getWeek(FarmProjectionDetail? data) {
        if (data != null) {
            return data.topGraph!.current == null ? 'Minggu -' : 'Minggu ${data.topGraph!.current!.dayNum! ~/ 7}';
        } else {
            return 'Minggu -';
        }
    }
}

class FarmPerformanceBinding extends Bindings {
    String tag;
    BuildContext context;
    FarmPerformanceBinding({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<FarmPerformanceController>(() => FarmPerformanceController(tag: tag, context: context));
    }
}