import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/table_field/table_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/array_util.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/response/realization_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class HarvestController extends GetxController {
    BuildContext context;
    HarvestController({required this.context});

    var isLoading = false.obs;
    Rx<TableField> tableLayout = (TableField(controller: GetXCreator.putTableFieldController("harvestTable"))).obs;

    void generateData(Coop coop) {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getListHarvestRealization,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, coop.farmingCycleId],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            List<List<String>> data = [["Tanggal Realisasi", "No DO", "Bakul", "No Timbang", "Total Ayam", "Total Tonase", "Rata-rata"]];
                            for (var realization in (body as RealizationResponse).data) {
                                if (realization != null) {
                                    data.add([
                                        realization.harvestDate ?? '-',
                                        realization.deliveryOrder ?? '-',
                                        realization.bakulName ?? '-',
                                        realization.records.isEmpty || realization.records[0]!.weighingNumber == null ? '-' : realization.records[0]!.weighingNumber!,
                                        realization.quantity != null ? realization.quantity.toString() : '-',
                                        realization.tonnage != null ? realization.tonnage!.toStringAsFixed(2) : '-',
                                        realization.averageChickenWeighed != null ? realization.averageChickenWeighed!.toStringAsFixed(2) : '-'
                                    ]);
                                }
                            }

                            tableLayout.value.controller.generateData(data: ArrayUtil().transpose<String>(data), useSticky: true, heightData: 45, widthData: 110);
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) => isLoading.value = false,
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }
}

class HarvestBinding extends Bindings {
    BuildContext context;
    HarvestBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<HarvestController>(() => HarvestController(context: context));
    }
}