import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:google_plus_code/google_plus_code.dart' as gpc;
import 'package:model/branch.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/internal_app/place_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';
import 'package:model/response/%20branch_response.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/location_list_response.dart';
import 'package:model/response/internal_app/salesperson_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card/sku_card.dart';
import 'package:pitik_internal_app/widget/sku_card/sku_card_controller.dart';
class EditDataController extends GetxController {
    BuildContext context;

    EditDataController({required this.context});

    final EditField editNamaPemilik = EditField(
        controller: GetXCreator.putEditFieldController("namaPemilikBaru"),
        label: "Nama Pemilik*",
        hint: "Ketik Disini",
        alertText: "Nama pemilik harus diisi!",
        textUnit: "",
        maxInput: 100,
        onTyping: (text, editField) {},
    );

    final EditField editNamaBisnis = EditField(
        controller: GetXCreator.putEditFieldController("namaBisnisBaru"),
        label: "Nama Bisnis*",
        hint: "Ketik Disini",
        alertText: "Nama bisnis harus diisi!",
        textUnit: "",
        maxInput: 100,
        onTyping: (text, editField) {},
    );

    final EditField editNomorTelepon = EditField(
        controller: GetXCreator.putEditFieldController("nomorTeleponBaru"),
        label: "Nama Telepon*",
        hint: "Ketik Disini",
        alertText: "Nomor telepon harus diisi!",
        textUnit: "",
        inputType: TextInputType.phone,
        maxInput: 100,
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
    late SpinnerSearch spinnerPicSales = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("spinnerPicSales"),
        label: "PIC Sales*",
        hint: "Pilih PIC Sales",
        alertText: "Sales harus dipilih!",
        items: const {},
        onSpinnerSelected: (text) {},
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
            if (province.value.isNotEmpty) {
                Location? selectLocation = province.value.firstWhere((element) => element!.provinceName! == text);
                if (selectLocation != null) {
                    getCity(selectLocation);
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
                Location? selectLocation = city.value.firstWhere((element) => element!.cityName! == text);
                if (selectLocation != null) {
                    getDistrict(selectLocation);
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
        onSpinnerSelected: (text) {},
    );

    final EditField editNamaSupplier = EditField(
        controller: GetXCreator.putEditFieldController("pasarBaru"),
        label: "Nama Supplier",
        hint: "Ketik Disini",
        alertText: "",
        textUnit: "",
        maxInput: 100,
        onTyping: (text, editField) {},
    );
    
    SpinnerSearch spBranch = SpinnerSearch(
        controller: GetXCreator.putSpinnerSearchController("spBranch"),
        label: "Branch*",
        hint: "Pilih Branch",
        alertText: "Branch harus dipilih!",
        items: const {},
        onSpinnerSelected: (text) {
            
        },
    );

    late SkuCard skuCard = SkuCard(controller: InternalControllerCreator.putSkuCardController("editCardController", context));

    late ButtonFill simpanButton;

    int page = 1;
    int limit = 10;
    var isLoading = false.obs;
    var isLoadApi = false.obs;
    var isSalesLead = false.obs;

    late Customer customer;

    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
    Rx<List<SalesPerson?>> listSalesperson = Rx<List<SalesPerson>>([]);
    Rx<List<Location?>> province = Rx<List<Location>>([]);
    Rx<List<Location?>> city = Rx<List<Location>>([]);
    Rx<List<Location?>> district = Rx<List<Location>>([]);
  //   late SkuCardController skuListener;
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
    Rx<List<Branch?>> listBranch = Rx<List<Branch?>>([]);

    @override
    void onInit() {
        super.onInit();
        spinnerPicSales.controller.disable();
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

        customer = Get.arguments;

        simpanButton = ButtonFill(
            controller: GetXCreator.putButtonFillController("simpanButton"),
            label: "Simpan",
            onClick: () => saveCustomer()
        );

        isLoading.value = false;
    }

    @override
    void onReady() {
        super.onReady();       
        Get.find<SkuCardController>(tag: "editCardController")
            .itemCount
            .listen((p0) => generateListProduct(p0)
        );
        isLoading.value = true;
        getProvince();
        getProduct();
        getBranch();
        loadData(customer);
        for(var role in Constant.profileUser!.roles!){
            if(role!.name == AppStrings.sales_lead){
                getSalesList();
                isSalesLead.value = true;
            }
        }
    }
    
    void getBranch(){
        AuthImpl().get().then((auth) => {
            if (auth != null){
                spBranch.controller.showLoading(),
                Service.push(
                    apiKey: "api",
                    service: ListApi.getBranch,
                    context: context,
                    body: [
                        'Bearer ${auth.token}',
                        auth.id,
                        Constant.xAppId,
                    ],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            for (var result in (body as ListBranchResponse).data) {
                                listBranch.value.add(result);
                            }

                            Map<String, bool> mapList = {};
                            for (var branch in body.data) {
                                mapList[branch!.name!] = false;
                            }
                            spBranch.controller.generateItems(mapList);
                            spBranch.controller.hideLoading();
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                            spBranch.controller.hideLoading();
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                            spBranch.controller.hideLoading();
                        },
                            onTokenInvalid: () => Constant.invalidResponse()))
                    }
            else
                {Constant.invalidResponse()}
        });
    }


    void loadData(Customer custArg) {
        editNamaBisnis.setInput(custArg.businessName!);
        spinnerTipeBisnis.controller.setTextSelected(custArg.businessType!);
        editNamaPemilik.setInput(custArg.ownerName!);
        editNomorTelepon.setInput(custArg.phoneNumber!);
        spinnerPicSales.controller.setTextSelected(custArg.salesperson!.email!);
        editLokasiGoogle.setInput(custArg.plusCode!);
        spinnerProvince.controller.setTextSelected(custArg.province!.name!);
        spinnerKota.controller.setTextSelected(custArg.city!.name!);
        spinnerKota.controller.disable();
        spinnerKecamatan.controller.setTextSelected(custArg.district!.name!);
        spinnerKecamatan.controller.disable();
        if(custArg.branch!=null){
            spBranch.controller.setTextSelected(custArg.branch!.name!);
        } else {
            spBranch.controller.setTextSelected("Branch tidak ditemukan");
            spBranch.controller.disable();
        }

        if (custArg.supplier!.isNotEmpty) {
            spinnerSupplier.controller.setTextSelected(custArg.supplier!);
            editNamaSupplier.setInput(custArg.supplierDetail!);
            editNamaSupplier.controller.visibleField();
        } 

        if (custArg.products!.isNotEmpty && customer.products != null) {
            for (int i = 0; i < custArg.products!.length - 1; i++) {
                skuCard.controller.addCard();
            }
            Map<String, bool> listKebutuhan = {};
            for (var product in listCategories.value) {
              listKebutuhan[product!.name!] = false;
            }
            Timer(Duration.zero, () { 
                for (int j = 0; j < custArg.products!.length; j++) {
                    skuCard.controller.spinnerProduct.value[j].controller.setTextSelected(customer.products![j]!.category!.name!);
                    skuCard.controller.spinnerProduct.value[j].controller.generateItems(listKebutuhan);
                    skuCard.controller.spinnerSize.value[j].controller.setTextSelected(customer.products![j]!.name!);
                    skuCard.controller.editFieldJenis.value[j].setInput(customer.products![j]!.dailyQuantity!.toString());
                    skuCard.controller.editFieldHarga.value[j].setInput(customer.products![j]!.price!.toString());
                }
            });
        }
    }

    void generateListProduct(int idx) {
        Timer(const Duration(milliseconds: 500), () {
            idx = idx - 1;
            skuCard.controller.spinnerProduct.value[idx].controller.generateItems(mapList.value);
        });
    }

    void getProvince() {
        isLoadApi.value = true;
        Service.pushWithIdAndPacket(
            service: ListApi.getProvince,
            context: context,
            id: 1,
            packet: [isLoadApi, province, spinnerProvince],
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
            listener: _getListLocationListener
        );
    }

    void getCity(Location province) {
        isLoadApi.value = true;
        Service.pushWithIdAndPacket(
            service: ListApi.getCity,
            context: context,
            id: 2,
            packet: [isLoadApi, city, spinnerKota],
            body: [Constant.auth!.token, Constant.auth!.id, province.id, Constant.xAppId!],
            listener: _getListLocationListener
        );
    }

    void getDistrict(Location city) {
        isLoadApi.value = true;
        Service.pushWithIdAndPacket(
            service: ListApi.getDistrict,
            context: context,
            id: 3,
            packet: [isLoadApi, district, spinnerKecamatan],
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, city.id],
            listener: _getListLocationListener
        );
    }

