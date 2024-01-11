// ignore_for_file: non_constant_identifier_names

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/product_model.dart';
import 'package:model/request_chickin.dart';
import 'package:model/response/approval_doc_response.dart';
import 'package:model/response/request_chickin_response.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';

class RequestDocInController extends GetxController {
    BuildContext context;
    RequestDocInController({required this.context});

    var isLoading = false.obs;
    int startTime = DateTime.now().millisecondsSinceEpoch;

    final String SUBMISSION_STATUS = "Perlu Pengajuan";
    final String SUBMITTED_DOC_IN = "DOC in Diajukan";
    final String SUBMITTED_OVK = "OVK Diajukan";
    final String APPROVED_OVK = "OVK Disetujui";
    final String APPROVED_DOC_IN = "DOC in Disetujui";
    final String SUBMITTED_STATUS = "Diajukan";
    final String NEED_APPROVED = "Perlu Persetujuan";
    final String APPROVED = "Disetujui";
    final String OVK_REJECTED = "OVK Ditolak";
    final String PROSESSING = "Diproses";
    final String REJECTED = "Ditolak";
    final String NEW = "Baru";

    var requestId = "".obs;
    Rx<RequestChickin?> requestChickin = RequestChickin().obs;

    var allowApprove = false.obs;
    var allowSubmit = false.obs;
    var doneApprove = false.obs;
    var isEdit = false.obs;
    Coop coop = Coop();

