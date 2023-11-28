
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
import 'package:model/harvest_model.dart';
import 'package:model/realization_model.dart';
import 'package:model/response/harvest_list_response.dart';
import 'package:model/response/realization_response.dart';
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 16/11/2023

class HarvestListController extends GetxController with GetSingleTickerProviderStateMixin {
    BuildContext context;
    HarvestListController({required this.context});

    late TabController tabController;
    late Coop coop;

    var isLoading = false.obs;
    RxList<Harvest?> harvestList = <Harvest?>[].obs;
    RxList<Realization?> realizationList = <Realization?>[].obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments;

        tabController = TabController(vsync: this, length: 3);
        tabController.addListener(() {
            if (tabController.index == 0) {
                getSubmittedList();
            } else if (tabController.index == 1) {
                getDealList();
            } else {
                getRealizationList();
            }
        });

        getSubmittedList();
    }

    void refreshHarvestList() {
        if (tabController.index == 0) {
            getSubmittedList();
        } else if (tabController.index == 1) {
            getDealList();
        } else {
            getRealizationList();
        }
    }

    void getSubmittedList() => _requestHarvestDataToServer(
        route: ListApi.getSubmitsHarvest
    );

    void getDealList() => _requestHarvestDataToServer(
        route: ListApi.getDealsHarvest
    );

    void getRealizationList() => _requestHarvestDataToServer(
        route: ListApi.getRealizationHarvest,
        isRealization: true
    );

    void _requestHarvestDataToServer({required String route, bool isRealization = false}) {
        isLoading.value = true;
        realizationList.clear();
        harvestList.clear();

        AuthImpl().get().then((auth) {
            if (auth != null) {
                Service.push(
                    apiKey: 'harvestApi',
                    service: route,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, coop.farmingCycleId],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if (isRealization) {
                                realizationList.value = (body as RealizationResponse).data;
                            } else {
                                harvestList.value = (body as HarvestListResponse).data;
                            }

                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar("Pesan", '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                            isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar("Pesan", exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                            isLoading.value = false;
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                );
            } else {
                GlobalVar.invalidResponse();
            }
        });
    }

    Widget createSubmittedHarvestCard({required int index, Harvest? harvest}) {
        if (harvest != null) {
            return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                child: GestureDetector(
                    onTap: () => Get.toNamed(RoutePage.harvestSubmittedDetail, arguments: [coop, harvest])!.then((value) => refreshHarvestList()),
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(width: 2, color: GlobalVar.outlineColor)),
                            color: Colors.white
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Pengajuan Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                        _getStatusWidget(statusText: harvest.statusText == null ? '-' : harvest.statusText!)
                                    ],
                                ),
                                Text('Pengajuan ${Convert.getDate(harvest.datePlanned)}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                const SizedBox(height: 12),
                                Text('Pengajuan ${index + 1}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(
                                            '${harvest.minWeight == null ? '-' : harvest.minWeight!.toStringAsFixed(1)} Kg s.d ${harvest.maxWeight == null ? '-' : harvest.maxWeight!.toStringAsFixed(1)} Kg',
                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                        )
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Jumlah Ayam (Ekor)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(
                                            '${harvest.quantity != null ? Convert.toCurrencyWithoutDecimal(harvest.quantity.toString(), '', '.') : '-'} Ekor',
                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                        )
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Alasan Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(harvest.reason ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                )
                            ]
                        )
                    )
                )
            );
        } else {
            return const SizedBox();
        }
    }

    Widget createDealHarvestCard({Harvest? harvest}) {
        if (harvest != null) {
            return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                child: GestureDetector(
                    onTap: () => Get.toNamed(RoutePage.harvestDealDetail, arguments: [coop, harvest])!.then((value) => refreshHarvestList()),
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(width: 2, color: GlobalVar.outlineColor)),
                            color: Colors.white
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Deal Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                        _getStatusWidget(statusText: harvest.statusText == null ? '-' : harvest.statusText!)
                                    ]
                                ),
                                const SizedBox(height: 12),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Tanggal Pengajuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(Convert.getDate(harvest.datePlanned), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Tanggal Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(Convert.getDate(harvest.dateHarvest), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Bakul', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(harvest.bakulName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(
                                            '${harvest.minWeight == null ? '-' : harvest.minWeight!.toStringAsFixed(1)} Kg s.d ${harvest.maxWeight == null ? '-' : harvest.maxWeight!.toStringAsFixed(1)} Kg',
                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                        )
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Jumlah Ayam (Ekor)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(
                                            '${harvest.quantity != null ? Convert.toCurrencyWithoutDecimal(harvest.quantity.toString(), '', '.') : '-'} Ekor',
                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                        )
                                    ]
                                )
                            ]
                        )
                    )
                )
            );
        } else {
            return const SizedBox();
        }
    }

    Widget createRealizationHarvestCard({Realization? realization}) {
        if (realization != null) {
            return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                child: GestureDetector(
                    onTap: () => Get.toNamed(RoutePage.harvestRealizationDetail, arguments: [coop, realization])!.then((value) => refreshHarvestList()),
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(width: 2, color: GlobalVar.outlineColor)),
                            color: Colors.white
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Deal Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                        _getStatusWidget(statusText: realization.statusText == null ? '-' : realization.statusText!)
                                    ]
                                ),
                                const SizedBox(height: 12),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Tanggal Pengajuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(realization.harvestRequestDate ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Tanggal Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(realization.harvestDate ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('No. DO', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(realization.deliveryOrder ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Bakul', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(realization.bakulName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(
                                            '${realization.minWeight == null ? '-' : realization.minWeight!.toStringAsFixed(1)} Kg s.d ${realization.maxWeight == null ? '-' : realization.maxWeight!.toStringAsFixed(1)} Kg',
                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                        )
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Jumlah Ayam (Ekor)', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(
                                            '${realization.quantity != null ? Convert.toCurrencyWithoutDecimal(realization.quantity.toString(), '', '.') : '-'} Ekor',
                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                        )
                                    ]
                                )
                            ]
                        )
                    )
                )
            );
        } else {
            return const SizedBox();
        }
    }

    Widget _getStatusWidget({required String statusText}) {
        Color background = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED || statusText == GlobalVar.NEED_APPROVAL ? GlobalVar.primaryLight2 :
                           statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.redBackground :
                           statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI ? GlobalVar.greenBackground:
                           statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI || statusText == GlobalVar.AVAILABLE ? GlobalVar.blueBackground :
                           Colors.white;

        Color textColor = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED || statusText == GlobalVar.NEED_APPROVAL ? GlobalVar.primaryOrange :
                          statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.red :
                          statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI ? GlobalVar.green:
                          statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI || statusText == GlobalVar.AVAILABLE ? GlobalVar.blue :
                          Colors.white;

        return Container(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                color: background
            ),
            child: Text(
                statusText,
                style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: textColor)
            ),
        );
    }
}

class HarvestListBinding extends Bindings {
    BuildContext context;
    HarvestListBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<HarvestListController>(() => HarvestListController(context: context));
}