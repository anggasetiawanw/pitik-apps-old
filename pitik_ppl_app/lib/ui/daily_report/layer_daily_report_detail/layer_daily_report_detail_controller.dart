
// ignore_for_file: non_constant_identifier_names

import 'package:common_page/library/component_library.dart';
import 'package:common_page/library/engine_library.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/product_model.dart';
import 'package:model/report.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:pitik_ppl_app/utils/enums/daily_report_enum.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/01/2024

class LayerDailyReportDetailController extends GetxController {
    BuildContext context;
    LayerDailyReportDetailController({required this.context});

    final String REQUESTED = 'REQUESTED';
    final String REVISED = 'REVISED';

    late Coop coop;
    late Report reportArguments;

    Rx<Report> report = Report().obs;
    Rx<Column> feedConsumptionWidget = const Column().obs;
    Rx<Column> ovkConsumptionWidget = const Column().obs;
    late ButtonFill bfEdit;
    late ButtonFill bfRevision;

    var isLoading = false.obs;
    var isCanRevision = false.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        reportArguments = Get.arguments[1];
        report.value = Get.arguments[1];

        bfEdit = ButtonFill(controller: GetXCreator.putButtonFillController("layerDailyDetailEdit"), label: "Edit", onClick: () {
            report.value.date = reportArguments.date;
            report.value.status = reportArguments.status;

            Get.toNamed(RoutePage.layerDailyReportForm, arguments: [coop, report.value])!.then((value) {
                if (value != null) {
                    Get.back();
                    Get.snackbar(
                        "Pesan",
                        "Berhasil melakukan permintaan edit...",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.black,
                        backgroundColor: Colors.white,
                    );
                } else {
                    getDetailReport();
                }
            });
        });
        bfRevision = ButtonFill(controller: GetXCreator.putButtonFillController("layerDailyDetailRevision"), label: "Permintaan Edit", onClick: () {
            report.value.date = reportArguments.date;
            report.value.status = reportArguments.status;

            Get.toNamed(RoutePage.layerDailyReportRevision, arguments: [coop, report.value])!.then((value) {
                if (value != null) {
                    Get.back();
                } else {
                    getDetailReport();
                }
            });
        });
    }

    @override
    void onReady() {
        super.onReady();
        getDetailReport();
    }

    void getDetailReport() => AuthImpl().get().then((auth) => {
        if (auth != null) {
            isLoading.value = true,
            Service.push(
                apiKey: ApiMapping.taskApi,
                service: ListApi.getDetailDailyReport,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, ListApi.pathDailyReportDetail(coop.farmingCycleId!, reportArguments.date!)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if (body.data != null) {
                            report.value = body.data as Report;
                            isCanRevision.value = (reportArguments.status == EnumDailyReport.LATE || reportArguments.status == EnumDailyReport.FINISHED) && report.value.revisionStatus == null;
                        }

                        generateProductCards(productList: report.value.feedConsumptions ?? [], isFeed: true);
                        generateProductCards(productList: report.value.ovkConsumptions ?? []);
                        isLoading.value = false;
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                        );
                        isLoading.value = false;
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                        );
                        isLoading.value = false;
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            )
        } else {
            GlobalVar.invalidResponse()
        }
    });

    void generateProductCards({required List<Product?> productList, bool isFeed = false}) {
        Column dataWidget =  Column(
            children: List.generate(productList.length, (index) {
                if (productList[index] != null) {
                    Product product = productList[index]!;
                    return Container(
                        width: MediaQuery.of(Get.context!).size.width,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Merek', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                const SizedBox(height: 4),
                                Text(
                                    isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? '',
                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                ),
                                const SizedBox(height: 12),
                                if (isFeed) ...[
                                    Text('Total', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                    const SizedBox(height: 4),
                                    Text(
                                        '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}',
                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                    )
                                ] else ...[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text('Total', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                        '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}',
                                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                    )
                                                ]
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                    Text('Alasan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    const SizedBox(height: 4),
                                                    Text(product.remarks ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                ]
                                            )
                                        ]
                                    )
                                ]
                            ]
                        )
                    );
                } else {
                    return const SizedBox();
                }
            })
        );

        if (isFeed) {
            feedConsumptionWidget.value = dataWidget;
        } else {
            ovkConsumptionWidget.value = dataWidget;
        }
    }

    String getEggQuantity({required String productName}) {
        for (var egg in report.value.harvestedEgg) {
            if (egg != null && egg.productItem!.name == productName) {
                return '${egg.quantity ?? '-'} butir';
            }
        }

        return '- butir';
    }

    String getEggWeight({required String productName}) {
        for (var egg in report.value.harvestedEgg) {
            if (egg != null && egg.productItem!.name == productName) {
                return '${egg.weight ?? '-'} kg';
            }
        }

        return '- kg';
    }

    String getTotal() {
        int result = 0;
        for (var egg in report.value.harvestedEgg) {
            if (egg != null) {
                result += egg.quantity ?? 0;
            }
        }

        return '${Convert.toCurrencyWithoutDecimal(result.toString(), '', '.')} Butir';
    }

    String getTotalWeight() {
        double result = 0;
        for (var egg in report.value.harvestedEgg) {
            if (egg != null) {
                result += egg.weight ?? 0;
            }
        }

        return '${Convert.toCurrencyWithDecimal(result.toString(), '', '.', ',')} kg';
    }
}

class LayerDailyReportDetailBinding extends Bindings {
    BuildContext context;
    LayerDailyReportDetailBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<LayerDailyReportDetailController>(() => LayerDailyReportDetailController(context: context));
}