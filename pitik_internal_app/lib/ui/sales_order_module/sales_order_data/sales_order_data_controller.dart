///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/place_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/location_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:model/response/internal_app/salesperson_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/so_status.dart';
import 'package:pitik_internal_app/utils/route.dart';

enum BodyQuerySales {
  token,
  auth,
  xAppId,
  page,
  limit,
  customerId,
  salesPersonId,
  driverId,
  status,
  code,
  sameBranch,
  withinProductionTeam,
  customerCityId,
  customerProvinceId,
  customerName,
  date,
  minQuantityRange,
  maxRangeQuantity,
  createdBy,
  category,
  withSalesTeam,
  operationUnitId,
  productItemId,
  productCategoryId,
  status1,
  status2,
  status3,
  status4,
  status5,
  status6,
  status7,
  status8,
  status9,
}

class SalesOrderController extends GetxController with GetSingleTickerProviderStateMixin {
  BuildContext context;
  SalesOrderController({required this.context});
  TextEditingController searchController = TextEditingController();

  RxList<Order?> orderListOutbound = RxList<Order?>([]);
  RxList<Order?> orderListInbound = RxList<Order?>([]);
  RxList<SalesPerson?> listSalesperson = RxList<SalesPerson>([]);
  RxList<Location?> province = RxList<Location>([]);
  RxList<Location?> city = RxList<Location>([]);
  RxList<OperationUnitModel?> listOperationUnits = RxList<OperationUnitModel>([]);
  RxList<CategoryModel?> listCategory = RxList<CategoryModel>([]);
  RxList<Products?> listProduct = RxList<Products>([]);

  RxList<dynamic> bodyGeneralOutbound = RxList<dynamic>(List.generate(BodyQuerySales.values.length, (index) => null));
  RxList<dynamic> bodyGeneralInbound = RxList<dynamic>(List.generate(BodyQuerySales.values.length, (index) => null));

  FocusNode focusNode = FocusNode();
  late TabController tabController;
  RxInt page = 1.obs;
  RxInt limit = 10.obs;
  RxInt pageOutbound = 1.obs;
  RxInt pageInbound = 1.obs;
  RxBool isLoadingOutbond = false.obs;
  RxBool isLoadingInbound = false.obs;
  RxBool isLoadMore = false.obs;
  RxBool isLoading = false.obs;
  RxBool isFilter = false.obs;
  RxBool isSearch = false.obs;
  RxString searchValue = "".obs;
  RxBool isLoadData = false.obs;
  RxString selectedValue = "Nomor SO".obs;
  RxBool isShowList = false.obs;
  RxBool isOutbondTab = true.obs;
  RxInt tabIndex = 0.obs;
  Timer? debounce;
  ScrollController scrollControllerOutbound = ScrollController();
  ScrollController scrollControllerInbound = ScrollController();

  final List<String> items = [
    'Customer',
    'Nomor SO',
  ];
  Rx<Map<String, String>> listFilter = Rx<Map<String, String>>({});

  late ButtonFill btPenjualan = ButtonFill(
      controller: GetXCreator.putButtonFillController("btPenjualan"),
      label: "Buat Penjualan",
      onClick: () {
        // backFromForm(false);
        _showBottomDialog();
      });

  DateTimeField dtTanggalPenjualan = DateTimeField(
      controller: GetXCreator.putDateTimeFieldController("dtTanggalPenjualan"),
      label: "Tanggal Penjualan",
      hint: "dd MM yyyy",
      alertText: "",
      flag: 1,
      onDateTimeSelected: (date, dateField) {
        dateField.controller.setTextSelected(DateFormat("dd MMM yyyy", 'id').format(date));
      });

