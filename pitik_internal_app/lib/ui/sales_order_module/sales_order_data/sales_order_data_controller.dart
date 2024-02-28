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
import 'package:model/branch.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/place_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';
import 'package:model/response/branch_response.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/location_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:model/response/internal_app/salesperson_list_response.dart';
import '../../../api_mapping/api_mapping.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';
import '../../../utils/enum/so_status.dart';
import '../../../utils/route.dart';

part 'sales_order_data_controller.filter.dart';
part 'sales_order_data_controller.inbound.dart';
part 'sales_order_data_controller.outbound.dart';

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
  salesBranch,
  minDeliveryTime,
  maxDeliveryTime,
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
  RxList<Branch?> listBranch = RxList<Branch?>([]);

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
  RxString searchValue = ''.obs;
  RxBool isLoadData = false.obs;
  RxString selectedValue = 'Nomor SO'.obs;
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
      controller: GetXCreator.putButtonFillController('btPenjualan'),
      label: 'Buat Penjualan',
      onClick: () {
        // backFromForm(false);
        _showBottomDialog();
      });

  DateTimeField dtTanggalPenjualan = DateTimeField(
      controller: GetXCreator.putDateTimeFieldController('dtTanggalPenjualan'),
      label: 'Tanggal Penjualan',
      hint: 'dd MM yyyy',
      alertText: '',
      flag: 1,
      onDateTimeSelected: (date, dateField) {
        dateField.controller.setTextSelected(DateFormat('dd MMM yyyy', 'id').format(date));
      });
  SpinnerSearch spCreatedBy = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController('spCreatedBy'), label: 'Dibuat Oleh', hint: 'Pilih Salah Satu', alertText: '', items: const {}, onSpinnerSelected: (value) {});

  SpinnerSearch spSalesBranch = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController('spSalesBranch'), label: 'Sales Branch', hint: 'Pilih Salah Satu', alertText: '', items: const {}, onSpinnerSelected: (value) {});

  late SpinnerSearch spProvince = SpinnerSearch(
      controller: GetXCreator.putSpinnerSearchController('spProvince'),
      label: 'Provinsi Customer',
      hint: 'Pilih Salah Satu',
      alertText: '',
      items: const {},
      onSpinnerSelected: (value) {
        spCity.controller.setTextSelected('');
        spCity.controller.disable();
        if (province.isNotEmpty) {
          final Location? selectLocation = province.firstWhereOrNull((element) => element!.provinceName! == value);
          if (selectLocation != null) {
            getCity(selectLocation);
          }
        }
      });
  SpinnerSearch spCity = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController('spCity'), label: 'Kota Customer', hint: 'Pilih Salah Satu', alertText: '', items: const {}, onSpinnerSelected: (value) {});
  late EditField efMin = EditField(
      controller: GetXCreator.putEditFieldController('efMin'),
      label: 'Rentang Min',
      hint: 'Ketik Disini',
      alertText: 'Min Max harus diiisi',
      inputType: TextInputType.number,
      textUnit: 'Ekor',
      maxInput: 20,
      onTyping: (value, editField) {
        efMax.controller.hideAlert();
      });
  late EditField efMax = EditField(
      controller: GetXCreator.putEditFieldController('efMax'),
      label: 'Rentang Max',
      hint: 'Ketik Disini',
      alertText: 'Min Max harus diisi',
      inputType: TextInputType.number,
      textUnit: 'Ekor',
      maxInput: 20,
      onTyping: (value, editField) {
        efMin.controller.hideAlert();
      });
  SpinnerField spStatus = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController('spStatusFilter'),
      label: 'Status',
      hint: 'Pilih Salah Satu',
      alertText: '',
      items: const {
        'Draft': false,
        'Terkonfirmasi': false,
        'Teralokasi': false,
        'Dipesan': false,
        'Siap Dikirim': false,
        'Perjalanan': false,
        'Terkirim': false,
        'Ditolak': false,
        'Batal': false,
      },
      onSpinnerSelected: (value) {});

  late DateTimeField dfTanggalPengiriman = DateTimeField(
      controller: GetXCreator.putDateTimeFieldController('dtTanggalPengirimanSOIni'),
      label: 'Tanggal Pengiriman',
      hint: 'dd MM yyyy',
      alertText: '',
      flag: 1,
      onDateTimeSelected: (date, dateField) {
        dateField.controller.setTextSelected(DateFormat('dd MMM yyyy', 'id').format(date));
        dtDeliveryTimeMin.controller.enable();
        dtDeliveryTimeMax.controller.enable();
      });

  late DateTimeField dtDeliveryTimeMin = DateTimeField(
    controller: GetXCreator.putDateTimeFieldController('deliveryTimeSoMin'),
    label: 'Waktu Min',
    hint: 'hh:mm',
    alertText: 'harus dipilih!',
    onDateTimeSelected: (date, dateField) {
      dateField.controller.setTextSelected(DateFormat('HH:mm', 'id').format(date));
      dtDeliveryTimeMax.controller.hideAlert();
    },
    flag: 2,
  );

  late DateTimeField dtDeliveryTimeMax = DateTimeField(
    controller: GetXCreator.putDateTimeFieldController('deliveryTimeSoMax'),
    label: 'Waktu Max',
    hint: 'hh:mm',
    alertText: 'harus dipilih!',
    onDateTimeSelected: (date, dateField) {
      dateField.controller.setTextSelected(DateFormat('HH:mm', 'id').format(date));
      dtDeliveryTimeMin.controller.hideAlert();
    },
    flag: 2,
  );

  late SpinnerSearch spSource = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController('spSource'), label: 'Sumber', hint: 'Pilih Salah Satu', alertText: '', items: const {}, onSpinnerSelected: (value) {});
  late SpinnerField spCategory = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController('spCategoryFilter'),
      label: 'Kategori SKU',
      hint: 'Pilih Salah Satu',
      alertText: '',
      items: const {},
      onSpinnerSelected: (value) {
        if (listCategory.isNotEmpty) {
          final CategoryModel? selectCategory = listCategory.firstWhereOrNull((element) => element!.name! == value);
          if (selectCategory != null) {
            getSku(selectCategory.id!);
          }
        }
      });
  SpinnerField spSku = SpinnerField(controller: GetXCreator.putSpinnerFieldController('spSkuFilter'), label: 'SKU', hint: 'Pilih Salah Satu', alertText: '', items: const {}, onSpinnerSelected: (value) {});

  late ButtonFill btKormasiFilter = ButtonFill(controller: GetXCreator.putButtonFillController('btKormasiFilter'), label: 'Konfirmasi Filter', onClick: () => saveFilter());

  late ButtonOutline btBersihkanFilter = ButtonOutline(controller: GetXCreator.putButtonOutlineController('btBersihkanFilter'), label: 'Bersihkan Filter', onClick: () => clearFilter());

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
          hintText: 'Cari ${selectedValue.value}',
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: SvgPicture.asset('images/search_icon.svg'),
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
                                  '$selectedValue',
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                isShowList.isTrue ? SvgPicture.asset('images/arrow_up.svg') : SvgPicture.asset('images/arrow_down.svg')
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
                        selectedValue.value = value ?? 'Customer';
                      },
                      onMenuStateChange: (isOpen) {
                        isShowList.value = isOpen;
                      },
                      dropdownStyleData: const DropdownStyleData(
                        width: 120,
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
    'Draft': false,
    'Terkonfirmasi': false,
    'Teralokasi': false,
    'Dipesan': false,
    'Siap Dikirim': false,
    'Perjalanan': false,
    'Terkirim': false,
    'Ditolak': false,
    'Batal': false,
  });
  RxMap<String, bool> mapStatusOutbondAllSC = RxMap<String, bool>({
    'Terkonfirmasi': false,
    'Teralokasi': false,
    'Dipesan': false,
    'Siap Dikirim': false,
    'Perjalanan': false,
    'Terkirim': false,
    'Ditolak': false,
  });
  RxMap<String, bool> mapStatusOutbondScFleet = RxMap<String, bool>({
    'Terkonfirmasi': false,
    'Teralokasi': false,
    'Dipesan': false,
    'Siap Dikirim': false,
    'Perjalanan': false,
    'Terkirim': false,
    'Ditolak': false,
  });
  RxMap<String, bool> mapStatusOutbondOpsUnit = RxMap<String, bool>({
    'Teralokasi': false,
    'Dipesan': false,
    'Siap Dikirim': false,
    'Perjalanan': false,
    'Terkirim': false,
    'Ditolak': false,
  });
  RxMap<String, bool> mapStatusOutbondScRelation = RxMap<String, bool>({
    'Terkonfirmasi': false,
    'Teralokasi': false,
    'Dipesan': false,
    'Siap Dikirim': false,
    'Perjalanan': false,
    'Terkirim': false,
    'Ditolak': false,
  });

  RxMap<String, bool> mapStatusInbound = RxMap<String, bool>({
    'Draft': false,
    'Terkonfirmasi': false,
    'Terkirim': false,
    'Batal': false,
  });

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  bool isInit = true;

  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
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

  void tabControllerListener(int tab) {
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

  Future<void> scrollListenerOutbound() async {
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

  Future<void> scrollListenerInbound() async {
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

  void onResponseFail(dynamic body, RxBool loading) {
    loading.value = false;
    Get.snackbar(
      'Pesan',
      'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }

  void onResponseError(RxBool loading) {
    Get.snackbar(
      'Pesan',
      'Terjadi kesalahan internal',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
    loading.value = false;
  }

  void searchOrder(String text) {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
    if (text.isNotEmpty) {
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

  void backFromForm(bool isInbound) {
    Get.back();
    Constant.track("Click_Button_Penjualan_${isInbound ? "Inbound" : "Outbound"}");
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

  Future<void> _showBottomDialog() {
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
                        SvgPicture.asset('images/icon_inbound.svg'),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penjualan Inbound',
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                              ),
                              const SizedBox(height: 4),
                              Text('Penjualan langsung pada customer tanpa pengantaran', style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10), overflow: TextOverflow.clip),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Constant.isShopKepper.isTrue || Constant.isScRelation.isTrue || Constant.isOpsLead.isTrue ? null : backFromForm(false),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.outlineColor),
                      color: Constant.isShopKepper.isTrue || Constant.isScRelation.isTrue || Constant.isOpsLead.isTrue ? const Color(0xFFF0F0F0) : Colors.white,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Constant.isShopKepper.isTrue || Constant.isScRelation.isTrue || Constant.isOpsLead.isTrue ? 'images/outbound_off.svg' : 'images/icon_outbound.svg',
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penjualan Outbound',
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Penjualan langsung pada customer dengan pengantaran',
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
