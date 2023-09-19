import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_plus_code/google_plus_code.dart' as gpc;
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/internal_app/place_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/customer_response.dart';
import 'package:model/response/internal_app/location_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card/sku_card.dart';
import 'package:pitik_internal_app/widget/sku_card/sku_card_controller.dart';

class NewDataController extends GetxController {
    BuildContext context;

    NewDataController({required this.context});

    Customer? customer;

    final EditField editNamaPemilik = EditField(
        controller: GetXCreator.putEditFieldController("namaPemilikBaru"),
        label: "Nama Pemilik*",
        hint: "Ketik Disini",
        alertText: "Nama pemilik harus diisi!",
        textUnit: "",
        maxInput: 100,
        action: TextInputAction.next,
        onTyping: (text, editField) {},
    );
    final EditField editNamaBisnis = EditField(
        controller: GetXCreator.putEditFieldController("namaBisnisBaru"),
        label: "Nama Bisnis*",
        hint: "Ketik Disini",
        alertText: "Nama bisnis harus diisi!",
        textUnit: "",
        maxInput: 100,
        action: TextInputAction.next,
        onTyping: (text, editField) {},
    );
    final EditField editNomorTelepon = EditField(
        controller: GetXCreator.putEditFieldController("nomorTeleponBaru"),
        label: "Nomor Telepon*",
        hint: "Ketik Disini",
        alertText: "Nomor telepon harus diisi!",
        textUnit: "",
        inputType: TextInputType.phone,
        maxInput: 100,
        action: TextInputAction.next,
        onTyping: (text, editField) {},
    );
    final EditField editLokasiGoogle = EditField(
        controller: GetXCreator.putEditFieldController("lokasiGoogleBaru"),
        label: "Lokasi Google Maps Plus Code*",
        hint: "Ketik Disini",
        alertText: "Lokasi google harus diisi!",
        textUnit: "",
        maxInput: 100,
        onTyping: (text, editField) {},
    );

