import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/spinner_multi_field/spinner_multi_field.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/location_permission.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/checkin_model.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/internal_app/order_categories_model.dart';
import 'package:model/internal_app/place_model.dart' as location_model;
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/visit_customer_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/customer_list_response.dart';
import 'package:model/response/internal_app/customer_response.dart';
import 'package:model/response/internal_app/order_issue_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/ui/sales_module/data_visit_activity/data_visit_activity.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/checkin_component.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card/sku_card.dart';
import 'package:pitik_internal_app/widget/sku_card/sku_card_controller.dart';

class VisitController extends GetxController {
    BuildContext context;

    VisitController({required this.context});

    late SkuCard skuCard = SkuCard(
        controller: InternalControllerCreator.putSkuCardController("skuLama",context ),
    );

    final EditField editAlasan = EditField(
        controller: GetXCreator.putEditFieldController("alasanLama"),
        label: "Alasan*",
        hint: "Ketik Disini",
        alertText: "Kolom ini harus diisi!",
        textUnit: "",
        maxInput: 100,
        onTyping: (value, controller) {});

    final SpinnerField spinnerProspek = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("spinnerProspek"),
        label: "Prospek Pembelian*",
        hint: "Pilih Salah Satu",
        alertText: "Kolom ini harus dipilih!",
        items: const {
            "Sulit": false,
            "Normal": false,
            "Mudah": false,
        },
        onSpinnerSelected: (value) {});

    late SpinnerField spinnerLead = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("leadLama"),
        label: "Lead Status*",
        hint: "Pilih Salah Satu",
        alertText: "Kolom ini harus dipilih!",
        items: const {
            "Belum": false,
            "Akan": false,
            "Pernah": false,
            "Rutin": false,
        },
        onSpinnerSelected: (value) {},
    );

    late SpinnerField spinnerKendala = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("kendalaLama"),
        label: "Apakah ada kendala terkait pemesanan?*",
        hint: "Pilih Salah Satu",
        alertText: "Kolom ini harus dipilih!",
        items: const {
        "Ya": false,
        "Tidak": false,
        },
        onSpinnerSelected: (value) {
            if (value == "Ya") {
                spinnerMulti.controller.visibleSpinner();
                getIssueCategories();
            }
            if (value == "Tidak") {
                spinnerMulti.controller.invisibleSpinner();
            }
        },
    );

    late ButtonFill buttonFillSelesai = ButtonFill(
        controller: GetXCreator.putButtonFillController("SelesaiKunjungan"),
        label: "Selesai Kunjungan",
        onClick: () {
            GlobalVar.track("Click_Selesai_Kunjungan");
            List ret = validation();
            if (ret[0]) {
                VisitCustomer visPayload = generatePayload();
                isLoading.value = true;
                Service.push(
                    service: ListApi.createNewVisit,
                    context: context,
                    body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathCreatenewVisit(customer.value!.id!), Mapper.asJsonString(visPayload)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            isLoading.value=false;
                            Get.back();
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value=false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value=false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi kesalahan internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                            );},
                        onTokenInvalid: Constant.invalidResponse()
                    )
                );

            } else {
                if (ret[1] != null) {
                    if ((ret[1] as String).isNotEmpty) {
                        Get.snackbar("Pesan", "Duplikat Item Produk, ${ret[1]}",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFFFF0000),
                            colorText: const Color(0xFFFFFFFF));
                    }
                }
            }
        },
    );

    late ButtonFill buttonIsiKunjungan = ButtonFill(
        controller: GetXCreator.putButtonFillController("buttonisiLama"),
        label: "Isi Kunjungan",
        onClick: () {
            Get.back();
            getDetailCustomer();
        });

    late ButtonFill buttonFillCariDetailBisnis = ButtonFill(
        controller: GetXCreator.putButtonFillController("cariDetail"),
        label: "Cari Detail Bisnis",
        onClick: () {
            spinnerKota.controller.disable();
            spinnerKecamatan.controller.disable();
            spinnerNamaBisnis.controller.disable();
            buttonIsiKunjungan.controller.disable();
            getProvince();

            const VisitActivity().openModalBottom();
        },
    );

    late SpinnerSearch spinnerProvince = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("provinceBaru"),
        label: "Provinsi*",
        hint: "Pilih Provinsi",
        alertText: "Provinsi harus dipilih!",
        items: const {},
        onSpinnerSelected: (text) {
            if (province.value.isNotEmpty) {
                provinceSelect = province.value
                    .firstWhereOrNull((element) => element!.provinceName! == text);
                if (provinceSelect != null) {
                getCity(provinceSelect!);
                }
            }
        },
    );
    late SpinnerSearch spinnerKota = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("kotaBaru"),
        label: "Kota*",
        hint: "Pilih Kota",
        alertText: "Kota harus dipilih!",
        items: const {"Rumah Makan": false, "Rumah Tuang": false},
        onSpinnerSelected: (text) {

            if (city.value.isNotEmpty) {
                citySelect = city.value.firstWhereOrNull((element) => element!.cityName! == text);
                if (citySelect != null) {
                    getDistrict(citySelect!);
                }
            }
        },
    );
    late SpinnerSearch spinnerKecamatan = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("kecamatanBaru"),
        label: "Kecamatan*",
        hint: "Pilih Kecamatan",
        alertText: "Tipe bisnis harus dipilih!",
        items: const {},
        onSpinnerSelected: (text) {
            if (district.value.isNotEmpty) {
                districtSelect = district.value.firstWhereOrNull((element) => element!.districtName! == text);
                if (districtSelect != null) {
                    getListCustomer();
                }
            }
        },
    );
    late SpinnerSearch spinnerNamaBisnis = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("bisnisLama"),
        label: "Nama Bisnis*",
        hint: "Pilih Salah Satu",
        alertText: "Kolom ini harus dipilih!",
        items: const {},
        onSpinnerSelected: (value) {
            if (listCustomer.value.isNotEmpty) {
                customerSelect = listCustomer.value.firstWhereOrNull((element) => element.businessName! == value);
                if (customerSelect != null) {
                    buttonIsiKunjungan.controller.enable();
                }
            }
        }
    );

    late ButtonOutline checkinButton = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("ButtonCheckin"),
        label: "Checkin",
        isHaveIcon: true,
        onClick: () async {
            GlobalVar.track("Click_Checkin_Customer");
            isLoadCheckin.value = true;
            final hasPermission = await handleLocationPermission();
            if (hasPermission){
            const timeLimit = Duration(seconds: 15);
            await FlLocation.getLocation(timeLimit: timeLimit, accuracy: LocationAccuracy.high).then((position) {
                if(position.isMock) {
                    Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, Gps Mock Detected",
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 10),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                    isLoadCheckin.value = false;
                } else {
                    Service.push(
                        service: ListApi.visitCheckin,
                        context: context,
                        body: [
                            Constant.auth!.token,
                            Constant.auth!.id,
                            Constant.xAppId!,
                            ListApi.pathCheckinVisit(customer.value!.id!),
                            Mapper.asJsonString(CheckInModel(latitude:position.latitude, longitude: position.longitude ))
                        ],
                        listener: ResponseListener(
                            onResponseDone: (code, message, body, id, packet) {
                                latitude = position.latitude;
                                longitude = position.longitude;
                                GpsComponent.checkinSuccess();
                                isSuccessCheckin.value = true;
                                showErrorCheckin.value = true;
                                isLoadCheckin.value = false;
                                buttonFillSelesai.controller.enable();
                            },
                            onResponseFail: (code, message, body, id, packet) {
                                error.value = (body as ErrorResponse).error!.message!;
                                GpsComponent.failedCheckin(error.value);
                                isSuccessCheckin.value = false;
                                showErrorCheckin.value = true;
                                isLoadCheckin.value = false;
                            },
                            onResponseError: (exception, stacktrace, id, packet) {
                                isSuccessCheckin.value = false;
                                showErrorCheckin.value = true;
                                isLoadCheckin.value = false;
                            },
                            onTokenInvalid: Constant.invalidResponse())
                    );
                }
            }).onError((errors, stackTrace) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan gps timeout, tidak bisa mendapatkan lokasi.",
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                FirebaseCrashlytics.instance.recordError("Errors On GPS : $errors", stackTrace, fatal: false);
                FirebaseCrashlytics.instance.log("Errors On GPS : $errors");
                error.value = "Terjadi Kesalahan gps timeout, tidak bisa mendapatkan lokasi";
                GpsComponent.failedCheckin(error.value);
                isLoadCheckin.value = false;
                isSuccessCheckin.value = false;
                showErrorCheckin.value = true;
            });
        } else {
            error.value = "Data GPS tidak diizinkan";
            isLoading.value = false;
            isLoadCheckin.value = false;
        }
    }
    );

    late SpinnerMultiField spinnerMulti = SpinnerMultiField(
        controller: GetXCreator.putSpinnerMultiFieldController("multiData Visit"),
        label: "Jenis Kendala*",
        hint: "Pilih Jenis Kendala",
        alertText: "Jenis Kendala Harus di Pilih",
        items: const [],
        onSpinnerSelected: (newValue) {},
    );

    Rxn<Customer> customer = Rxn<Customer>();

    Rx<List<Customer>> listCustomer = Rx<List<Customer>>([]);
    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
    Rx<List<location_model.Location?>> province = Rx<List<location_model.Location>>([]);
    Rx<List<location_model.Location?>> city = Rx<List<location_model.Location>>([]);
    Rx<List<location_model.Location?>> district = Rx<List<location_model.Location>>([]);
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
    Rx<List<OrderIssueCategories?>> orderIssueCategories = Rx<List<OrderIssueCategories?>>([]);

    location_model.Location? provinceSelect;
    location_model.Location? districtSelect;
    location_model.Location? citySelect;
    Customer? customerSelect;

    final DateTime dateNow = DateTime.now();
    int flagFrom = 0;
    int page = 1;
    int limit = 50;
    double? latitude = 0;
    double? longitude = 0;
    var isLoading = false.obs;
    var isLoadApi = false.obs;
    var isLoadKendala = false.obs;
    var showErrorCheckin = false.obs;
    var isSuccessCheckin = false.obs;
    var isLoadCheckin = false.obs;
    var error = "".obs;
    int countLoading = 0;

    @override
    void onInit() {
        super.onInit();
        buttonFillSelesai.controller.disable();
        spinnerMulti.controller.invisibleSpinner();
        skuCard.controller.invisibleCard();
        spinnerKota.controller.disable();
        spinnerKecamatan.controller.disable();
        spinnerNamaBisnis.controller.disable();
        buttonIsiKunjungan.controller.disable();
        flagFrom = Get.arguments[0];
    }

    @override
    void onReady() {
        super.onReady();
        isLoading.value = true;
        Get.find<SkuCardController>(tag: "skuLama").numberList.listen((p0) {
            generateListProduct(p0);
        });
        spinnerMulti.getController().selectedValue.listen((p0) {
            if(p0.contains("Harga")){
                skuCard.controller.visibleCard();
                for( int i =0;  i < skuCard.controller.itemCount.value ; i++) {
                    skuCard
                        .controller
                        .spinnerProduct
                        .value[i]
                        .controller
                        ..showLoading()..disable();
                }
                getProduct();
            }else {
                skuCard.controller.invisibleCard();
            }
        });
        switch (flagFrom) {
        case RoutePage.fromHomePage:
            WidgetsBinding.instance.addPostFrameCallback((_) {
                getProvince();
                const VisitActivity().openModalBottom();
            });
            break;
        case RoutePage.fromDetailCustomer:
            customer.value = Get.arguments[1];
            loadData(customer.value!, RoutePage.fromDetailCustomer);
            break;
        case RoutePage.fromNewCustomerYes:
            customer.value = Get.arguments[1];
            loadData(customer.value!, RoutePage.fromNewCustomerYes);
            break;
        case RoutePage.fromNewCustomerNot:
            customer.value = Get.arguments[1];
            loadData(customer.value!, RoutePage.fromNewCustomerNot);
            break;
        default:
        }
    }

    void countApiLoading(){
        countLoading++;
        if(countLoading == 1) {
            isLoading.value = false;
        }
    }


    void generateListProduct(int idx) {
        Timer(const Duration(milliseconds: 500), () {
        idx = idx - 1;
        skuCard.controller.spinnerProduct.value[idx].controller
            .generateItems(mapList.value);
        });
    }

    void getIssueCategories(){
        isLoadKendala.value = true;
        Service.push(
            service: ListApi.getOrderIssueCategories,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    List<String> list=[];
                    for (var element in (body as OrderIssueResponse).data) {
                        list.add(element!.title!);
                        orderIssueCategories.value.add(element);
                    }

                    spinnerMulti.controller.items.value = list;
                    isLoadKendala.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );

                    isLoadKendala.value = false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, $exception",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );

                    isLoadKendala.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()
            )
        );
    }

    void getProvince() {
        Service.push(
            service: ListApi.getProvince,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Map<String, bool> mapList = {};
                    body.data.forEach((location) {
                        mapList[location!.provinceName!] = false;
                        province.value.add(location);
                    } );
                    spinnerProvince.controller.generateItems(mapList);
                    countApiLoading();
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                //  isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()
            ),
        );
    }

    void getCity(location_model.Location province) {
        isLoadApi.value = true;
        Service.push(
            service: ListApi.getCity,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, province.id],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Map<String, bool> mapList = {};
                    body.data.forEach((location) {
                         mapList[location!.cityName!] = false;
                         city.value.add(location);
                    });

                    spinnerKota.controller.generateItems(mapList);
                    spinnerKota.controller.enable();

                    isLoadApi.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                              onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
                );
                //  isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()
            ),
        );
    }

    void getDistrict(location_model.Location city) {
        isLoadApi.value = true;
        Service.push(
            service: ListApi.getDistrict,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, city.id],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Map<String, bool> mapList = {};
                    body.data.forEach((location) {
                        district.value.add(location);
                        mapList[location!.districtName!] = false;
                    } );
                    spinnerKecamatan.controller.generateItems(mapList);
                    spinnerKecamatan.controller.enable();

                    isLoadApi.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {

                },
                onTokenInvalid: Constant.invalidResponse()
            ),
        );
    }

    void getListCustomer() {
        isLoadApi.value = true;
        Service.push(
            apiKey: 'userApi',
            service: ListApi.searchCustomerVisit,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, provinceSelect!.id!, citySelect!.id!, districtSelect!.id, page, limit],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Map<String, bool> mapList = {};
                    for (var customer in (body as ListCustomerResponse).data) {
                      mapList[customer!.businessName!] = false;
                    }
                    spinnerNamaBisnis.controller.generateItems(mapList);
                    spinnerNamaBisnis.controller.enable();

                    for (var result in body.data) {
                        listCustomer.value.add(result!);
                    }

                    isLoadApi.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                              onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
                );
                //  isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()
            ),
        );
    }

    void getDetailCustomer() {
        isLoading.value = true;
        Service.push(
            apiKey: 'userApi',
            service: ListApi.detailCustomerById,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetDetailCustomerById(customerSelect!.id!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    customer.value = (body as CustomerResponse).data;

                    if (body.data!.latestVisit != null && body.data!.latestVisit!.leadStatus != null) {
                        spinnerLead.controller.setTextSelected(body.data!.latestVisit!.leadStatus!);
                    }

                    if (body.data!.products != null) {
                        for (int i = 0; i < body.data!.products!.length - 1; i++) {
                            skuCard.controller.addCard();
                        }

                        for (int j = 0; j < skuCard.controller.itemCount.value; j++) {
                            skuCard.controller.spinnerProduct.value[j].controller.setTextSelected(body.data!.products![j]!.category!.name!);
                            skuCard.controller.spinnerSize.value[j].controller.setTextSelected(body.data!.products![j]!.name!);
                            skuCard.controller.editFieldJenis.value[j].setInput(body.data!.products![j]!.dailyQuantity!.toString());
                            skuCard.controller.editFieldHarga.value[j].setInput(body.data!.products![j]!.price!.toString());
                        }
                    }

                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()
            ),
        );
    }

    void getProduct() {
        Service.push(
            service: ListApi.getCategories,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    for (var result in (body as CategoryListResponse).data) {
                        listCategories.value.add(result);
                    }
                    Map<String, bool> mapList = {};
                    for (var product in body.data) {
                      mapList[product!.name!] = false;
                    }
                    for( int i =0;  i < skuCard.controller.itemCount.value; i++) {
                        skuCard
                            .controller
                            .spinnerProduct
                            .value[i]
                            .controller
                            ..hideLoading()..enable()..generateItems(mapList);
                    }


                    skuCard.controller.setMaplist(listCategories.value);
                    this.mapList.value = mapList;
                    countApiLoading();

                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );

                    isLoadApi.value = false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoadApi.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()
            ),
        );
    }

    void loadData(Customer customer, int whereFrom) {
        switch (whereFrom) {
        case RoutePage.fromDetailCustomer:
            if (customer.latestVisit != null && customer.latestVisit!.leadStatus != null) {
                spinnerLead.controller.setTextSelected(customer.latestVisit!.leadStatus!);
            }
            break;
        case RoutePage.fromNewCustomerNot:
            spinnerLead.controller.setTextSelected("Belum");
            break;
        case RoutePage.fromNewCustomerYes:
            spinnerLead.controller.setTextSelected("Akan");
            break;
        default:
        }

        if (customer.products!.isNotEmpty && customer.products != null) {
            for (int i = 0; i < customer.products!.length - 1; i++) {
                skuCard.controller.addCard();
            }
            for (int j = 0; j < customer.products!.length; j++) {
                skuCard.controller.spinnerProduct.value[j].controller.setTextSelected(customer.products![j]!.category!.name!);
                skuCard.controller.spinnerSize.value[j].controller.setTextSelected(customer.products![j]!.name!);
                skuCard.controller.editFieldJenis.value[j].setInput(customer.products![j]!.dailyQuantity!.toString());
                skuCard.controller.editFieldHarga.value[j].setInput(customer.products![j]!.price!.toString());
            }
        }
        countApiLoading();
    }

    List validation() {
        List ret = [true, ""];
        if (spinnerLead.controller.textSelected.value.isEmpty) {
            spinnerLead.controller.showAlert();
            Scrollable.ensureVisible(spinnerLead.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (spinnerKendala.controller.textSelected.value == "Ya") {
            if (spinnerMulti.controller.selectedValue.value.isEmpty) {
                spinnerMulti.controller.showAlert();
                return ret = [false, ""];
            } else if (spinnerMulti.controller.selectedValue.value.contains("Harga")) {
                ret = skuCard.controller.validation();
                if (ret[0] == false) {
                    return ret;
                }
            }
        } else if (spinnerKendala.controller.textSelected.value.isEmpty) {
            spinnerKendala.controller.showAlert();
            Scrollable.ensureVisible(spinnerKendala.controller.formKey.currentContext!);
        }

        if (editAlasan.getInput().isEmpty) {
            editAlasan.controller.showAlert();
            Scrollable.ensureVisible(editAlasan.controller.formKey.currentContext!);
            return ret = [false, ""];
        }

        if (spinnerProspek.controller.textSelected.value.isEmpty) {
            spinnerProspek.controller.showAlert();
            Scrollable.ensureVisible(spinnerProspek.controller.formKey.currentContext!);
            return ret = [false, ""];
        }

        return ret;
    }

    VisitCustomer generatePayload() {
        List<Products?> listProductPayload = [];
        if (spinnerMulti.controller.selectedValue.value.contains("Harga")) {
            var listProductTemp = skuCard.controller.listProduct.value.values.toList();
            for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
                CategoryModel? selectCategory;
                int whichItem = skuCard.controller.index.value[i];
                if (listCategories.value.isNotEmpty) {
                    selectCategory= listCategories.value.firstWhereOrNull((element) => element!.name! ==  skuCard.controller.spinnerProduct.value[whichItem].controller.textSelected.value);
                    if(selectCategory == null) {
                        Products? selectTemp = customer.value!.products!.firstWhereOrNull((element) => element!.category!.name! == skuCard.controller.spinnerProduct.value[whichItem].controller.textSelected.value );
                        selectCategory = selectTemp!.category;
                    }
                } else {
                    Products? selectTemp = customer.value!.products!.firstWhereOrNull((element) => element!.category!.name! == skuCard.controller.spinnerProduct.value[whichItem].controller.textSelected.value );
                    selectCategory = selectTemp!.category;
                }

                Products? selectProduct;
                if (skuCard.controller.listProduct.value.isNotEmpty) {
                    for(int j =0 ; j < listProductTemp.length; j++){
                        selectProduct = listProductTemp[j].firstWhereOrNull((element) => element!.name! == skuCard.controller.spinnerSize.value[whichItem].controller.textSelected.value, );
                    }
                    selectProduct ??= customer.value!.products!.firstWhereOrNull((element) => element!.name == skuCard.controller.spinnerSize.value[whichItem].controller.textSelected.value );
                } else {
                    selectProduct = customer.value!.products!.firstWhereOrNull((element) => element!.name == skuCard.controller.spinnerSize.value[whichItem].controller.textSelected.value );
                }
                selectProduct?.category = selectCategory;
                selectProduct?.dailyQuantity = skuCard.controller.editFieldJenis.value[whichItem].getInputNumber()!.toInt();
                selectProduct?.price = skuCard.controller.editFieldHarga.value[whichItem].getInputNumber();
                selectProduct?.uom ??= selectCategory?.name == AppStrings.AYAM_UTUH  || selectCategory?.name == AppStrings.LIVE_BIRD || selectCategory?.name == AppStrings.BRANGKAS || selectCategory?.name == AppStrings.KARKAS? "ekor" : "kg" ;
                selectProduct?.value ??= 1;
                listProductPayload.add(selectProduct);
            }
        } else {
            listProductPayload = customer.value!.products!;
        }

        List<OrderIssueCategories?>? categories =[];

        for (var spinner in spinnerMulti.controller.selectedValue.value) {
            OrderIssueCategories? select = orderIssueCategories.value.firstWhereOrNull((list) => list!.title! == spinner);
            categories.add(select);
        }

        return VisitCustomer(
            latitude: latitude,
            longitude: longitude,
            orderIssue: spinnerKendala.controller.textSelected.value.isNotEmpty
                ? spinnerKendala.controller.textSelected.value == "Ya"
                    ? true
                    : false
                : null,
            orderIssueCategories:
                spinnerKendala.controller.textSelected.value == "Ya"
                    ? categories
                    : [],
            leadStatus: spinnerLead.controller.textSelected.value,
            remarks: Uri.encodeFull(editAlasan.getInput()),
            prospect: spinnerProspek.controller.textSelected.value,
            products: spinnerMulti.controller.selectedValue.value.contains("Harga")
                ? listProductPayload
                : [],
        );
    }
}

class VisitBindings extends Bindings {
    BuildContext context;
    VisitBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => VisitController(context: context));
    }
}