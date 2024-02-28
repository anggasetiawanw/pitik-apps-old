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
import '../../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ListOrderController extends GetxController with GetSingleTickerProviderStateMixin {
  BuildContext context;
  ListOrderController({required this.context});

  late TabController tabController;
  late Coop coop;
  late bool fromCoopRest;

  var isLoading = false.obs;
  RxList<Procurement?> orderList = <Procurement?>[].obs;

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    fromCoopRest = Get.arguments[1];

    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(() {
      if (tabController.index == 0) {
        getListRequested();
      } else if (tabController.index == 1) {
        getListProcessed();
      } else {
        getListReceived();
      }
    });

    getListRequested();
  }

  void getListRequested({String? type, String? fromDate, String? untilDate}) {
    GlobalVar.track('Open_order_page_pengajuan');
    _requestOrderDataToServer(route: fromCoopRest ? ListApi.getListPurchaseRequestForCoopRest : ListApi.getListPurchaseRequest, type: type, fromDate: fromDate, untilDate: untilDate);
  }

  void getListProcessed({String? type, String? fromDate, String? untilDate}) {
    GlobalVar.track('Open_order_page_proses');
    _requestOrderDataToServer(route: fromCoopRest ? ListApi.getListPurchaseOrderForCoopRest : ListApi.getListPurchaseOrder, type: type, fromDate: fromDate, untilDate: untilDate, status: 'draft,rejected');
  }

  void getListReceived({String? type, String? fromDate, String? untilDate}) {
    GlobalVar.track('Open_order_page_penerimaan');
    _requestOrderDataToServer(route: fromCoopRest ? ListApi.getListPurchaseOrderForCoopRest : ListApi.getListPurchaseOrder, type: type, fromDate: fromDate, untilDate: untilDate, status: 'approved');
  }

  void _requestOrderDataToServer({required String route, String? type, String? fromDate, String? untilDate, String? status}) {
    isLoading.value = true;
    AuthImpl().get().then((auth) {
      if (auth != null) {
        List<dynamic> body = ['Bearer ${auth.token}', auth.id, fromCoopRest ? coop.id : coop.farmingCycleId, fromCoopRest, type, fromDate, untilDate, status, null];
        if (tabController.index == 0) {
          body = ['Bearer ${auth.token}', auth.id, fromCoopRest ? coop.id : coop.farmingCycleId, fromCoopRest, type, fromDate, untilDate];
        }

        Service.push(
            apiKey: 'productReportApi',
            service: route,
            context: Get.context!,
            body: body,
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                  orderList.value = (body as ProcurementListResponse).data;
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

  Widget _getStatusOrderWidget({required int tabPosition, required String statusText}) {
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

    if (statusText == GlobalVar.DISETUJUI && tabPosition == 0) {
      background = GlobalVar.greenBackground;
      textColor = GlobalVar.green;
    }

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(7)), color: background),
      child: Text(statusText, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: textColor)),
    );
  }

  void refreshOrderList() {
    if (tabController.index == 0) {
      getListRequested();
    } else if (tabController.index == 1) {
      getListProcessed();
    } else {
      getListReceived();
    }
  }

  Widget createOrderCard({required int typePosition, Procurement? procurement}) {
    if (procurement != null) {
      final bool isReceivedApproved = typePosition == 2;
      String title = 'N/A';
      String type = 'N/A';
      if (procurement.type != null) {
        if (isReceivedApproved && procurement.type == 'pakan') {
          title = 'Pakan Masuk';
          type = 'Merek Pakan';
        } else if (isReceivedApproved && procurement.type == 'ovk') {
          title = 'OVK Masuk';
          type = 'Merek OVK';
        } else if (procurement.type == 'pakan') {
          title = 'Order Pakan';
          type = 'Merek Pakan';
        } else {
          title = 'Order OVK';
          type = 'Merek OVK';
        }
      }

      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        child: GestureDetector(
          onTap: () {
            if (typePosition == 0) {
              GlobalVar.track('Click_card_pengajuan');
              Get.toNamed(RoutePage.orderDetailPage, arguments: [coop, fromCoopRest, procurement])!.then((value) => refreshOrderList());
            } else {
              if (typePosition == 1) {
                GlobalVar.track('Click_card_proses');
              } else {
                GlobalVar.track('Click_card_penerimaan');
              }
              Get.toNamed(RoutePage.confirmationReceivedPage, arguments: [coop, procurement, false, fromCoopRest])!.then((value) => refreshOrderList());
            }
          },
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.fromBorderSide(BorderSide(width: 2, color: GlobalVar.outlineColor)), color: Colors.white),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                    _getStatusOrderWidget(tabPosition: typePosition, statusText: procurement.statusText == null ? '-' : procurement.statusText!)
                  ],
                ),
                Text(procurement.deliveryDate == null ? '-' : procurement.deliveryDate!, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                const SizedBox(height: 8),
                typePosition != 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Kode Pesanan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                          Text(procurement.erpCode == null ? '-' : procurement.erpCode!, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(type, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(procurement.description == null ? '-' : procurement.description!, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black), textAlign: TextAlign.right))
                  ],
                )
              ])),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void showMenuBottomSheet() {
    final DateTimeField fromDateField = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController('filterOrderFromDateField'),
        label: 'Tanggal Dari',
        hint: 'Pilih tanggal',
        alertText: 'Tanggal harus dipilih..!',
        flag: DateTimeField.DATE_FLAG,
        onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}'));

    final DateTimeField untilDateField = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController('filterOrderUntilDateField'),
        label: 'Tanggal Sampai',
        hint: 'Pilih tanggal',
        alertText: 'Tanggal harus dipilih..!',
        flag: DateTimeField.DATE_FLAG,
        onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}'));

    final SpinnerField typeField = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController('filterOrderTypeField'), label: 'Jenis Order', hint: 'Pilih salah satu', alertText: 'Harus pilih jenis..!', items: const {'Pakan': false, 'OVK': false}, onSpinnerSelected: (textSelected) {});

    showModalBottomSheet(
        backgroundColor: Colors.white,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        )),
        isScrollControlled: true,
        context: Get.context!,
        builder: (context) => Container(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
                      Center(child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                      const SizedBox(height: 16),
                      fromDateField,
                      untilDateField,
                      typeField,
                      const SizedBox(height: 50),
                      ButtonFill(
                          controller: GetXCreator.putButtonFillController('btnFilterOrderList'),
                          label: 'Konfirmasi Filter',
                          onClick: () {
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
                                getListRequested(type: typeField.getController().textSelected.value.toLowerCase(), fromDate: fromDateField.getLastTimeSelectedText(), untilDate: untilDateField.getLastTimeSelectedText());
                              } else if (tabController.index == 1) {
                                getListProcessed(type: typeField.getController().textSelected.value.toLowerCase(), fromDate: fromDateField.getLastTimeSelectedText(), untilDate: untilDateField.getLastTimeSelectedText());
                              } else {
                                getListReceived(type: typeField.getController().textSelected.value.toLowerCase(), fromDate: fromDateField.getLastTimeSelectedText(), untilDate: untilDateField.getLastTimeSelectedText());
                              }
                            }
                          }),
                      const SizedBox(height: 32),
                    ])))));
  }
}

class ListOrderBinding extends Bindings {
  BuildContext context;
  ListOrderBinding({required this.context});

  @override
  void dependencies() {
    Get.lazyPut<ListOrderController>(() => ListOrderController(context: context));
  }
}
