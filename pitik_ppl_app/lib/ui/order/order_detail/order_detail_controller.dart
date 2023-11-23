
import 'dart:convert';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/procurement_model.dart';
import 'package:model/product_model.dart';
import 'package:model/response/approval_doc_response.dart';
import 'package:model/response/procurement_detail_response.dart';
import 'package:common_page/transaction_success_activity.dart';

import '../../../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class OrderDetailController extends GetxController {
    BuildContext context;
    OrderDetailController({required this.context});

    late Coop coop;
    late bool fromCoopRest;
    late EditAreaField rejectReasonAreaField;

    Rx<Widget> containerButtonEditAndCancel = (const SizedBox(width: 0, height: 0)).obs;
    Rx<Procurement> procurement = (Procurement()).obs;
    var isLoading = false.obs;
    var isApproveAllowed = false.obs;
    var isCancel = false.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        fromCoopRest = Get.arguments[1];
        procurement.value = Get.arguments[2];

        rejectReasonAreaField = EditAreaField(controller: GetXCreator.putEditAreaFieldController("orderRejectReason"), label: "Alasan", hint: "Tulis Alasan disini...", alertText: "Alasan belum diisi..!", maxInput: 250,
            onTyping: (text, field) {}
        );
        _getDetailRequest();
    }

    void _getDetailRequest() {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'productReportApi',
                    service: ListApi.getDetailRequest,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetRequestDetail(procurement.value.id!)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if ((body as ProcurementDetailResponse).data != null) {
                                procurement.value = body.data!;
                            }

                            isLoading.value = false;
                            _getApprovalByRole();
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
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void _getApprovalByRole() {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    service: ListApi.getApproval,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, "purchase-request-approve"],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            isApproveAllowed.value = (body as AprovalDocInResponse).data!.isAllowed ?? false;

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
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    bool isOwnFarm() {
        return coop.isOwnFarm != null && coop.isOwnFarm!;
    }

    Container getStatus() {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: procurement.value.statusText == null ? Colors.transparent :
                       procurement.value.statusText == GlobalVar.SUBMITTED || procurement.value.statusText == GlobalVar.NEED_APPROVAL ? GlobalVar.primaryLight2 :
                       procurement.value.statusText == GlobalVar.REJECTED || procurement.value.statusText == GlobalVar.ABORT ? GlobalVar.redBackground :
                       procurement.value.statusText == GlobalVar.DITERIMA || procurement.value.statusText == GlobalVar.APPROVED ? GlobalVar.greenBackground :
                       procurement.value.statusText == GlobalVar.DIKIRIM ? GlobalVar.blueBackground :
                       Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(7))
            ),
            child: Text(
                procurement.value.statusText == null ? '-' : procurement.value.statusText!,
                style: GlobalVar.subTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: GlobalVar.medium,
                    color: procurement.value.statusText == null ? Colors.transparent :
                           procurement.value.statusText == GlobalVar.SUBMITTED || procurement.value.statusText == GlobalVar.NEED_APPROVAL ? GlobalVar.primaryOrange :
                           procurement.value.statusText == GlobalVar.REJECTED || procurement.value.statusText == GlobalVar.ABORT ? GlobalVar.red :
                           procurement.value.statusText == GlobalVar.DITERIMA || procurement.value.statusText == GlobalVar.APPROVED ? GlobalVar.green :
                           procurement.value.statusText == GlobalVar.DIKIRIM ? GlobalVar.blue :
                           GlobalVar.black
                )
            ),
        );
    }

    Text getOrderDate() {
        if (procurement.value.deliveryDate != null) {
            DateTime dateTime = Convert.getDatetime(procurement.value.deliveryDate!);
            return Text('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black));
        } else {
            return Text('-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black));
        }
    }

    Column generateProductCards({required List<Product?> productList, bool isFeed = false}) {
        return Column(
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
                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                ),
                                const SizedBox(height: 12),
                                Text('Total', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                const SizedBox(height: 4),
                                Text(
                                    '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}',
                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                ),
                            ],
                        ),
                    );
                } else {
                    return const SizedBox();
                }
            }),
        );
    }

    void _approveOrder() {
        isLoading.value = true;
        AuthImpl().get().then((auth) {
            if (auth != null) {
                Service.push(
                    apiKey: 'productReportApi',
                    service: ListApi.approveOrder,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, 'v2/purchase-requests/${procurement.value.id}/approve', '{}'],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.off(TransactionSuccessActivity(
                                keyPage: "orderApprove${procurement.value.id}",
                                message: "Kamu telah menyetujui permintaan sapronak",
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

    void _rejectOrder({bool isCancel = false}) {
        if (rejectReasonAreaField.getInput().isNotEmpty) {
            isLoading.value = true;
            AuthImpl().get().then((auth) {
                if (auth != null) {
                    String endpoint = isCancel ? 'v2/purchase-requests/${procurement.value.id}/cancel' : 'v2/purchase-requests/${procurement.value.id}/reject';
                    Service.push(
                        apiKey: 'productReportApi',
                        service: isCancel ? ListApi.cancelOrder : ListApi.rejectOrder,
                        context: context,
                        body: ['Bearer ${auth.token}', auth.id, endpoint, json.encode({
                            "remarks": rejectReasonAreaField.getInput()
                        })],
                        listener: ResponseListener(
                            onResponseDone: (code, message, body, id, packet) {
                                isLoading.value = false;
                                Get.off(TransactionSuccessActivity(
                                    keyPage: "order${isCancel ? 'Cancel' : 'Reject'}${procurement.value.id}",
                                    message: isCancel ? "Kamu telah membatalkan permintaan sapronak" : "Kamu telah menolak permintaan sapronak",
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

    void _generateButtonBottom({bool isCanceled = false}) => ProfileImpl().get().then((value) => {
        if (isCancel.isTrue) {
            containerButtonEditAndCancel.value = SizedBox(
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
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnOrderSendCancel"), label: "Simpan", onClick: () => _rejectOrder(isCancel: isCanceled)),
                                ),
                            ]
                        )
                    )
                ),
            )
        } else if (value != null && value.userType == "ppl" && procurement.value.statusText != null && (procurement.value.statusText == GlobalVar.SUBMITTED || procurement.value.statusText == GlobalVar.NEED_APPROVAL)) {
            containerButtonEditAndCancel.value = SizedBox(
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
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnOrderEdit"), label: "Edit", onClick: () => Get.toNamed(RoutePage.orderRequestPage, arguments: [
                                        coop, true, fromCoopRest, procurement.value
                                    ])),
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnOrderCancel"), label: "Batal", onClick: () {
                                    isCancel.value = true;
                                    _generateButtonBottom(isCanceled: true);
                                }))
                            ]
                        )
                    )
                ),
            )
        } else if (isApproveAllowed.isTrue && procurement.value.statusText != null && (procurement.value.statusText == GlobalVar.SUBMITTED || procurement.value.statusText == GlobalVar.NEED_APPROVAL)) {
            containerButtonEditAndCancel.value = SizedBox(
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
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnOrderApprove"), label: "Setujui", onClick: () => _approveOrder()),
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnOrderReject"), label: "Tolak", onClick: () {
                                    isCancel.value = true;
                                    _generateButtonBottom();
                                }))
                            ]
                        )
                    )
                ),
            )
        } else {
            containerButtonEditAndCancel.value = const SizedBox(width: 0, height: 0)
        }
    });
}

class OrderDetailBinding extends Bindings {
    BuildContext context;
    OrderDetailBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<OrderDetailController>(() => OrderDetailController(context: context));
    }
}