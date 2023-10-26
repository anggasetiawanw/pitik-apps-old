
// ignore_for_file: constant_identifier_names

import 'package:components/button_fill/button_fill.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/procurement_model.dart';
import 'package:model/response/procurement_list_response.dart';
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ListTransferController extends GetxController with GetSingleTickerProviderStateMixin {
    BuildContext context;
    ListTransferController({required this.context});

    late TabController tabController;
    late Coop coop;

    var isLoading = false.obs;
    RxList<Procurement?> transferList = <Procurement?>[].obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments;

        tabController = TabController(vsync: this, length: 2);
        tabController.addListener(() {
            if (tabController.index == 0) {
                getListSend();
            } else {
                getListReceived();
            }
        });

        getListSend();
    }

    void getListSend({String? type, String? fromDate, String? untilDate}) => _requestTransferDataToServer(
        route: ListApi.getListTransferSend,
        type: type,
        fromDate: fromDate,
        untilDate: untilDate
    );

    void getListReceived({String? type, String? fromDate, String? untilDate}) => _requestTransferDataToServer(
        route: ListApi.getListTransferReceived,
        type: type,
        fromDate: fromDate,
        untilDate: untilDate,
        status: "approved"
    );

    void _requestTransferDataToServer({required String route, String? type, String? fromDate, String? untilDate, String? status}) {
        isLoading.value = true;
        AuthImpl().get().then((auth) {
            if (auth != null) {
                List<dynamic> body = ['Bearer ${auth.token}', auth.id, coop.farmingCycleId, type, fromDate, untilDate, status];
                if (tabController.index == 0) {
                    body = ['Bearer ${auth.token}', auth.id, coop.farmingCycleId, type, fromDate, untilDate];
                }

                Service.push(
                    apiKey: 'productReportApi',
                    service: route,
                    context: Get.context!,
                    body: body,
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            transferList.value = (body as ProcurementListResponse).data;
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
    
    Widget _getStatusTransferWidget({required int tabPosition, required String statusText}) {
        Color background = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SEBAGIAN || statusText == GlobalVar.NEED_APPROVAL || statusText == GlobalVar.SUBMITTED ? GlobalVar.primaryLight2 :
                           statusText == GlobalVar.DIPROSES ? GlobalVar.primaryLight3 :
                           statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.redBackground :
                           statusText == GlobalVar.LENGKAP || statusText == GlobalVar.DITERIMA ? GlobalVar.greenBackground:
                           statusText == GlobalVar.DIKIRIM || statusText == GlobalVar.DISETUJUI ? GlobalVar.blueBackground :
                           Colors.white;

        Color textColor = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SEBAGIAN || statusText == GlobalVar.NEED_APPROVAL || statusText == GlobalVar.SUBMITTED ? GlobalVar.primaryOrange :
                          statusText == GlobalVar.DIPROSES ? GlobalVar.yellow :
                          statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.red :
                          statusText == GlobalVar.LENGKAP || statusText == GlobalVar.DITERIMA ? GlobalVar.green:
                          statusText == GlobalVar.DIKIRIM || statusText == GlobalVar.DISETUJUI ? GlobalVar.blue :
                          Colors.white;

        if (statusText == GlobalVar.DISETUJUI && tabPosition == 0) {
            background = GlobalVar.greenBackground;
            textColor = GlobalVar.green;
        }

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

    void refreshTransferList() {
        if (tabController.index == 0) {
            getListSend();
        } else {
            getListReceived();
        }
    }

    Widget createTransferCard({required int typePosition, Procurement? procurement}) {
        if (procurement != null) {
            String title = 'N/A';
            if (typePosition == 0) {
                title = procurement.coopTargetName ?? 'N/A';
            } else {
                title = procurement.coopSourceName ?? 'N/A';
            }

            return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                child: GestureDetector(
                    onTap: () {
                        if (typePosition == 0) {
                            Get.toNamed(RoutePage.transferDetailPage, arguments: [coop, procurement, typePosition == 0])!.then((value) => refreshTransferList());
                        } else {
                            Get.toNamed(RoutePage.confirmationReceivedPage, arguments: [coop, procurement])!.then((value) => refreshTransferList());
                        }
                    },
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
                                        Text(title, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                        _getStatusTransferWidget(tabPosition: typePosition, statusText: procurement.statusText == null ? '-' : procurement.statusText!)
                                    ],
                                ),
                                Text('Pengiriman ${procurement.deliveryDate == null ? '-' : procurement.deliveryDate!}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text(typePosition == 0 ? 'Kandang Tujuan' : 'Asal Kandang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Text(procurement.coopTargetName == null || procurement.coopTargetName == '' ? procurement.branchTargetName! : procurement.coopTargetName!, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text(procurement.type == null ? 'N/A' : procurement.type == 'pakan' ? 'Merek Pakan' : 'Jenis OVK', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        const SizedBox(width: 16),
                                        Expanded(child: Text(procurement.description == null ? '-' : procurement.description!, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black), textAlign: TextAlign.right))
                                    ],
                                )
                            ]
                        )
                    ),
                ),
            );
        } else {
            return const SizedBox();
        }
    }

    void showMenuBottomSheet() {
        DateTimeField fromDateField = DateTimeField(
            controller: GetXCreator.putDateTimeFieldController("filterTransferFromDateField"), label: "Tanggal Dari", hint: "Pilih tanggal", alertText: "Tanggal harus dipilih..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}')
        );

        DateTimeField untilDateField = DateTimeField(
            controller: GetXCreator.putDateTimeFieldController("filterTransferUntilDateField"), label: "Tanggal Sampai", hint: "Pilih tanggal", alertText: "Tanggal harus dipilih..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}')
        );

        SpinnerField typeField = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("filterTransferTypeField"), label: "Jenis Transfer", hint: "Pilih salah satu", alertText: "Harus pilih jenis..!", items: const {"Pakan": false, "OVK": false},
            onSpinnerSelected: (textSelected) {}
        );

        showModalBottomSheet(
            backgroundColor: Colors.white,
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
                                fromDateField,
                                untilDateField,
                                typeField,
                                const SizedBox(height: 50),
                                ButtonFill(controller: GetXCreator.putButtonFillController("btnFilterTransferList"), label: "Konfirmasi Filter", onClick: () {
                                    bool isPass = true;

                                    if (fromDateField.getController().textSelected.isEmpty) {
                                        fromDateField.getController().showAlert();
                                        isPass = false;
                                    }
                                    if (untilDateField.getController().textSelected.isEmpty) {
                                        untilDateField.getController().showAlert();
                                        isPass = false;
                                    }
                                    if (typeField.getController().textSelected.isEmpty) {
                                        typeField.getController().showAlert();
                                        isPass = false;
                                    }

                                    if (isPass) {
                                        Navigator.pop(Get.context!);
                                        if (tabController.index == 0) {
                                            getListSend(
                                                type: typeField.getController().textSelected.value.toLowerCase(),
                                                fromDate: fromDateField.getLastTimeSelectedText(),
                                                untilDate: untilDateField.getLastTimeSelectedText()
                                            );
                                        } else {
                                            getListReceived(
                                                type: typeField.getController().textSelected.value.toLowerCase(),
                                                fromDate: fromDateField.getLastTimeSelectedText(),
                                                untilDate: untilDateField.getLastTimeSelectedText()
                                            );
                                        }
                                    }
                                }),
                                const SizedBox(height: 32),
                            ]
                        )
                    )
                )
            )
        );
    }
}

class ListTransferBinding extends Bindings {
    BuildContext context;
    ListTransferBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ListTransferController>(() => ListTransferController(context: context));
    }
}