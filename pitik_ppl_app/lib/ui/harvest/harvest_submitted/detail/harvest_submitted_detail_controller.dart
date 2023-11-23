import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
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
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 17/11/2023

class HarvestSubmittedDetailController extends GetxController {
    BuildContext context;
    HarvestSubmittedDetailController({required this.context});

    late Coop coop;
    late EditAreaField rejectReasonAreaField;

    var isLoading = false.obs;
    var isCancel = false.obs;

    Rx<Harvest?> harvest = (Harvest()).obs;
    Rx<Widget> containerButtonBottom = (const SizedBox(width: 0, height: 0)).obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        harvest.value = Get.arguments[1];
        if (Get.arguments.length > 2) {
            isCancel.value = Get.arguments[2];
        }

        rejectReasonAreaField = EditAreaField(controller: GetXCreator.putEditAreaFieldController("harvestSubmittedRejectReason"), label: "Alasan", hint: "Tulis Alasan disini...", alertText: "Alasan belum diisi..!", maxInput: 250,
            onTyping: (text, field) {}
        );
        _getHarvestSubmittedDetail();
    }

    void _getHarvestSubmittedDetail() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'harvestApi',
                service: ListApi.getDetailHarvest,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, 'v2/harvest-requests/${harvest.value == null ? '-' : harvest.value!.id}'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        harvest.value = (body as HarvestDetailResponse).data;
                        _generateButtonBottom();
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

    String getBwText() {
        return '${harvest.value == null || harvest.value!.minWeight == null ? '-' : harvest.value!.minWeight!.toStringAsFixed(1)} Kg '
               's.d '
               '${harvest.value == null || harvest.value!.maxWeight == null ? '-' : harvest.value!.maxWeight!.toStringAsFixed(1)} Kg';
    }

    String getQuantityText() {
        return '${harvest.value == null || harvest.value!.quantity == null ? '-' : Convert.toCurrencyWithoutDecimal(harvest.value!.quantity.toString(), '', '.')} Ekor';
    }

    Widget getStatusWidget() {
        String statusText = harvest.value == null ? '-' : harvest.value!.statusText ?? '-';
        Color background = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED ? GlobalVar.primaryLight2 :
                           statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.redBackground :
                           statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI ? GlobalVar.greenBackground:
                           statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI ? GlobalVar.blueBackground :
                           Colors.white;

        Color textColor = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED ? GlobalVar.primaryOrange :
                          statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.red :
                          statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI ? GlobalVar.green:
                          statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI ? GlobalVar.blue :
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
            )
        );
    }

    void _generateButtonBottom() {
        if (isCancel.isTrue) {
            containerButtonBottom.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnHarvestSubmittedSendCancel"), label: "Simpan", onClick: () => _rejectOrder()),
                                )
                            ]
                        )
                    )
                ),
            );
        } else if (harvest.value!.statusText == GlobalVar.SUBMITTED) {
            containerButtonBottom.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnHarvestSubmittedEdit"), label: "Edit", onClick: () => Get.toNamed(RoutePage.harvestSubmittedDetail, arguments: [
                                        coop, harvest.value, true
                                    ])),
                                )
                            ]
                        )
                    )
                ),
            );
        } else if (harvest.value!.statusText == GlobalVar.NEED_APPROVAL) {
            containerButtonBottom.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnHarvestSubmittedApprove"), label: "Setujui", onClick: () => _approveOrder()),
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnHarvestSubmittedReject"), label: "Tolak", onClick: () {
                                    isCancel.value = true;
                                    _generateButtonBottom();
                                }))
                            ]
                        )
                    )
                ),
            );
        } else {
            containerButtonBottom.value = const SizedBox(width: 0, height: 0);
        }
    }

    void _approveOrder() {
        isLoading.value = true;
        AuthImpl().get().then((auth) {
            if (auth != null) {
                Service.push(
                    apiKey: 'harvestApi',
                    service: ListApi.approveOrRejectHarvest,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, 'v2/harvest-requests/${harvest.value!.id}/approve', ''],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.off(TransactionSuccessActivity(
                                keyPage: "harvestSubmittedApprove${harvest.value!.id}",
                                message: "Kamu telah menyetujui permintaan panen",
                                showButtonHome: false,
                                onTapClose: () => Get.back(),
                                onTapHome: () {}
                            ));
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

    void _rejectOrder() {
        if (rejectReasonAreaField.getInput().isNotEmpty) {
            isLoading.value = true;
            AuthImpl().get().then((auth) {
                if (auth != null) {
                    Service.push(
                        apiKey: 'harvestApi',
                        service: ListApi.approveOrRejectHarvest,
                        context: context,
                        body: ['Bearer ${auth.token}', auth.id, 'v2/harvest-requests/${harvest.value!.id}/reject', rejectReasonAreaField.getInput()],
                        listener: ResponseListener(
                            onResponseDone: (code, message, body, id, packet) {
                                isLoading.value = false;
                                Get.off(TransactionSuccessActivity(
                                    keyPage: "harvestSubmitted${harvest.value!.id}",
                                    message: 'Kamu telah menolak permintaan panen',
                                    showButtonHome: false,
                                    icon: Image.asset(
                                        "images/information_orange_icon.gif",
                                        height: 200,
                                        width: 200,
                                    ),
                                    onTapClose: () => Get.back(),
                                    onTapHome: () {}
                                ));
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
        } else {
            rejectReasonAreaField.getController().showAlert();
        }
    }
}

class HarvestSubmittedDetailBinding extends Bindings {
    BuildContext context;
    HarvestSubmittedDetailBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<HarvestSubmittedDetailController>(() => HarvestSubmittedDetailController(context: context));
}