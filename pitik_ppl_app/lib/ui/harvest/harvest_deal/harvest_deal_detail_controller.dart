import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
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
import 'package:model/response/harvest_detail_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 23/11/2023

class HarvestDealDetailController extends GetxController {
    BuildContext context;
    HarvestDealDetailController({required this.context});

    late Coop coop;
    Rx<Harvest?> harvest = (Harvest()).obs;

    var isLoading = false.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        harvest.value = Get.arguments[1];

        _getHarvestSubmittedDetail();
    }

    void _getHarvestSubmittedDetail() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'harvestApi',
                service: ListApi.getDetailHarvest,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, 'v2/harvest-deals/${harvest.value == null ? '-' : harvest.value!.id}'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        harvest.value = (body as HarvestDetailResponse).data;
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

    Widget getDealStatusWidget({required String statusText}) {
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

    String getBwText() => '${harvest.value == null || harvest.value!.minWeight == null ? '-' : harvest.value!.minWeight!.toStringAsFixed(1)} Kg '
                          's.d '
                          '${harvest.value == null || harvest.value!.maxWeight == null ? '-' : harvest.value!.maxWeight!.toStringAsFixed(1)} Kg';

    String getQuantityText() => '${harvest.value == null || harvest.value!.quantity == null ? '-' : Convert.toCurrencyWithoutDecimal(harvest.value!.quantity.toString(), '', '.')} Ekor';

    void pushCancelledHarvestDeal() => AuthImpl().get().then((auth) {
        if (auth != null) {
            showModalBottomSheet(
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                    )
                ),
                isScrollControlled: true,
                context: Get.context!,
                builder: (context) => Container(
                    color: Colors.transparent,
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Center(
                                        child: Container(
                                            width: 60,
                                            height: 4,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                color: GlobalVar.outlineColor
                                            )
                                        )
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Apakah yakin data yang kamu isi sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                                    const SizedBox(height: 16),
                                    Text('Pastikan tidak ada data salah dan tertinggal sebelum melakukan pembatalan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                    const SizedBox(height: 50),
                                    SizedBox(
                                        width: MediaQuery.of(Get.context!).size.width - 32,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Expanded(
                                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnAgreeHarvestDealCancel"), label: "Yakin", onClick: () {
                                                        Navigator.pop(Get.context!);
                                                        isLoading.value = true;
                                                        Service.push(
                                                            apiKey: 'harvestApi',
                                                            service: ListApi.harvestDealCancelled,
                                                            context: Get.context!,
                                                            body: ['Bearer ${auth.token}', auth.id, 'v2/harvest-deals/${harvest.value!.id}/cancel', '{}'],
                                                            listener: ResponseListener(
                                                                onResponseDone: (code, message, body, id, packet) {
                                                                    isLoading.value = false;
                                                                    Get.back();
                                                                    Get.snackbar("Pesan", 'Pembatalan Deal telah Berhasil..!', snackPosition: SnackPosition.TOP, colorText: Colors.black, backgroundColor: Colors.white);
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
                                                    })
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                    child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnNotAgreeHarvestDealCancel"), label: "Tidak Yakin", onClick: () => Navigator.pop(Get.context!))
                                                )
                                            ],
                                        ),
                                    ),
                                    const SizedBox(height: 32),
                                ]
                            )
                        )
                    )
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });
}

class HarvestDealDetailBinding extends Bindings {
    BuildContext context;
    HarvestDealDetailBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<HarvestDealDetailController>(() => HarvestDealDetailController(context: context));
}