  SpinnerSearch spCreatedBy = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController("spCreatedBy"), label: "Dibuat Oleh", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});
  late SpinnerSearch spProvince = SpinnerSearch(
      controller: GetXCreator.putSpinnerSearchController("spProvince"),
      label: "Provinsi Customer",
      hint: "Pilih Salah Satu",
      alertText: "",
      items: const {},
      onSpinnerSelected: (value) {
        spCity.controller.setTextSelected("");
        spCity.controller.disable();
        if (province.isNotEmpty) {
          Location? selectLocation = province.firstWhereOrNull((element) => element!.provinceName! == value);
          if (selectLocation != null) {
            getCity(selectLocation);
          }
        }
      });
  SpinnerSearch spCity = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController("spCity"), label: "Kota Customer", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});
  late EditField efMin = EditField(
      controller: GetXCreator.putEditFieldController("efMin"),
      label: "Rentang Min",
      hint: "Ketik Disini",
      alertText: "Min Max harus diiisi",
      inputType: TextInputType.number,
      textUnit: "Ekor",
      maxInput: 20,
      onTyping: (value, editField) {
        efMax.controller.hideAlert();
      });
  late EditField efMax = EditField(
      controller: GetXCreator.putEditFieldController("efMax"),
      label: "Rentang Max",
      hint: "Ketik Disini",
      alertText: "Min Max harus diisi",
      inputType: TextInputType.number,
      textUnit: "Ekor",
      maxInput: 20,
      onTyping: (value, editField) {
        efMin.controller.hideAlert();
      });
  SpinnerField spStatus = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("spStatusFilter"),
      label: "Status",
      hint: "Pilih Salah Satu",
      alertText: "",
      items: const {
        "Draft": false,
        "Terkonfirmasi": false,
        "Teralokasi": false,
        "Dipesan": false,
        "Siap Dikirim": false,
        "Perjalanan": false,
        "Terkirim": false,
        "Ditolak": false,
        "Batal": false,
      },
      onSpinnerSelected: (value) {});

  late SpinnerSearch spSource = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController("spSource"), label: "Sumber", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});
  late SpinnerField spCategory = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("spCategoryFilter"),
      label: "Kategori SKU",
      hint: "Pilih Salah Satu",
      alertText: "",
      items: const {},
      onSpinnerSelected: (value) {
        if (listCategory.isNotEmpty) {
          CategoryModel? selectCategory = listCategory.firstWhereOrNull((element) => element!.name! == value);
          if (selectCategory != null) {
            getSku(selectCategory.id!);
          }
        }
      });
  SpinnerField spSku = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spSkuFilter"), label: "SKU", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});

  late ButtonFill btKormasiFilter = ButtonFill(controller: GetXCreator.putButtonFillController("btKormasiFilter"), label: "Konfirmasi Filter", onClick: () => saveFilter());

  late ButtonOutline btBersihkanFilter = ButtonOutline(controller: GetXCreator.putButtonOutlineController("btBersihkanFilter"), label: "Bersihkan Filter", onClick: () => clearFilter());

  late Obx searchBar = Obx(() => TextField(
        controller: searchController,
        focusNode: focusNode,
        onChanged: (text) => searchOrder(text),
        cursorColor: AppColors.primaryOrange,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFFF9ED),
          //   isDense: true,
          contentPadding: const EdgeInsets.only(left: 4.0),
          hintText: "Cari ${selectedValue.value}",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: SvgPicture.asset("images/search_icon.svg"),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  const SizedBox(height: 1),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      customButton: Container(
                        padding: const EdgeInsets.only(top: 10),
                        height: 32,
                        width: 90,
                        child: Obx(() => Row(
                              children: [
                                Text(
                                  "$selectedValue",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                isShowList.isTrue ? SvgPicture.asset("images/arrow_up.svg") : SvgPicture.asset("images/arrow_down.svg")
                              ],
                            )),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(item, style: AppTextStyle.subTextStyle.copyWith(fontSize: 14)),
                              ))
                          .toList(),
                      value: selectedValue.value,
                      onChanged: (String? value) {
                        selectedValue.value = value ?? "Customer";
                      },
                      onMenuStateChange: (isOpen) {
                        isShowList.value = isOpen;
                      },
                      dropdownStyleData: const DropdownStyleData(
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(width: 1.0, color: AppColors.primaryOrange)),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(width: 1.0, color: AppColors.primaryOrange)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(width: 1.0, color: AppColors.primaryOrange)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(width: 1.0, color: AppColors.primaryOrange)),
        ),
      ));

  RxMap<String, bool> mapStatusOutbond = RxMap<String, bool>({
    "Draft": false,
    "Terkonfirmasi": false,
    "Teralokasi": false,
    "Dipesan": false,
    "Siap Dikirim": false,
    "Perjalanan": false,
    "Terkirim": false,
    "Ditolak": false,
    "Batal": false,
  });

  RxMap<String, bool> mapStatusInbound = RxMap<String, bool>({
    "Draft": false,
    "Terkonfirmasi": false,
    "Terkirim": false,
    "Batal": false,
  });

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting();
    tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        tabIndex.value = tabController.index;
      });
    scrollListenerOutbound();
    scrollListenerInbound();
  }

  @override
  void onReady() {
    super.onReady();
    isLoadingOutbond.value = true;
    tabIndex.listen((value) {
      tabControllerListener(value);
    });
    getListOutboundGeneral();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    scrollControllerOutbound.dispose();
    scrollControllerInbound.dispose();
  }

  tabControllerListener(int tab) {
    if (tab == 0) {
      searchController.clear();
      isSearch.value = false;
      isFilter.value = false;
      listFilter.value.clear();
      focusNode.unfocus();
      isOutbondTab.value = true;
      orderListOutbound.clear();
      pageOutbound.value = 1;
      isLoadingOutbond.value = true;
      getListOutboundGeneral();
    } else {
      searchController.clear();
      isSearch.value = false;
      isFilter.value = false;
      listFilter.value.clear();
      focusNode.unfocus();
      isOutbondTab.value = false;
      orderListInbound.clear();
      pageInbound.value = 1;
      isLoadingInbound.value = true;
      getListInboundGeneral();
    }
  }

  scrollListenerOutbound() async {
    scrollControllerOutbound.addListener(() {
      if (scrollControllerOutbound.position.maxScrollExtent == scrollControllerOutbound.position.pixels) {
        isLoadMore.value = true;
        pageOutbound++;
        if (isSearch.isTrue) {
          searchOrderOutbound();
        } else if (isFilter.isTrue) {
          getFilterOutbound();
        } else {
          getListOutboundGeneral();
        }
      }
    });
  }

  scrollListenerInbound() async {
    scrollControllerInbound.addListener(() {
      if (scrollControllerInbound.position.maxScrollExtent == scrollControllerInbound.position.pixels) {
        isLoadMore.value = true;
        pageInbound++;
        if (isSearch.isTrue) {
          searchOrderInbound();
        } else if (isFilter.isTrue) {
          getFilterInbound();
        } else {
          getListInboundGeneral();
        }
      }
    });
  }

  void fetchOrder(List<dynamic> body, ResponseListener listener) {
    Service.push(service: ListApi.getListOrdersFilter, context: context, body: body, listener: listener);
  }

  void setValueBody(BodyQuerySales index, dynamic value, List<dynamic> bodyGeneral) {
    bodyGeneral[index.index] = value;
  }

  void resetAllBodyValue(List<dynamic> bodyGeneral) {
    for (int i = 0; i < bodyGeneral.length; i++) {
      bodyGeneral[i] = null;
    }
    bodyGeneral[BodyQuerySales.token.index] = Constant.auth!.token;
    bodyGeneral[BodyQuerySales.auth.index] = Constant.auth!.id;
    bodyGeneral[BodyQuerySales.xAppId.index] = Constant.xAppId;
  }

  void setGeneralheader(int page, int limit, String category, List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.page.index] = page;
    bodyGeneral[BodyQuerySales.limit.index] = limit;
    bodyGeneral[BodyQuerySales.category.index] = category;
  }

  void getListOutboundGeneral() {
    resetAllBodyValue(bodyGeneralOutbound);
    setGeneralheader(pageOutbound.value, limit.value, EnumSO.outbound, bodyGeneralOutbound);
    if (Constant.isSales.isTrue) {
      salesBodyGeneralOutbound(bodyGeneralOutbound);
    } else if (Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue) {
      shopkeeperBodyGeneralOutbound(bodyGeneralOutbound);
    } else if (Constant.isSalesLead.isTrue) {
      salesLeadBodyGeneralOutbound(bodyGeneralOutbound);
    }
    if (Constant.isScRelation.isTrue) {
      scRelationdBodyGeneralOutbound(bodyGeneralOutbound);
    }
    fetchOrder(bodyGeneralOutbound, responOutbound());
  }

  void shopkeeperBodyGeneralOutbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.withinProductionTeam.index] = "true";
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.readyToDeliver;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.status6.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status7.index] = EnumSO.rejected;
    bodyGeneral[BodyQuerySales.status8.index] = EnumSO.onDelivery;
    bodyGeneral[BodyQuerySales.status9.index] = EnumSO.allocated;
  }

  void salesBodyGeneralOutbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.salesPersonId.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.readyToDeliver;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.status6.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status7.index] = EnumSO.rejected;
    bodyGeneral[BodyQuerySales.status8.index] = EnumSO.onDelivery;
    bodyGeneral[BodyQuerySales.status9.index] = EnumSO.allocated;
  }

  void salesLeadBodyGeneralOutbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.withSalesTeam.index] = "true";
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.readyToDeliver;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.status6.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status7.index] = EnumSO.rejected;
    bodyGeneral[BodyQuerySales.status8.index] = EnumSO.onDelivery;
    bodyGeneral[BodyQuerySales.status9.index] = EnumSO.allocated;
  }

  void scRelationdBodyGeneralOutbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status9.index] = EnumSO.allocated;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
  }

  ResponseListener responOutbound() {
    return ResponseListener(
        onResponseDone: (code, message, body, id, packet) {
          if ((body as SalesOrderListResponse).data.isNotEmpty) {
            for (var result in body.data) {
              orderListOutbound.add(result as Order);
            }
            if (isLoadMore.isTrue) {
              isLoadingOutbond.value = false;
              isLoadMore.value = false;
              isLoadData.value = false;
            } else {
              isLoadingOutbond.value = false;
              isLoadData.value = false;
            }
          } else {
            if (isLoadMore.isTrue) {
              page.value = (orderListOutbound.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
              isLoadingOutbond.value = false;
              isLoadData.value = false;
            } else {
              isLoadingOutbond.value = false;
              isLoadData.value = false;
            }
          }
        },
        onResponseFail: (code, message, body, id, packet) {
          onResponseFail(body, isLoadingOutbond);
        },
        onResponseError: (exception, stacktrace, id, packet) {
          onResponseError(isLoadingOutbond);
        },
        onTokenInvalid: Constant.invalidResponse());
  }

  void getListInboundGeneral() {
    resetAllBodyValue(bodyGeneralInbound);
    setGeneralheader(pageInbound.value, limit.value, EnumSO.inbound, bodyGeneralInbound);
    if (Constant.isSales.isTrue) {
      salesBodyGeneralInbound(bodyGeneralInbound);
    } else if (Constant.isShopKepper.isTrue) {
      shopkeeperBodyGeneralInbound(bodyGeneralInbound);
    } else if (Constant.isOpsLead.isTrue) {
      opsLeadBodyGeneralInbound(bodyGeneralInbound);
    } else if (Constant.isSalesLead.isTrue) {
      salesLeadBodyGeneralInbound(bodyGeneralInbound);
    }
    fetchOrder(bodyGeneralInbound, responInbound());
  }

  void salesBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
  }

  void shopkeeperBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.withinProductionTeam.index] = "true";
  }

  void opsLeadBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.withinProductionTeam.index] = "true";
  }

  void salesLeadBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.withSalesTeam.index] = "true";
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
  }

  ResponseListener responInbound() {
    return ResponseListener(
        onResponseDone: (code, message, body, id, packet) {
          if ((body as SalesOrderListResponse).data.isNotEmpty) {
            for (var result in body.data) {
              orderListInbound.add(result as Order);
            }
            if (isLoadMore.isTrue) {
              isLoadingInbound.value = false;
              isLoadMore.value = false;
              isLoadData.value = false;
            } else {
              isLoadingInbound.value = false;
              isLoadData.value = false;
            }
          } else {
            if (isLoadMore.isTrue) {
              page.value = (orderListInbound.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
              isLoadingInbound.value = false;
              isLoadData.value = false;
            } else {
              isLoadingInbound.value = false;
              isLoadData.value = false;
            }
          }
        },
        onResponseFail: (code, message, body, id, packet) {
          onResponseFail(body, isLoadingInbound);
        },
        onResponseError: (exception, stacktrace, id, packet) {
          onResponseError(isLoadingInbound);
        },
        onTokenInvalid: Constant.invalidResponse());
  }

  void onResponseFail(dynamic body, RxBool loading) {
    loading.value = false;
    Get.snackbar(
      "Pesan",
      "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }

  void onResponseError(RxBool loading) {
    Get.snackbar(
      "Pesan",
      "Terjadi kesalahan internal",
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
    loading.value = false;
  }

  void searchOrder(String text) {
    if (text.isNotEmpty) {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        isSearch.value = true;
        isFilter.value = false;
        listFilter.value.clear();
        if (isOutbondTab.isTrue) {
          orderListOutbound.clear();
          pageOutbound.value = 1;
          isLoadData.value = true;
          searchValue.value = text;
          searchOrderOutbound();
        } else {
          orderListInbound.clear();
          pageInbound.value = 1;
          isLoadData.value = true;
          searchValue.value = text;
          searchOrderInbound();
        }
      });
    } else {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        isSearch.value = false;
        if (isOutbondTab.isFalse) {
          orderListInbound.clear();
          pageInbound.value = 1;
          isLoadData.value = true;
          getListInboundGeneral();
        } else {
          orderListOutbound.clear();
          pageOutbound.value = 1;
          isLoadData.value = true;
          getListOutboundGeneral();
        }
      });
    }
  }

  void searchOrderOutbound() {
    resetAllBodyValue(bodyGeneralOutbound);
    setGeneralheader(pageOutbound.value, limit.value, EnumSO.outbound, bodyGeneralOutbound);
    if (Constant.isSales.isTrue) {
      salesBodyGeneralOutbound(bodyGeneralOutbound);
    } else if (Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue) {
      shopkeeperBodyGeneralOutbound(bodyGeneralOutbound);
    } else if (Constant.isSalesLead.isTrue) {
      salesLeadBodyGeneralOutbound(bodyGeneralOutbound);
    }
    if (Constant.isScRelation.isTrue) {
      scRelationdBodyGeneralOutbound(bodyGeneralOutbound);
    }
    if (selectedValue.value == "Customer") {
      bodyGeneralOutbound[BodyQuerySales.customerName.index] = searchValue.value;
    } else {
      bodyGeneralOutbound[BodyQuerySales.code.index] = searchValue.value;
    }

    fetchOrder(bodyGeneralOutbound, responOutbound());
  }

  void searchOrderInbound() {
    resetAllBodyValue(bodyGeneralInbound);
    setGeneralheader(pageInbound.value, limit.value, EnumSO.inbound, bodyGeneralInbound);
    if (Constant.isSales.isTrue) {
      salesBodyGeneralInbound(bodyGeneralInbound);
    } else if (Constant.isShopKepper.isTrue) {
      shopkeeperBodyGeneralInbound(bodyGeneralInbound);
    } else if (Constant.isOpsLead.isTrue) {
      opsLeadBodyGeneralInbound(bodyGeneralInbound);
    } else if (Constant.isSalesLead.isTrue) {
      salesLeadBodyGeneralInbound(bodyGeneralInbound);
    }
    if (selectedValue.value == "Customer") {
      bodyGeneralInbound[BodyQuerySales.customerName.index] = searchValue.value;
    } else {
      bodyGeneralInbound[BodyQuerySales.code.index] = searchValue.value;
    }

    fetchOrder(bodyGeneralInbound, responInbound());
  }

  void backFromForm(bool isInbound) {
    Get.back();
    Get.toNamed(RoutePage.newDataSalesOrder, arguments: isInbound)!.then((value) {
      if (isFilter.isTrue) {
        if (isOutbondTab.isFalse) {
          orderListInbound.clear();
          pageInbound.value = 1;
          isLoadData.value = true;
          getFilterInbound();
        } else {
          orderListOutbound.clear();
          pageOutbound.value = 1;
          isLoadData.value = true;
          getFilterOutbound();
        }
      } else if (isSearch.isTrue) {
        if (isOutbondTab.isFalse) {
          orderListInbound.clear();
          pageInbound.value = 1;
          isLoadData.value = true;
          searchOrderInbound();
        } else {
          orderListOutbound.clear();
          pageOutbound.value = 1;
          isLoadData.value = true;
          searchOrderOutbound();
        }
      } else {
        if (isInbound) {
          if (tabController.index == 0) {
            tabController.index = 1;
            isOutbondTab.value = false;
            isLoadData.value = true;
          } else {
            isLoadData.value = true;
            isOutbondTab.value = false;
            orderListInbound.clear();
            pageInbound.value = 1;
            isLoadingInbound.value = true;
            getListInboundGeneral();
          }
        } else {
          if (tabController.index == 1) {
            tabController.index = 0;
            isOutbondTab.value = true;
            isLoadData.value = true;
          } else {
            isLoadData.value = true;
            isOutbondTab.value = true;
            orderListOutbound.clear();
            pageOutbound.value = 1;
            isLoadingOutbond.value = true;
            getListOutboundGeneral();
          }
        }
      }
    });
  }

  void openFilter() {
    if (spCity.controller.textSelected.isEmpty) {
      spCity.controller.disable();
    }
    if (spSku.controller.textSelected.isEmpty) {
      spSku.controller.disable();
    }
    getSalesList();
    getProvince();
    getCategorySku();
    getListSource();
    showFilter();
  }

  void saveFilter() {
    if (validationFilter()) {
      searchController.clear();
      listFilter.value.clear();
      if (dtTanggalPenjualan.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Tanggal Penjualan"] = dtTanggalPenjualan.controller.textSelected.value;
      }
      if (spCreatedBy.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Dibuat Oleh"] = spCreatedBy.controller.textSelected.value;
      }
      if (spProvince.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Province"] = spProvince.controller.textSelected.value;
      }
      if (spCity.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Kota"] = spCity.controller.textSelected.value;
      }
      if (efMin.getInput().isNotEmpty) {
        listFilter.value["Rentang Min"] = efMin.getInput();
      }
      if (efMax.getInput().isNotEmpty) {
        listFilter.value["Rentang Max"] = efMax.getInput();
      }
      if (spStatus.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Status"] = spStatus.controller.textSelected.value;
      }
      if (spCategory.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Kategori"] = spCategory.controller.textSelected.value;
      }
      if (spSku.controller.textSelected.value.isNotEmpty) {
        listFilter.value["SKU"] = spSku.controller.textSelected.value;
      }
      if (spSource.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Sumber"] = spSource.controller.textSelected.value;
      }
      listFilter.refresh();
      Get.back();
      isFilter.value = true;
      isSearch.value = false;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getFilterInbound();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getFilterOutbound();
      }
    } else {
      if (efMax.getInput().isEmpty && efMin.getInput().isEmpty) {
        Get.back();
        isFilter.value = false;
        isFilter.value = false;
        if (isOutbondTab.isFalse) {
          orderListInbound.clear();
          pageInbound.value = 1;
          isLoadData.value = true;
          getListInboundGeneral();
        } else {
          orderListOutbound.clear();
          pageOutbound.value = 1;
          isLoadData.value = true;
          getListOutboundGeneral();
        }
      }
    }
  }

  void getFilterOutbound() {
    Location? provinceSelect;

    if (spProvince.controller.textSelected.value.isNotEmpty) {
      provinceSelect = province.firstWhereOrNull(
        (element) => element!.provinceName == spProvince.controller.textSelected.value,
      );
    }

    Location? citySelect;
    if (spCity.controller.textSelected.value.isNotEmpty) {
      citySelect = city.firstWhereOrNull(
        (element) => element!.cityName == spCity.controller.textSelected.value,
      );
    }

    SalesPerson? salesSelect;
    if (spCreatedBy.controller.textSelected.value.isNotEmpty) {
      salesSelect = listSalesperson.firstWhereOrNull(
        (element) => element!.email == spCreatedBy.controller.textSelected.value,
      );
    }

    CategoryModel? categorySelect;
    if (spCategory.controller.textSelected.value.isNotEmpty) {
      categorySelect = listCategory.firstWhereOrNull(
        (element) => element!.name == spCategory.controller.textSelected.value,
      );
    }

    Products? productSelect;
    if (spSku.controller.textSelected.value.isNotEmpty) {
      productSelect = listProduct.firstWhereOrNull(
        (element) => element!.name == spSku.controller.textSelected.value,
      );
    }

    OperationUnitModel? operationUnitSelect;
    if (spSource.controller.textSelected.value.isNotEmpty) {
      operationUnitSelect = listOperationUnits.firstWhere(
        (element) => element!.operationUnitName == spSource.controller.textSelected.value,
      );
    }

    String? status;
    switch (spStatus.controller.textSelected.value) {
      case "Draft":
        status = "DRAFT";
        break;
      case "Terkonfirmasi":
        status = "CONFIRMED";
        break;
      case "Teralokasi":
        status = "ALLOCATED";
        break;
      case "Dipesan":
        status = "BOOKED";
        break;
      case "Siap Dikirim":
        status = "READY_TO_DELIVER";
        break;
      case "Perjalanan":
        status = "ON_DELIVERY";
        break;
      case "Terkirim":
        status = "DELIVERED";
        break;
      case "Ditolak":
        status = "REJECTED";
        break;
      case "Batal":
        status = "CANCELLED";
        break;
      default:
    }
    String? date = dtTanggalPenjualan.controller.textSelected.value.isEmpty ? null : DateFormat("yyyy-MM-dd").format(dtTanggalPenjualan.getLastTimeSelected());
    resetAllBodyValue(bodyGeneralOutbound);
    setGeneralheader(pageOutbound.value, limit.value, EnumSO.outbound, bodyGeneralOutbound);
    if (Constant.isSales.isTrue) {
      if (status == null) {
        salesBodyGeneralOutbound(bodyGeneralOutbound);
      } else {
        bodyGeneralOutbound[BodyQuerySales.salesPersonId.index] = Constant.profileUser?.id;
      }
    } else if ((Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue)) {
      if (status == null) {
        shopkeeperBodyGeneralOutbound(bodyGeneralOutbound);
      }
      bodyGeneralOutbound[BodyQuerySales.withinProductionTeam.index] = "true";
    } else if (Constant.isSalesLead.isTrue) {
      if (status == null) {
        salesLeadBodyGeneralOutbound(bodyGeneralOutbound);
      }
      bodyGeneralOutbound[BodyQuerySales.withSalesTeam.index] = "true";
    }
    if (Constant.isScRelation.isTrue) {
      if (status == null) {
        scRelationdBodyGeneralOutbound(bodyGeneralOutbound);
      }
    }
    bodyGeneralOutbound[BodyQuerySales.status.index] = status; // status
    bodyGeneralOutbound[BodyQuerySales.customerCityId.index] = citySelect?.id; // customerCityId
    bodyGeneralOutbound[BodyQuerySales.customerProvinceId.index] = provinceSelect?.id; // customerProvinceId
    bodyGeneralOutbound[BodyQuerySales.date.index] = date; // date
    bodyGeneralOutbound[BodyQuerySales.operationUnitId.index] = operationUnitSelect?.id; // operationUnitId
    bodyGeneralOutbound[BodyQuerySales.productCategoryId.index] = categorySelect?.id; // categoryId
    bodyGeneralOutbound[BodyQuerySales.productItemId.index] = productSelect?.id; // productId
    bodyGeneralOutbound[BodyQuerySales.minQuantityRange.index] = efMin.getInputNumber() != null ? (efMin.getInputNumber() ?? 0).toInt() : null; // minQuantityRange
    bodyGeneralOutbound[BodyQuerySales.maxRangeQuantity.index] = efMax.getInputNumber() != null ? (efMax.getInputNumber() ?? 0).toInt() : null; // maxRangeQuantity
    bodyGeneralOutbound[BodyQuerySales.createdBy.index] = salesSelect?.id; // createdBy
    fetchOrder(bodyGeneralOutbound, responOutbound());
  }

  void getFilterInbound() {
    Location? provinceSelect;

    if (spProvince.controller.textSelected.value.isNotEmpty) {
      provinceSelect = province.firstWhereOrNull(
        (element) => element!.provinceName == spProvince.controller.textSelected.value,
      );
    }

    Location? citySelect;
    if (spCity.controller.textSelected.value.isNotEmpty) {
      citySelect = city.firstWhereOrNull(
        (element) => element!.cityName == spCity.controller.textSelected.value,
      );
    }

    SalesPerson? salesSelect;
    if (spCreatedBy.controller.textSelected.value.isNotEmpty) {
      salesSelect = listSalesperson.firstWhereOrNull(
        (element) => element!.email == spCreatedBy.controller.textSelected.value,
      );
    }

    CategoryModel? categorySelect;
    if (spCategory.controller.textSelected.value.isNotEmpty) {
      categorySelect = listCategory.firstWhereOrNull(
        (element) => element!.name == spCategory.controller.textSelected.value,
      );
    }

    Products? productSelect;
    if (spSku.controller.textSelected.value.isNotEmpty) {
      productSelect = listProduct.firstWhereOrNull(
        (element) => element!.name == spSku.controller.textSelected.value,
      );
    }

    OperationUnitModel? operationUnitSelect;
    if (spSource.controller.textSelected.value.isNotEmpty) {
      operationUnitSelect = listOperationUnits.firstWhere(
        (element) => element!.operationUnitName == spSource.controller.textSelected.value,
      );
    }

    String? status;
    switch (spStatus.controller.textSelected.value) {
      case "Draft":
        status = "DRAFT";
        break;
      case "Terkonfirmasi":
        status = "CONFIRMED";
        break;
      case "Teralokasi":
        status = "ALLOCATED";
        break;
      case "Dipesan":
        status = "BOOKED";
        break;
      case "Siap Dikirim":
        status = "READY_TO_DELIVER";
        break;
      case "Perjalanan":
        status = "ON_DELIVERY";
        break;
      case "Terkirim":
        status = "DELIVERED";
        break;
      case "Ditolak":
        status = "REJECTED";
        break;
      case "Batal":
        status = "CANCELLED";
        break;
      default:
    }
    String? date = dtTanggalPenjualan.controller.textSelected.value.isEmpty ? null : DateFormat("yyyy-MM-dd").format(dtTanggalPenjualan.getLastTimeSelected());
    resetAllBodyValue(bodyGeneralInbound);
    setGeneralheader(pageInbound.value, limit.value, EnumSO.inbound, bodyGeneralInbound);
    if (Constant.isSales.isTrue) {
      if (status == null) {
        salesBodyGeneralInbound(bodyGeneralInbound);
      } else {
        bodyGeneralInbound[BodyQuerySales.salesPersonId.index] = Constant.profileUser?.id;
      }
    } else if (Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue) {
      if (status == null) {
        shopkeeperBodyGeneralInbound(bodyGeneralInbound);
      }
      bodyGeneralInbound[BodyQuerySales.withinProductionTeam.index] = "true";
    } else if (Constant.isSalesLead.isTrue) {
      if (status == null) {
        salesLeadBodyGeneralInbound(bodyGeneralInbound);
      } else {
        bodyGeneralInbound[BodyQuerySales.withSalesTeam.index] = "true";
      }
    }
    bodyGeneralInbound[BodyQuerySales.status.index] = status; // status
    bodyGeneralInbound[BodyQuerySales.customerCityId.index] = citySelect?.id; // customerCityId
    bodyGeneralInbound[BodyQuerySales.customerProvinceId.index] = provinceSelect?.id; // customerProvinceId
    bodyGeneralInbound[BodyQuerySales.date.index] = date; // date
    bodyGeneralInbound[BodyQuerySales.operationUnitId.index] = operationUnitSelect?.id; // operationUnitId
    bodyGeneralInbound[BodyQuerySales.productCategoryId.index] = categorySelect?.id; // categoryId
    bodyGeneralInbound[BodyQuerySales.productItemId.index] = productSelect?.id; // productId
    bodyGeneralInbound[BodyQuerySales.minQuantityRange.index] = efMin.getInputNumber() != null ? (efMin.getInputNumber() ?? 0).toInt() : null; // minQuantityRange
    bodyGeneralInbound[BodyQuerySales.maxRangeQuantity.index] = efMax.getInputNumber() != null ? (efMax.getInputNumber() ?? 0).toInt() : null; // maxRangeQuantity
    bodyGeneralInbound[BodyQuerySales.createdBy.index] = salesSelect?.id; //createdBy
    fetchOrder(bodyGeneralInbound, responInbound());
  }

  bool validationFilter() {
    if (efMax.getInput().isNotEmpty) {
      if (efMin.getInput().isEmpty) {
        efMin.controller.showAlert();
        efMax.controller.showAlert();
        return false;
      }
    } else if (efMin.getInput().isNotEmpty) {
      if (efMax.getInput().isEmpty) {
        efMax.controller.showAlert();
        efMin.controller.showAlert();
        return false;
      }
    } else if (efMax.getInput().isNotEmpty && efMin.getInput().isNotEmpty) {
      if (efMin.getInputNumber()! > efMax.getInputNumber()!) {
        Get.snackbar(
          "Oops",
          "Rentang Min Harus Lebih Kecil Dari Rentang Max",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        return false;
      }
    }
    return true;
  }

  void clearFilter() {
    dtTanggalPenjualan.controller.setTextSelected("");
    spCreatedBy.controller.setTextSelected("");
    spProvince.controller.setTextSelected("");
    spCity.controller.setTextSelected("");
    spCity.controller.disable();
    efMin.setInput("");
    efMax.setInput("");
    spStatus.controller.setTextSelected("");
    spCategory.controller.setTextSelected("");
    spSku.controller.setTextSelected("");
    spSku.controller.disable();
    spSource.controller.setTextSelected("");
    listFilter.value.clear();
    Get.back();
    if (isOutbondTab.isFalse) {
      orderListInbound.clear();
      pageInbound.value = 1;
      isLoadData.value = true;
      getListInboundGeneral();
    } else {
      orderListOutbound.clear();
      pageOutbound.value = 1;
      isLoadData.value = true;
      getListOutboundGeneral();
    }
  }

  void removeOneFilter(String key) {
    switch (key) {
      case "Tanggal Penjualan":
        dtTanggalPenjualan.controller.setTextSelected("");
        break;
      case "Dibuat Oleh":
        spCreatedBy.controller.setTextSelected("");
        break;
      case "Province":
        spProvince.controller.setTextSelected("");
        break;
      case "Kota":
        spCity.controller.setTextSelected("");
        break;
      case "Rentang Min":
        listFilter.value.remove("Rentang Max");
        efMin.setInput("");
        efMax.setInput("");
        break;
      case "Rentang Max":
        listFilter.value.remove("Rentang Min");
        efMin.setInput("");
        efMax.setInput("");
        break;
      case "Status":
        spStatus.controller.setTextSelected("");
        break;
      case "Kategori":
        spCategory.controller.setTextSelected("");
        spSku.controller.setTextSelected("");
        listFilter.value.remove("SKU");
        break;
      case "SKU":
        spSku.controller.setTextSelected("");
        break;
      case "Sumber":
        spSource.controller.setTextSelected("");
        break;

      default:
    }

    listFilter.value.remove(key);
    listFilter.refresh();
    if (listFilter.value.isEmpty) {
      orderListOutbound.clear();
      page.value = 1;
      isFilter.value = false;
      isSearch.value = false;
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getListInboundGeneral();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getListOutboundGeneral();
      }
    } else {
      page.value = 1;
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getFilterInbound();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getFilterOutbound();
      }
    }
  }

  void pullRefresh() {
    orderListOutbound.clear();
    if (isSearch.isTrue) {
      page.value = 1;
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        searchOrderInbound();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        searchOrderOutbound();
      }
    } else if (isFilter.isTrue) {
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getFilterInbound();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getFilterOutbound();
      }
    } else if (isSearch.isFalse && isFilter.isFalse) {
      page.value = 1;
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getListInboundGeneral();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getListOutboundGeneral();
      }
    }
  }

  void getProvince() {
    spProvince.controller
      ..disable()
      ..showLoading();
    Service.pushWithIdAndPacket(service: ListApi.getProvince, context: context, id: 1, packet: [province, spProvince], body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!], listener: locationListerner());
  }

  void getCity(Location province) {
    spCity.controller
      ..disable()
      ..showLoading();
    Service.pushWithIdAndPacket(service: ListApi.getCity, context: context, id: 2, packet: [city, spCity], body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, province.id], listener: locationListerner());
  }

  ResponseListener locationListerner() {
    return ResponseListener(
        onResponseDone: (code, message, body, id, packet) {
          Map<String, bool> mapList = {};
          for (var location in (body as LocationListResponse).data) {
            if (id == 1) {
              mapList[location!.provinceName!] = false;
            } else {
              mapList[location!.cityName!] = false;
            }
          }
          for (var result in body.data) {
            (packet[0] as RxList<Location?>).add(result);
          }
          (packet[1] as SpinnerSearch).controller
            ..generateItems(mapList)
            ..enable()
            ..hideLoading();
        },
        onResponseFail: (code, message, body, id, packet) {
          (packet[1] as SpinnerSearch).controller
            ..enable()
            ..hideLoading();
          Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
        },
        onResponseError: (exception, stacktrace, id, packet) {
          (packet[1] as SpinnerSearch).controller
            ..enable()
            ..hideLoading();
          Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
        },
        onTokenInvalid: Constant.invalidResponse());
  }

  void getSalesList() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              spCreatedBy.controller
                ..showLoading()
                ..disable(),
              Service.push(
                  apiKey: "api",
                  service: ListApi.getSalesList,
                  context: context,
                  body: ['Bearer ${auth.token}', auth.id, Constant.xAppId!, "sales,sales lead", 1, 0],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        for (var result in (body as SalespersonListResponse).data) {
                          listSalesperson.add(result);
                        }
                        Map<String, bool> mapList = {};
                        for (var product in body.data) {
                          mapList[product!.email!] = false;
                        }
                        spCreatedBy.controller.generateItems(mapList);
                        spCreatedBy.controller.enable();
                        spCreatedBy.controller.hideLoading();
                      },
                      onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        spCreatedBy.controller.hideLoading();
                      },
                      onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan Internal",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        spCreatedBy.controller.hideLoading();
                      },
                      onTokenInvalid: () => Constant.invalidResponse()))
            }
          else
            {Constant.invalidResponse()}
        });
  }

  void getCategorySku() {
    spCategory.controller.disable();
    spCategory.controller.showLoading();
    spCategory.controller.setTextSelected("Loading...");
    Service.push(
      service: ListApi.getCategories,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
      listener: ResponseListener(
          onResponseDone: (code, message, body, id, packet) {
            for (var result in (body as CategoryListResponse).data) {
              listCategory.add(result);
            }
            Map<String, bool> mapList = {};
            for (var product in body.data) {
              mapList[product!.name!] = false;
            }
            spCategory.controller.enable();
            if (listFilter.value["Kategori"] != null) {
              spCategory.controller.setTextSelected(listFilter.value["Kategori"]!);
            } else {
              spCategory.controller.setTextSelected("");
            }
            spCategory.controller.hideLoading();
            spCategory.controller.generateItems(mapList);
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
            spCategory.controller.disable();
            spCategory.controller.setTextSelected("");
            spCategory.controller.hideLoading();
          },
          onResponseError: (exception, stacktrace, id, packet) {
            Get.snackbar(
              "Pesan",
              "Terjadi KesalahanInternal",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
            spCategory.controller.disable();
            spCategory.controller.setTextSelected("");
            spCategory.controller.hideLoading();
          },
          onTokenInvalid: Constant.invalidResponse()),
    );
  }

  void getListSource() {
    spSource.controller
      ..disable()
      ..setTextSelected("Loading...")
      ..showLoading();
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, null, 0],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var units in (body as ListOperationUnitsResponse).data) {
                mapList[units!.operationUnitName!] = false;
              }
              for (var result in body.data) {
                listOperationUnits.add(result);
              }

              spSource.controller
                ..enable()
                ..setTextSelected("")
                ..hideLoading();

              spSource.controller.generateItems(mapList);
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
              spSource.controller
                ..setTextSelected("")
                ..hideLoading();
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
              spSource.controller
                ..setTextSelected("")
                ..hideLoading();
              print(stacktrace);
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getSku(String categoriId) {
    Service.push(
        service: ListApi.getProductById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, categoriId],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ProductListResponse).data[0]!.uom.runtimeType != Null) {
                Map<String, bool> mapList = {};
                for (var product in body.data) {
                  mapList[product!.name!] = false;
                }
                for (var result in (body).data) {
                  listProduct.add(result);
                }
                spSku.controller.generateItems(mapList);
                spSku.controller.enable();
              } else {
                spSku.controller.disable();
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
            },
            onTokenInvalid: () {}));
  }

  showFilter() {
    if (isOutbondTab.isTrue) {
      spStatus.controller.generateItems(mapStatusOutbond);
    } else {
      spStatus.controller.generateItems(mapStatusInbound);
    }
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.90,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outlineColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: RawScrollbar(
                          //   controller: controller.scrollControllerInbound,
                          // thumbVisibility: true,
                          // trackVisibility: true,
                          thumbColor: AppColors.primaryOrange,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                dtTanggalPenjualan,
                                spCreatedBy,
                                spCategory,
                                spSku,
                                spSource,
                                spProvince,
                                spCity,
                                Row(
                                  children: [
                                    Expanded(child: efMin),
                                    const SizedBox(width: 8),
                                    Expanded(child: efMax),
                                  ],
                                ),
                                spStatus,
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: btKormasiFilter),
                        const SizedBox(width: 8),
                        Expanded(child: btBersihkanFilter),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  _showBottomDialog() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => backFromForm(true),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.outlineColor)),
                    child: Row(
                      children: [
                        SvgPicture.asset("images/icon_inbound.svg"),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Penjualan Inbound",
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                              ),
                              const SizedBox(height: 4),
                              Text("Penjualan langsung pada customer tanpa pengantaran", style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10), overflow: TextOverflow.clip),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue ? null : backFromForm(false),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.outlineColor),
                      color: Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue ? const Color(0xFFF0F0F0) : Colors.white,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue ? "images/outbound_off.svg" : "images/icon_outbound.svg",
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Penjualan Outbond",
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Penjualan langsung pada customer dengan pengantaran",
                                style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Constant.bottomSheetMargin),
              ],
            ),
          );
        });
  }
}

class SalesOrderPageBindings extends Bindings {
  BuildContext context;
  SalesOrderPageBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => SalesOrderController(context: context));
  }
}
