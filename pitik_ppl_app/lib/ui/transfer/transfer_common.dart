import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/procurement_model.dart';
import 'package:model/response/procurement_list_response.dart';
import '../../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class TransferCommon {
  static void getListSend({required Coop coop, required RxBool isLoading, required RxList<Procurement?> destinationTransferList, String? type, String? fromDate, String? untilDate, Function()? onDone}) =>
      _requestTransferDataToServer(route: ListApi.getListTransferSend, isLoading: isLoading, coop: coop, destinationTransferList: destinationTransferList, type: type, fromDate: fromDate, untilDate: untilDate, status: '-', onDone: onDone);

  static void getListReceived({required Coop coop, required RxBool isLoading, required RxList<Procurement?> destinationTransferList, String? type, String? fromDate, String? untilDate, Function()? onDone}) =>
      _requestTransferDataToServer(route: ListApi.getListTransferReceived, isLoading: isLoading, coop: coop, destinationTransferList: destinationTransferList, fromDate: fromDate, untilDate: untilDate, status: 'approved', onDone: onDone);

  static void _requestTransferDataToServer(
      {required Coop coop, required RxBool isLoading, required String route, required RxList<Procurement?> destinationTransferList, required String status, String? type, String? fromDate, String? untilDate, Function()? onDone}) {
    isLoading.value = true;
    AuthImpl().get().then((auth) {
      if (auth != null) {
        List<dynamic> body = ['Bearer ${auth.token}', auth.id, coop.farmingCycleId, type, fromDate, untilDate, status];
        if (status == '-') {
          body = ['Bearer ${auth.token}', auth.id, coop.farmingCycleId, type, fromDate, untilDate];
        }

        Service.push(
            apiKey: 'productReportApi',
            service: route,
            context: Get.context!,
            body: body,
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                  destinationTransferList.value = (body as ProcurementListResponse).data;

                  if (onDone != null) {
                    onDone();
                  }
                  isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                  Get.snackbar('Pesan', '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                  isLoading.value = false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                  Get.snackbar('Pesan', exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                  isLoading.value = false;
                },
                onTokenInvalid: () => GlobalVar.invalidResponse()));
      } else {
        GlobalVar.invalidResponse();
      }
    });
  }

  static void getListSendByStatus({required Coop coop, required RxBool isLoading, required RxList<Procurement?> destinationTransferList, required String status1, required String status2, String? type, Function()? onDone}) {
    isLoading.value = true;
    AuthImpl().get().then((auth) {
      if (auth != null) {
        Service.push(
            apiKey: 'productReportApi',
            service: ListApi.getListTransferSendByStatus,
            context: Get.context!,
            body: ['Bearer ${auth.token}', auth.id, coop.farmingCycleId, type, status1, status2],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                  destinationTransferList.value = (body as ProcurementListResponse).data;

                  if (onDone != null) {
                    onDone();
                  }
                  isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                  Get.snackbar('Pesan', '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                  isLoading.value = false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                  Get.snackbar('Pesan', exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                  isLoading.value = false;
                },
                onTokenInvalid: () => GlobalVar.invalidResponse()));
      } else {
        GlobalVar.invalidResponse();
      }
    });
  }

  static Widget createTransferCard({required Coop coop, bool isGrTransfer = false, Procurement? procurement, Function()? onRefreshData}) {
    if (procurement != null) {
      String title = 'N/A';
      if (!isGrTransfer) {
        title = procurement.coopTargetName ?? 'N/A';
      } else {
        title = procurement.coopSourceName ?? 'N/A';
      }

      return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          child: GestureDetector(
              onTap: () {
                if (!isGrTransfer) {
                  GlobalVar.track('Click_card_transfer');
                  Get.toNamed(RoutePage.transferDetailPage, arguments: [coop, procurement, !isGrTransfer])!.then((value) {
                    if (onRefreshData != null) {
                      onRefreshData();
                    }
                  });
                } else {
                  GlobalVar.track('Click_card_terima_transfer');
                  Get.toNamed(RoutePage.confirmationReceivedPage, arguments: [coop, procurement, true, false])!.then((value) {
                    if (onRefreshData != null) {
                      onRefreshData();
                    }
                  });
                }
              },
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.fromBorderSide(BorderSide(width: 2, color: GlobalVar.outlineColor)), color: Colors.white),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(title, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                      _getStatusTransferWidget(isGrTransfer: isGrTransfer, statusText: procurement.statusText == null ? '-' : procurement.statusText!)
                    ]),
                    Text('Pengiriman ${procurement.deliveryDate == null ? '-' : procurement.deliveryDate!}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(!isGrTransfer ? 'Kandang Tujuan' : 'Asal Kandang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                      Text(procurement.coopTargetName == null || procurement.coopTargetName == '' ? procurement.branchTargetName! : procurement.coopTargetName!,
                          style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                    ]),
                    const SizedBox(height: 8),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                          procurement.type == null
                              ? 'N/A'
                              : procurement.type == 'pakan'
                                  ? 'Merek Pakan'
                                  : 'Jenis OVK',
                          style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                      const SizedBox(width: 16),
                      Expanded(child: Text(procurement.description == null ? '-' : procurement.description!, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black), textAlign: TextAlign.right))
                    ])
                  ]))));
    } else {
      return const SizedBox();
    }
  }

  static Widget _getStatusTransferWidget({required bool isGrTransfer, required String statusText}) {
    Color background = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SEBAGIAN || statusText == GlobalVar.NEED_APPROVAL || statusText == GlobalVar.SUBMITTED
        ? GlobalVar.primaryLight2
        : statusText == GlobalVar.DIPROSES
            ? GlobalVar.primaryLight3
            : statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT
                ? GlobalVar.redBackground
                : statusText == GlobalVar.LENGKAP || statusText == GlobalVar.DITERIMA
                    ? GlobalVar.greenBackground
                    : statusText == GlobalVar.DIKIRIM || statusText == GlobalVar.DISETUJUI
                        ? GlobalVar.blueBackground
                        : Colors.white;

    Color textColor = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SEBAGIAN || statusText == GlobalVar.NEED_APPROVAL || statusText == GlobalVar.SUBMITTED
        ? GlobalVar.primaryOrange
        : statusText == GlobalVar.DIPROSES
            ? GlobalVar.yellow
            : statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT
                ? GlobalVar.red
                : statusText == GlobalVar.LENGKAP || statusText == GlobalVar.DITERIMA
                    ? GlobalVar.green
                    : statusText == GlobalVar.DIKIRIM || statusText == GlobalVar.DISETUJUI
                        ? GlobalVar.blue
                        : Colors.white;

    if (statusText == GlobalVar.DISETUJUI && !isGrTransfer) {
      background = GlobalVar.greenBackground;
      textColor = GlobalVar.green;
    }

    return Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(7)), color: background),
        child: Text(statusText, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: textColor)));
  }
}