    void getProduct() {
        isLoading.value = true;
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
                    skuCard
                        .controller
                        .spinnerProduct
                        .value[0]
                        .controller
                        .generateItems(mapList);

                    skuCard.controller.setMaplist(listCategories.value);
                    this.mapList.value = mapList;
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar("Alert", (body as ErrorResponse).error!.message!,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
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

    void saveCustomer() {
        List ret = validation();
        if (ret[0]) {
            isLoading.value = true;
            Customer cusPayload = generatePayload();
            Service.push(
                apiKey: 'userApi',
                service: ListApi.updateCustomerById,
                context: context,
                body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathUpdateCustomerById(customer.id!), Mapper.asJsonString(cusPayload)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        isLoading.value = false;
                       Get.back();
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        isLoading.value = false;
                        Get.snackbar("Alert", (body as ErrorResponse).error!.message!,
                            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        isLoading.value = false;
                        Get.snackbar("Alert","Terjadi kesalahan internal",
                            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                    },
                    onTokenInvalid: Constant.invalidResponse()
                ),
            );
        } else {
            if (ret[1] != null) {
                if ((ret[1] as String).isNotEmpty) {
                    Get.snackbar(
                        "Pesan", "Duplikat Item Produk, ${ret[1]}",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                        backgroundColor: const Color(0xFFFF0000),
                        colorText: const Color(0xFFFFFFFF)
                    );
                }
            }
        }
    }

    List validation() {
        List ret = [true, ""];

        if (editNamaBisnis.getInput().isEmpty) {
            editNamaBisnis.controller.showAlert();
            editNamaBisnis.controller.focusNode.requestFocus();
            Get.snackbar("Alert", "Nama Bisnis harus di isi!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

            return ret = [false, ""];
        }

        if (spinnerTipeBisnis.controller.textSelected.value.isEmpty) {
            spinnerTipeBisnis.controller.showAlert();
            spinnerTipeBisnis.controller.focusNode.requestFocus();
            Get.snackbar("Alert", "Tipe Bisnis harus di pilih!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

            return ret = [false, ""];
        }

        if (editNamaPemilik.getInput().isEmpty) {
            editNamaPemilik.controller.showAlert();
            editNamaPemilik.controller.focusNode.requestFocus();
            Get.snackbar("Alert", "Nama Pemilik harus di isi!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

            return ret = [false, ""];
        }

        if (editNomorTelepon.getInput().isEmpty) {
            editNomorTelepon.controller.showAlert();
            editNomorTelepon.controller.focusNode.requestFocus();
            Get.snackbar("Alert", "Nomor Telepon harus di isi!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

            return ret = [false, ""];
        } else {
            final String mobilePhone = editNomorTelepon.getInput();
            if (RegExp(r'^0([2-9]{1})([0-9]{7,11})', caseSensitive: false,).hasMatch(mobilePhone) == false) {
                editNomorTelepon.controller.setAlertText("Nomor telepon tidak valid!");
                editNomorTelepon.controller.showAlert();
                editNomorTelepon.controller.focusNode.requestFocus();
                Get.snackbar("Alert", "Nomor Telepon Tidak Valid!",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    backgroundColor: Colors.red,
                    colorText: Colors.white
                );

                return ret = [false, ""];
            }
        }

        if (editLokasiGoogle.getInput().isEmpty) {
            editLokasiGoogle.controller.showAlert();
            editLokasiGoogle.controller.focusNode.requestFocus();
            Get.snackbar("Alert", "Lokasi Google harus di isi!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

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
                editLokasiGoogle.controller.focusNode.requestFocus();
                Get.snackbar("Alert", "Lokasi Google tidak valid!",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    backgroundColor: Colors.red,
                    colorText: Colors.white
                );

                return ret = [false, ""];
            }
        }
        if(spBranch.controller.textSelected.isEmpty){
            spBranch.controller.showAlert();
            Scrollable.ensureVisible(spBranch.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if(isSalesLead.isTrue){
            if(spinnerPicSales.controller.textSelected.isEmpty){
                spinnerPicSales.controller.showAlert();
                Scrollable.ensureVisible(spinnerPicSales.controller.formKey.currentContext!);
                return ret = [false, ""];
            }
        }

        if (spinnerProvince.controller.textSelected.value.isEmpty) {
            spinnerProvince.controller.showAlert();
            Get.snackbar("Alert", "Province harus di pilih!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

            return ret = [false, ""];
        }
        if (spinnerKota.controller.textSelected.value.isEmpty) {
            spinnerKota.controller.showAlert();
            Get.snackbar("Alert", "Kota harus di pilih!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

            return ret = [false, ""];
        }
        if (spinnerKecamatan.controller.textSelected.value.isEmpty) {
            spinnerKecamatan.controller.showAlert();
            Get.snackbar("Alert", "Kecamatan harus di pilih!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

            return ret = [false, ""];
        }

        if (spinnerSupplier.controller.textSelected.value.isEmpty) {
            spinnerSupplier.controller.showAlert();
            Get.snackbar("Alert", "Supplier harus di pilih!",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white
            );

            return ret = [false, ""];
        }

        ret = skuCard.controller.validation();
        return ret;
    }

    Customer generatePayload() {
        List<Products?> listProductPayload = [];
        var listProductTemp = skuCard.controller.listProduct.value.values.toList();
            for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
                CategoryModel? selectCategory;
                int whichItem = skuCard.controller.index.value[i];
                if (listCategories.value.isNotEmpty) {
                    selectCategory= listCategories.value.firstWhere((element) => element!.name! ==  skuCard.controller.spinnerProduct.value[whichItem].controller.textSelected.value);
                    if(selectCategory == null) {
                        Products? selectTemp = customer.products!.firstWhere((element) => element!.category!.name! == skuCard.controller.spinnerProduct.value[whichItem].controller.textSelected.value );
                        selectCategory = selectTemp!.category;
                    }
                } else {                    
                    Products? selectTemp = customer.products!.firstWhere((element) => element!.category!.name! == skuCard.controller.spinnerProduct.value[whichItem].controller.textSelected.value );
                    selectCategory = selectTemp!.category; 
                }

                Products? selectProduct;
                if(skuCard.controller.listProduct.value.isNotEmpty){
                    for(int j =0 ; j < listProductTemp.length; j++){
                        selectProduct = listProductTemp[j].firstWhere((element) => element!.name! == skuCard.controller.spinnerSize.value[whichItem].controller.textSelected.value,orElse: ()=> null );
                    }
                    selectProduct ??= customer.products!.firstWhere((element) => element!.name == skuCard.controller.spinnerSize.value[whichItem].controller.textSelected.value );
                } else {
                    selectProduct = customer.products!.firstWhere((element) => element!.name == skuCard.controller.spinnerSize.value[whichItem].controller.textSelected.value );
                }

                selectProduct?.category = selectCategory;
                selectProduct?.dailyQuantity =skuCard.controller.editFieldJenis.value[whichItem].getInputNumber()!.toInt();
                selectProduct?.price = skuCard.controller.editFieldHarga.value[whichItem].getInputNumber();
                listProductPayload.add(selectProduct);
            }

        Location? provinceSelect;
        Branch? branchSelected = listBranch.value.firstWhere((element) => element!.name == spBranch.controller.textSelected.value);


        if (customer.province!.name != spinnerProvince.controller.textSelected.value) {
            provinceSelect = province.value.firstWhere((element) =>
                element!.provinceName ==
                spinnerProvince.controller.textSelected.value,
            );
        }

        Location? citySelect;
        if (customer.city!.name != spinnerKota.controller.textSelected.value) {
            citySelect = city.value.firstWhere((element) =>
                element!.cityName == spinnerKota.controller.textSelected.value,
            );
        }

        Location? districSelect;
        if (customer.district!.name != spinnerKecamatan.controller.textSelected.value) {
            districSelect = district.value.firstWhere((element) =>
                element!.districtName ==
                spinnerKecamatan.controller.textSelected.value,
            );
        }

        SalesPerson? salesSelect = listSalesperson.value.firstWhere((element) =>
            element!.email == spinnerPicSales.controller.textSelected.value,
        );

        return Customer(
            businessName: editNamaBisnis.getInput(),
            businessType: spinnerTipeBisnis.controller.textSelected.value,
            ownerName: editNamaPemilik.getInput(),
            phoneNumber: editNomorTelepon.getInput(),
            salespersonId: salesSelect != null ? salesSelect.id : customer.salesperson!.id,
            plusCode: editLokasiGoogle.getInput(),
            branchId: branchSelected != null ? branchSelected.id : customer.branch!.id,
            provinceId: provinceSelect != null ? provinceSelect.id! : customer.province!.id,
            cityId: citySelect != null ? citySelect.id! : customer.city!.id,
            districtId: districSelect != null ? districSelect.id! : customer.district!.id,
            supplier: spinnerSupplier.controller.textSelected.value,
            supplierDetail: spinnerSupplier.controller.textSelected.value.isNotEmpty? editNamaSupplier.getInput() : null,
            products: listProductPayload,
            isArchived: customer.isArchived,
        );
    }

    final _getListLocationListener = ResponseListener(
        onResponseDone: (code, message, body, id, packet) {
            if (id == 1) {
                Map<String, bool> mapList = {};
                for (var location in (body as LocationListResponse).data) {
                  mapList[location!.provinceName!] = false;
                }
                (packet[2] as SpinnerSearch).controller.generateItems(mapList);
                packet[0].value = false;
                for (var result in body.data) {
                    (packet[1] as Rx<List<Location?>>).value.add(result);
                }
            }

            if (id == 2) {
                Map<String, bool> mapList = {};
                for (var location in (body as LocationListResponse).data) {
                  mapList[location!.cityName!] = false;
                }
                (packet[2] as SpinnerSearch).controller.generateItems(mapList);
                (packet[2] as SpinnerSearch).controller.enable();
                packet[0].value = false;
                for (var result in body.data) {
                    (packet[1] as Rx<List<Location?>>).value.add(result);
                }
            }

            if (id == 3) {
                Map<String, bool> mapList = {};
                for (var location in (body as LocationListResponse).data) {
                  mapList[location!.districtName!] = false;
                }
                (packet[2] as SpinnerSearch).controller.generateItems(mapList);

                (packet[2] as SpinnerSearch).controller.enable();
                packet[0].value = false;
                for (var result in body.data) {
                    (packet[1] as Rx<List<Location?>>).value.add(result);
                }
            }
        },
        onResponseFail: (code, message, body, id, packet) {
            packet[0].value = false;
            Get.snackbar("Alert", (body as ErrorResponse).error!.message!,
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white);
        },
        onResponseError: (exception, stacktrace, id, packet) {
            packet[0].value = false;
            Get.snackbar("Alert","Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white);
        },
        onTokenInvalid: Constant.invalidResponse()
    );

    void getSalesList(){
        AuthImpl().get().then((auth) => {
            if (auth != null){
                spinnerPicSales.controller.showLoading(),
                Service.push(
                    apiKey: "api",
                    service: ListApi.getSalesList,
                    context: context,
                    body: [
                        'Bearer ${auth.token}',
                        auth.id,
                        Constant.xAppId!,
                        "sales",
                        1,
                        0
                    ],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            for (var result in (body as SalespersonListResponse).data) {
                                listSalesperson.value.add(result);
                            }

                            Map<String, bool> mapList = {};
                            for (var product in body.data) {
                            mapList[product!.email!] = false;
                            }
                            spinnerPicSales.controller.generateItems(mapList);
                            spinnerPicSales.controller.enable();
                            spinnerPicSales.controller.hideLoading();
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                            spinnerPicSales.controller.hideLoading();
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                            spinnerPicSales.controller.hideLoading();
                        },
                            onTokenInvalid: () => Constant.invalidResponse()))
                    }
            else
                {Constant.invalidResponse()}
        });
    }
}

class EditDataBindings extends Bindings {
    BuildContext context;
    EditDataBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => EditDataController(context: context));
    }
}