    DateTimeField dtTanggal = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("dfTanggal"),
        label: "Tanggal*",
        hint: "dd/MM/yyyy",
        alertText: "Oops tanggal DOC-In belum dipilih",
        onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected(DateFormat("dd/MM/yyyy").format(dateTime)),
        flag: 1,
    );

    EditField efPopulasi = EditField(
        controller: GetXCreator.putEditFieldController("efPopulasi"),
        label: "Total Populasi",
        hint: "0",
        alertText: "Oops Total Populasi belum diisi",
        textUnit: "Ekor",
        inputType: TextInputType.number,
        isNumberFormatter: true,
        maxInput: 20,
        onTyping: (value, editField) {});

    late ButtonFill btNext = ButtonFill(
        controller: GetXCreator.putButtonFillController("btNext"),
        label: "Simpan",
        onClick: () {
            switch (btNext.controller.label.value) {
                case "Simpan":
                    if(isValid()){
                        _showBottomDialog();
                    }
                    break;
                case "Tutup":
                    Get.back();
                    break;
                case "Setujui":
                    _showBottomDialog();
                    break;
                default:
                    break;
            }
        });

    late ButtonOutline boEdit = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("boCanboEditcel"),
        label: "Edit",
        onClick: () {
            enableField();
            isEdit.value = true;
            boEdit.controller.disable();
        });

    late ButtonFill btYakin = ButtonFill(controller: GetXCreator.putButtonFillController("byYakin"), label: "Yakin", onClick: () {
        GlobalVar.track('Click_button_DOCin_simpan');
        Get.back();
        processRequest();
    });

    ButtonOutline btTidakYakin = ButtonOutline(controller: GetXCreator.putButtonOutlineController("btTidakYakin"), label: "Tidak Yakin", onClick: () => Get.back());

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track('Open_DOCin_form_pengajuan');
        coop = Get.arguments[0];
    }

    @override
    void onReady(){
        super.onReady();
        isLoading.value = true;
        getApprovalByRole();

        WidgetsBinding.instance.addPostFrameCallback((_) => GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'Page': 'Req_DOCin'}));
    }

    void getApprovalByRole() {
        AuthImpl().get().then((auth) {
            if (auth != null) {
                int startTime = DateTime.now().millisecondsSinceEpoch;
                Service.push(
                    apiKey: ApiMapping.api,
                    service: ListApi.getApproval,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, "chick-in-request-approve"],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            allowApprove.value = (body as AprovalDocInResponse).data!.isAllowed ?? false;
                            getPermissionCreateByRole();
                            GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': 'getApproval', 'Result': 'Success'});
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': 'getApproval', 'Result': 'Fail'});
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': 'getApproval', 'Result': 'Error'});
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
                GlobalVar.invalidResponse();
            }
        });
    }

    void getPermissionCreateByRole() {
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: ApiMapping.api,
                    service: ListApi.getApproval,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, "chick-in-request-create"],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            allowSubmit.value = (body as AprovalDocInResponse).data!.isAllowed ?? false;
                            if (!body.data!.isAllowed!) {
                                boEdit.controller.disable();
                            }

                            coop.statusText = coop.statusText ?? SUBMISSION_STATUS;
                            if ((coop.statusText ?? "").toLowerCase() == SUBMITTED_DOC_IN.toLowerCase() || (coop.statusText ?? "").toLowerCase() == PROSESSING.toLowerCase()) {
                                if (allowApprove.isTrue) {
                                    btNext.controller.changeLabel("Setujui");
                                } else {
                                    btNext.controller.changeLabel("Tutup");
                                }
                            } else if (!(GlobalVar.profileUser!.role == "ppl") && (coop.statusText ?? "").toLowerCase() == NEED_APPROVED.toLowerCase()) {
                                btNext.controller.changeLabel("Setujui");
                            } else {
                                btNext.controller.changeLabel("Tutup");
                            }
                            setFieldByStatus();
                        },
                        onResponseFail: (code, message, body, id, packet) => Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red
                        ),
                        onResponseError: (exception, stacktrace, id, packet) => Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red
                        ),
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void setFieldByStatus() {
        coop.statusText = coop.statusText ?? SUBMISSION_STATUS;
        if ((coop.statusText ?? "").toLowerCase()== SUBMISSION_STATUS.toLowerCase()) {
            // if(coop.purchaseRequestOvk != null && coop.purchaseRequestOvk!.id!.isNotEmpty) {
            //     getDetailOvkRequest();
            // }

            btNext.controller.changeLabel("Simpan");
            boEdit.controller.disable();
            isLoading.value =false;
        } else if ((coop.statusText ?? "").toLowerCase()== SUBMITTED_DOC_IN.toLowerCase()) {
            getDetailDocRequest();
            disableField();
            // if(coop.purchaseRequestOvk != null && coop.purchaseRequestOvk!.id!.isNotEmpty) {
            //     getDetailOvkRequest();
            // }
        } else if ((coop.statusText ?? "").toLowerCase()== PROSESSING.toLowerCase()) {
            getDetailDocRequest();
            disableField();
            // if(coop.purchaseRequestOvk != null && coop.purchaseRequestOvk!.id!.isNotEmpty) {
            //     getDetailOvkRequest();
            // }
            boEdit.controller.disable();
        } else if((coop.statusText ?? "").toLowerCase()== APPROVED.toLowerCase()) {
            getDetailDocRequest();
            boEdit.controller.disable();
        } else if((coop.statusText ?? "").toLowerCase()== NEED_APPROVED.toLowerCase()) {
            if (coop.chickInRequestId != null && coop.chickInRequestId!.isNotEmpty) {
                getDetailDocRequest();
            } else {
                enableField();
                isLoading.value =false;
            }
            // if (coop.purchaseRequestOvk != null && coop.purchaseRequestOvk!.id!.isNotEmpty) {
            //     getDetailOvkRequest();
            // }
        } else if ((coop.statusText ?? "").toLowerCase()== SUBMITTED_OVK.toLowerCase()) {
            if (coop.chickInRequestId != null && coop.chickInRequestId!.isNotEmpty) {
                getDetailDocRequest();
            } else {
                enableField();
                isLoading.value =false;
            }
            // if (coop.purchaseRequestOvk != null && coop.purchaseRequestOvk!.id!.isNotEmpty) {
            //     getDetailOvkRequest();
            // }
        } else if ((coop.statusText ?? "").toLowerCase()== OVK_REJECTED.toLowerCase()) {
            if (coop.chickInRequestId != null && coop.chickInRequestId!.isNotEmpty) {
                getDetailDocRequest();
            }else{
                enableField();
                isLoading.value =false;
            }
        } else if ((coop.statusText ?? "").toLowerCase()== APPROVED_OVK.toLowerCase()) {
            if (coop.chickInRequestId != null && coop.chickInRequestId!.isNotEmpty) {
                getDetailDocRequest();
            } else {
                enableField();
                isLoading.value =false;
            }
            // if (coop.purchaseRequestOvk != null && coop.purchaseRequestOvk!.id!.isNotEmpty) {
            //     getDetailOvkRequest();
            // }
        } else if ((coop.statusText ?? "").toLowerCase()== REJECTED.toLowerCase()) {
            isLoading.value =false;
        }
    }

    void enableField() {
        allowApprove.value = false;

        if ((coop.statusText ?? "").toLowerCase() == SUBMISSION_STATUS.toLowerCase() || (coop.statusText ?? "").toLowerCase() == APPROVED_OVK.toLowerCase() || (coop.statusText ?? "").toLowerCase() == SUBMITTED_OVK.toLowerCase() || (coop.statusText ?? "").toLowerCase() == OVK_REJECTED.toLowerCase()) {
            dtTanggal.controller.enable();
            efPopulasi.controller.enable();
            btNext.controller.changeLabel("Simpan");
        } else if ((coop.statusText ?? "").toLowerCase() == SUBMITTED_DOC_IN || (coop.statusText ?? "").toLowerCase() == NEED_APPROVED.toLowerCase() || (coop.statusText ?? "").toLowerCase() == PROSESSING.toLowerCase()) {
            dtTanggal.controller.enable();
            efPopulasi.controller.enable();
            btNext.controller.changeLabel("Simpan");
        }
    }

    void disableField(){
        dtTanggal.controller.disable();
        efPopulasi.controller.disable();
    }

    void getDetailOvkRequest(){
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: ApiMapping.productReportApi,
                    service: ListApi.getDetailRequest,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetRequestDetail(coop.chickInRequestId!)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) => Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red
                        ),
                        onResponseError: (exception, stacktrace, id, packet) => Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red
                        ),
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void getDetailDocRequest() {
        AuthImpl().get().then((auth) {
            if (auth != null) {
                int startTime = DateTime.now().millisecondsSinceEpoch;
                Service.push(
                    apiKey: ApiMapping.productReportApi,
                    service: ListApi.getRequestChickinDetail,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetRequestChickinDetail(coop.chickInRequestId!)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            requestChickin.value = (body as RequestChickinResponse).data;
                            requestId.value =(body).data!.id!;

                            try {
                                DateFormat formatDate = DateFormat("dd/MM/yyyy");
                                DateTime newStartDate =DateFormat("yyyy-MM-dd HH:mm:ss").parse(requestChickin.value!.chickInDate ?? "");
                                String startDate = formatDate.format(newStartDate);
                                dtTanggal.controller.setTextSelected(startDate);
                            } catch (_) {}

                            efPopulasi.setInput(requestChickin.value!.initialPopulation.toString());

                            if (!((coop.statusText??"").toLowerCase() == SUBMISSION_STATUS.toLowerCase()) && !((coop.statusText??"").toLowerCase() == SUBMITTED_OVK.toLowerCase())) {
                                disableField();
                            }
                            isLoading.value  = false;
                            GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': 'getRequestChickinDetail', 'Result': 'Success'});
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': 'getRequestChickinDetail', 'Result': 'Fail'});
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': 'getRequestChickinDetail', 'Result': 'Error'});
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
                GlobalVar.invalidResponse();
            }
        });
    }

    bool isValid(){
        if (dtTanggal.controller.textSelected.value.isEmpty) {
            dtTanggal.controller.showAlert();
            Scrollable.ensureVisible(dtTanggal.controller.formKey.currentContext!);
            return false;
        }

        if (efPopulasi.getInput().isEmpty) {
            efPopulasi.controller.showAlert();
            Scrollable.ensureVisible(efPopulasi.controller.formKey.currentContext!);
            return false;
        }

        return true;
    }

    _showBottomDialog() {
        return showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: Get.context!,
            builder: (context) {
                return Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: GlobalVar.outlineColor,
                                    borderRadius: BorderRadius.circular(2)
                                ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                                child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold)),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text("Request DOC-In", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Tanggal", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                                Text(DateFormat("dd/MM/yyyy").format(dtTanggal.getLastTimeSelected()), style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ],
                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Populasi", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                                Text("${efPopulasi.getInput()} %", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ],
                                        ),
                                    ],
                                ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: btYakin),
                                        const SizedBox(width: 16),
                                        Expanded(child: btTidakYakin)
                                    ]
                                )
                            ),
                            const SizedBox(height: GlobalVar.bottomSheetMargin)
                        ]
                    )
                );
            }
        );
    }

    void processRequest() {
        isLoading.value = true;
        RequestChickin requestChickinBody = RequestChickin();
        requestChickinBody.chickInDate = DateFormat("yyyy-MM-dd").format(dtTanggal.getLastTimeSelected());
        requestChickinBody.initialPopulation = (efPopulasi.getInputNumber()??0).toInt();
        requestChickinBody.coopId = coop.id;

        Product doc = Product();
        doc.quantity = efPopulasi.getInputNumber() ?? 0;
        doc.categoryCode = "DOC";
        doc.categoryName = "DOC";
        doc.subcategoryCode ="";
        doc.subcategoryName = "";
        doc.productName = "";
        doc.productCode = "";
        doc.purchaseUom = "";
        requestChickinBody.doc = doc;

        if ((coop.statusText ?? "").toLowerCase() == SUBMISSION_STATUS.toLowerCase() || (coop.statusText ?? "").toLowerCase() == REJECTED.toLowerCase()) {
            saveRequestChickin(requestChickinBody);
        } else if ((coop.statusText ?? "").toLowerCase() == SUBMITTED_DOC_IN.toLowerCase() || (coop.statusText ?? "").toLowerCase() == PROSESSING.toLowerCase()) {
            if (allowApprove.isTrue) {
                RequestChickin requestChickinApprove = RequestChickin();
                requestChickinApprove.id = requestId.value;
                requestChickinApprove.chickInDate =  DateFormat("yyyy-MM-dd").format(dtTanggal.getLastTimeSelected());
                approveRequestChickin(requestChickinApprove);
            } else {
                updateRequestChickin(requestChickinBody);
            }
        } else if ((coop.statusText ?? "").toLowerCase() == NEED_APPROVED.toLowerCase()) {
            if (coop.chickInRequestId != null && coop.chickInRequestId!.isNotEmpty && isEdit.isTrue) {
                RequestChickin requestChickinApprove = RequestChickin();
                requestChickinApprove.id = requestId.value;
                requestChickinApprove.chickInDate = DateFormat("yyyy-MM-dd").format(dtTanggal.getLastTimeSelected());
                approveRequestChickin(requestChickinApprove);
            } else if(isEdit.isTrue) {
                updateRequestChickin(requestChickinBody);
            } else {
                saveRequestChickin(requestChickinBody);
            }
        } else if ((coop.statusText ?? "").toLowerCase()== OVK_REJECTED.toLowerCase()) {
            saveRequestChickin(requestChickinBody);
        } else if ((coop.statusText ?? "").toLowerCase()== APPROVED_OVK.toLowerCase()) {
            saveRequestChickin(requestChickinBody);
        } else if ((coop.statusText ?? "").toLowerCase()== SUBMITTED_OVK.toLowerCase()){
            saveRequestChickin(requestChickinBody);
        }
    }

    void saveRequestChickin(RequestChickin requestChickin) {
        AuthImpl().get().then((auth) => {
            if (auth != null){
                Service.push(
                    apiKey: ApiMapping.productReportApi,
                    service: ListApi.saveRequestChickin,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, Mapper.asJsonString(requestChickin)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.back();
                            isLoading.value =false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                            isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
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
    }

    void updateRequestChickin(RequestChickin requestChickin) {
        AuthImpl().get().then((auth) => {
            if (auth != null){
                Service.push(
                    apiKey: ApiMapping.productReportApi,
                    service: ListApi.updateRequestChickin,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetRequestChickinDetail(coop.chickInRequestId!), Mapper.asJsonString(requestChickin)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.back();
                            isLoading.value =false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                            isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
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
    }

    void approveRequestChickin(RequestChickin requestChickin) {
        AuthImpl().get().then((auth) => {
            if (auth != null){
                Service.push(
                    apiKey: ApiMapping.productReportApi,
                    service: ListApi.approveRequestChickin,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, ListApi.pathApproveRequestChickinDetail(requestChickin.id!), Mapper.asJsonString(requestChickin)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.back();
                            isLoading.value =false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                            isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
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
    }
}

class RequestDocInBindings extends Bindings {
    BuildContext context;
    RequestDocInBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => RequestDocInController(context: context));
    }
}