    late SpinnerField spinnerSupplier;
    final EditField editSalesPIC = EditField(
        controller: GetXCreator.putEditFieldController("picSales Edit"),
        label: "PIC Sales",
        hint: "Ketik Disini",
        alertText: "",
        textUnit: "",
        maxInput: 100,
        onTyping: (text, editField) {},
    );
    late SpinnerField spinnerTipeBisnis = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("tipeBisnisBaru"),
        label: "Tipe Bisnis*",
        hint: "Pilih Nama Bisnis",
        alertText: "Tipe bisnis harus dipilih!",
        items: const {
            "Rumah Makan": false,
            "Warung": false,
            "Restoran": false,
            "Pedagang Keliling": false,
            "Catering": false,
            "Non-Bisnis": false
        },
        onSpinnerSelected: (text) {},
    );
    late SpinnerSearch spinnerProvince = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("provinceBaru"),
        label: "Provinsi*",
        hint: "Pilih Provinsi",
        alertText: "Provinsi harus dipilih!",
        items: const {},
        onSpinnerSelected: (text) {
            try {
                if (province.value.isNotEmpty) {
                    Location? selectLocation = province.value.firstWhere((element) => element!.provinceName! == text);
                    if (selectLocation != null) {
                        getCity(selectLocation);
                    }
                }
            } catch (e) {
                Get.snackbar("Error", "$e");
            }
        },
    );
    late SpinnerSearch spinnerKota = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("kotaBaru"),
        label: "Kota*",
        hint: "Pilih Kota",
        alertText: "Kota harus dipilih!",
        items: const {},
        onSpinnerSelected: (text) {
            try {
                if (city.value.isNotEmpty) {
                    Location? selectLocation = city.value.firstWhere((element) => element!.cityName! == text);
                    if (selectLocation != null) {
                        getDistrict(selectLocation);
                    }
                }
            } catch (e, st) {
                Get.snackbar("Error", "Error : $e $st");
            }
        },
    );
    late SpinnerSearch spinnerKecamatan = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("kecamatanBaru"),
        label: "Kecamatan*",
        hint: "Pilih Kecamatan",
        alertText: "Tipe bisnis harus dipilih!",
        items: const {},
        onSpinnerSelected: (text) {},
    );
    final EditField editNamaSupplier = EditField(
        controller: GetXCreator.putEditFieldController("pasarBaru"),
        label: "Nama Supplier",
        hint: "Ketik Disini",
        alertText: "",
        textUnit: "",
        maxInput: 20,
        action: TextInputAction.done,
        onTyping: (text, editField) {},
    );

    late SkuCard skuCard ;

    late ButtonFill iyaVisitButton;
    late ButtonOutline tidakVisitButton;

    int page = 1;
    int limit = 10;
    var isLoading = false.obs;
    var isLoadSales = false.obs;
    var isLoadProvince = false.obs;
    var isLoadCity = false.obs;
    var isLoadDistrict = false.obs;
    var isLoadProduct = false.obs;

    Rx<List<SalesPerson?>> listSalesPerson = Rx<List<SalesPerson>>([]);
    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
    Rx<List<Location?>> province = Rx<List<Location>>([]);
    Rx<List<Location?>> city = Rx<List<Location>>([]);
    Rx<List<Location?>> district = Rx<List<Location>>([]);
  //   late SkuCardController skuListener;
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    @override
    void onInit() {
        super.onInit();     
        skuCard = SkuCard(controller: InternalControllerCreator.putSkuCardController("cardController",context));           
        editSalesPIC.setInput(Constant.userGoogle!.email!);
        editSalesPIC.controller.disable();
        isLoading.value = true;
        editNamaSupplier.controller.invisibleField();

        spinnerSupplier = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("supplierBaru"),
            label: "Supplier*",
            hint: "Pilih Jenis Suplier",
            alertText: "Tipe bisnis harus dipilih!",
            items: const {
                "JAGAL": false,
                "PASAR": false,
                "LAINNYA": false,
            },
            onSpinnerSelected: (text) {
                if (text.isNotEmpty) {
                    editNamaSupplier.controller.visibleField();
                }
            },
        );

        tidakVisitButton = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("tidakVisit"),
            label: "Tidak",
            onClick: () {
                saveCustomer(false);
            },
        );

        iyaVisitButton = ButtonFill(
            controller: GetXCreator.putButtonFillController("iyaVisit"),
            label: "Ya",
            onClick: () {
                saveCustomer(true);
            },
        );
    }

    @override
    void onReady() {
        super.onReady();
        Get.find<SkuCardController>(tag: "cardController").numberList.listen((p0) {
            generateListProduct(p0);
        });
        Timer(const Duration(milliseconds: 500), () {
        getProduct(); });
        spinnerKota.controller.disable();
        spinnerKecamatan.controller.disable();
         WidgetsBinding.instance.addPostFrameCallback((_) {
            Timer(const Duration(milliseconds: 500), () {
                getProvince();
            });
         });

        
    }


    void generateListProduct(int idx) {
        Timer(const Duration(milliseconds: 500), () {
            idx = idx - 1;
            skuCard.controller.spinnerProduct.value[idx].controller.generateItems(mapList.value);
        });
    }

    void getProvince() {
        // isLoadProvince.value = true;
        Service.pushWithIdAndPacket(
            service: ListApi.getProvince,
            context: context,
            id: 1,
            packet: [isLoadProvince, province, spinnerProvince,isLoading],
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
            listener: _getListLocationListener
        );
    }

    void getCity(Location province) {
        // isLoadCity.value = true;
        Service.pushWithIdAndPacket(
            service: ListApi.getCity,
            context: context,
            id: 2,
            packet: [isLoadCity, city, spinnerKota,isLoading],
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, province.id],
            listener: _getListLocationListener
        );
    }

    void getDistrict(Location city) {
        // isLoadDistrict.value = true;
        Service.pushWithIdAndPacket(
            service: ListApi.getDistrict,
            context: context,
            id: 3,
            packet: [isLoadDistrict, district, spinnerKecamatan,isLoading],
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, city.id],
            listener: _getListLocationListener
        );
    }

    void getProduct() {
        // isLoading.value = true;
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
                    Timer(const Duration(milliseconds: 500), () { skuCard.controller.spinnerProduct.value[0].controller.generateItems(mapList);});

                    skuCard.controller.setMaplist(listCategories.value);
                    this.mapList.value = mapList;
                    // isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar("Alert", body.error!.message!,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    // isLoading.value = false;
                    Get.snackbar("Alert","Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                },
                onTokenInvalid: Constant.invalidResponse()
            ),
        );
    }

    void saveCustomer(bool isYesButton) {
        Get.back();
        List ret = validation();
        if (ret[0]) {
            isLoading.value = true;
            try {
              Customer cusPayload = generatePayload(true);
              Service.push(
                  apiKey: 'userApi',
                  service: ListApi.createCustomer,
                  context: context,
                  body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, Mapper.asJsonString(cusPayload)],
                  listener:ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                          Get.back();
                          if (isYesButton) {
                              Get.toNamed(RoutePage.visitCustomer, arguments: [RoutePage.fromNewCustomerYes, (body as CustomerResponse).data]);
                          } else {
                              Get.toNamed(RoutePage.visitCustomer, arguments: [RoutePage.fromNewCustomerNot, (body as CustomerResponse).data]);
                          }
                          isLoading.value = false;
                      },
                      onResponseFail: (code, message, body, id, packet) {
                          isLoading.value = false;
                          Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 5),
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                      },
                      onResponseError: (exception, stacktrace, id, packet) {
                          isLoading.value = false;
                          Get.snackbar("Alert","Terjadi kesalahan internal", snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 5),
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                      },
                      onTokenInvalid: Constant.invalidResponse()
                  ),
              );
            } catch (e,st) {
              Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                        backgroundColor: const Color(0xFFFF0000),
                        colorText: const Color(0xFFFFFFFF));
            }
            
        } else {
            if (ret[1] != null) {
                if ((ret[1] as String).isNotEmpty) {
                    Get.snackbar("Pesan", "Duplikat Item Produk, ${ret[1]}",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                        backgroundColor: const Color(0xFFFF0000),
                        colorText: const Color(0xFFFFFFFF));
                }
            }
        }
    }

    List validation() {
        List ret = [true, ""];

        if (editNamaBisnis.getInput().isEmpty) {
            editNamaBisnis.controller.showAlert();
            Scrollable.ensureVisible(editNamaBisnis.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (spinnerTipeBisnis.controller.textSelected.value.isEmpty) {
            spinnerTipeBisnis.controller.showAlert();
            Scrollable.ensureVisible(spinnerTipeBisnis.controller.formKey.currentContext!);

            return ret = [false, ""];
        }
        if (editNamaPemilik.getInput().isEmpty) {
            editNamaPemilik.controller.showAlert();
            Scrollable.ensureVisible(editNamaPemilik.controller.formKey.currentContext!);

            return ret = [false, ""];
        }

        if (editNomorTelepon.getInput().isEmpty) {
            editNomorTelepon.controller.showAlert();
            Scrollable.ensureVisible(editNomorTelepon.controller.formKey.currentContext!);

            return ret = [false, ""];
        } else {
            final String mobilePhone = editNomorTelepon.getInput();
            if (RegExp(r'^0([2-9]{1})([0-9]{7,11})', caseSensitive: false,).hasMatch(mobilePhone) == false) {
                editNomorTelepon.controller.setAlertText("Nomor telepon tidak valid!");
                Scrollable.ensureVisible(editNomorTelepon.controller.formKey.currentContext!);
                editNomorTelepon.controller.showAlert();
                return ret = [false, ""];
            }
        }

        if (editLokasiGoogle.getInput().isEmpty) {
            editLokasiGoogle.controller.showAlert();
            Scrollable.ensureVisible(editLokasiGoogle.controller.formKey.currentContext!);

            return ret = [false, ""];
        } else if (editLokasiGoogle.getInput().isNotEmpty) {
            final List<String> getCode = editLokasiGoogle.getInput().split(" ");
            if(getCode[0].contains(",")){
                getCode[0] = getCode[0].replaceAll(",",'');
            }

            bool rets = gpc.isValid(getCode[0]);
            if (!rets) {
                editLokasiGoogle.controller.setAlertText("Lokasi Google Tidak Valid");
                editLokasiGoogle.controller.showAlert();
                Scrollable.ensureVisible(editLokasiGoogle.controller.formKey.currentContext!);

                return ret = [false, ""];
          }
        }

        if (spinnerProvince.controller.textSelected.value.isEmpty) {
            spinnerProvince.controller.showAlert();
            Scrollable.ensureVisible(spinnerProvince.controller.formKey.currentContext!);

            return ret = [false, ""];
        }

        if (spinnerKota.controller.textSelected.value.isEmpty) {
            spinnerKota.controller.showAlert();
            Scrollable.ensureVisible(spinnerKota.controller.formKey.currentContext!);

            return ret = [false, ""];
        }
        if (spinnerKecamatan.controller.textSelected.value.isEmpty) {
            spinnerKecamatan.controller.showAlert();
            Scrollable.ensureVisible(spinnerKecamatan.controller.formKey.currentContext!);

            return ret = [false, ""];
        }

        if (spinnerSupplier.controller.textSelected.value.isEmpty) {
            spinnerSupplier.controller.showAlert();
            Scrollable.ensureVisible(spinnerSupplier.controller.formKey.currentContext!);
            return ret = [false, ""];
        }

        ret = skuCard.controller.validation();
        return ret;
    }

    Customer generatePayload(bool isyes) {
        List<Products?> listProductPayload = [];
        var listProductTemp = skuCard.controller.listProduct.value.values.toList();
        for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
            int whichItem = skuCard.controller.index.value[i];
            CategoryModel? selectCategory = listCategories.value.firstWhere((element) => element!.name! == skuCard.controller.spinnerProduct.value[whichItem].controller.textSelected.value);
            Products? selectProduct;
            selectProduct = listProductTemp[whichItem].firstWhere((element) => element!.name! == skuCard.controller.spinnerSize.value[whichItem].controller.textSelected.value );
            selectProduct?.category = selectCategory;
            selectProduct?.dailyQuantity = int.parse(skuCard.controller.editFieldJenis.value[whichItem].getInput());
            selectProduct?.price = skuCard.controller.editFieldHarga.value[whichItem].getInputNumber();
            listProductPayload.add(selectProduct);
        }

        Location? provinceSelect = province.value.firstWhere(
            (element) => element!.provinceName == spinnerProvince.controller.textSelected.value,
        );

        Location? citySelect = city.value.firstWhere(
            (element) => element!.cityName == spinnerKota.controller.textSelected.value,
        );

        Location? districSelect = district.value.firstWhere(
          (element) => element!.districtName == spinnerKecamatan.controller.textSelected.value,
        );

        return Customer(
            businessName: editNamaBisnis.getInput(),
            businessType: spinnerTipeBisnis.controller.textSelected.value,
            ownerName: editNamaPemilik.getInput(),
            phoneNumber: editNomorTelepon.getInput(),
            salespersonId: Constant.profileUser!.id,
            plusCode: editLokasiGoogle.getInput(),
            provinceId: provinceSelect!.id!,
            cityId: citySelect!.id!,
            districtId: districSelect!.id!,
            supplier: spinnerSupplier.controller.textSelected.value,
            supplierDetail: spinnerSupplier.controller.textSelected.value.isNotEmpty ? editNamaSupplier.getInput(): null,
            products: listProductPayload,
            isArchived: false,
        );
    }

    final _getListLocationListener = ResponseListener(
        onResponseDone: (code, message, body, id, packet) async{
            if (id == 1) {
                Map<String, bool> mapList = {};
                for (var location in (body as LocationListResponse).data) {
                  mapList[location!.provinceName!] = false;
                }

                

                Timer(const Duration(milliseconds: 500), () {(packet[2] as SpinnerSearch).controller.generateItems(mapList); });

                for (var result in body.data) {
                    (packet[1] as Rx<List<Location?>>).value.add(result);
                }

                packet[0].value = false;
                packet[3].value = false;
            }

            if (id == 2) {
                Map<String, bool> mapList = {};
                for (var location in (body as LocationListResponse).data) {
                  mapList[location!.cityName!] = false;
                }
                (packet[2] as SpinnerSearch).controller.generateItems(mapList);
                (packet[2] as SpinnerSearch).controller.enable();

                for (var result in body.data) {
                    (packet[1] as Rx<List<Location?>>).value.add(result);
                }
                packet[0].value = false;
            }

            if (id == 3) {
                Map<String, bool> mapList = {};
                for (var location in (body as LocationListResponse).data) {
                  mapList[location!.districtName!] = false;
                }
                (packet[2] as SpinnerSearch).controller.generateItems(mapList);
                (packet[2] as SpinnerSearch).controller.enable();

                for (var result in body.data) {
                    (packet[1] as Rx<List<Location?>>).value.add(result);
                }
                packet[0].value = false;
            }
        },
        onResponseFail: (code, message, body, id, packet) {
            packet[0].value = false;
            packet[3].value = false;
            Get.snackbar("Alert", body.error!.message!,
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white);
        },
        onResponseError: (exception, stacktrace, id, packet) {
            packet[0].value = false;
            packet[3].value = false;
            Get.snackbar("Alert","Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white);
        },
        onTokenInvalid: Constant.invalidResponse()
    );
}

class NewDataBindings extends Bindings {
    BuildContext context;
    NewDataBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => NewDataController(context: context));
    }
}
