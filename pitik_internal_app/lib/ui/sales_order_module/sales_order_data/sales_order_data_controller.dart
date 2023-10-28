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
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/place_model.dart';
import 'package:model/internal_app/sales_person_model.dart';
import 'package:model/response/internal_app/location_list_response.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:model/response/internal_app/salesperson_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class SalesOrderController extends GetxController {
  BuildContext context;
  SalesOrderController({required this.context});
  TextEditingController searchController = TextEditingController();
  var page = 1.obs;
  var limit = 10.obs;
  Rx<List<Order?>> orderList = Rx<List<Order>>([]);
  Rx<List<SalesPerson?>> listSalesperson = Rx<List<SalesPerson>>([]);
  Rx<List<Location?>> province = Rx<List<Location>>([]);
  Rx<List<Location?>> city = Rx<List<Location>>([]);

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var isFilter = false.obs;
  var isSearch = false.obs;
  var searchValue = "".obs;
  var isLoadData = false.obs;
  Rx<Map<String, String>> listFilter = Rx<Map<String, String>>({});
  Timer? debounce;

  ScrollController scrollController = ScrollController();

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
        if (province.value.isNotEmpty) {
          Location? selectLocation = province.value.firstWhere((element) => element!.provinceName! == value);
          if (selectLocation != null) {
            getCity(selectLocation);
          }
        }
      });
  SpinnerSearch spCity = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController("spCity"), label: "Kota Customer", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});
  late EditField efMin = EditField(controller: GetXCreator.putEditFieldController("efMin"), label: "Rentang Min", hint: "Ketik Disini", alertText: "Min Max harus diiisi",inputType: TextInputType.number, textUnit: "Ekor", maxInput: 20, onTyping: (value, editField) {
    efMax.controller.hideAlert();
  });
  late EditField efMax = EditField(controller: GetXCreator.putEditFieldController("efMax"), label: "Rentang Max", hint: "Ketik Disini", alertText: "Min Max harus diisi",inputType: TextInputType.number, textUnit: "Ekor", maxInput: 20, onTyping: (value, editField) {
    efMin.controller.hideAlert();
  });
  SpinnerField spStatus = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("spStatus"),
      label: "Status",
      hint: "Pilih Salah Satu",
      alertText: "",
      items: const {
        "Draft": false,
        "Terkonfirmasi": false,
        // "Teralokasi": false,
        "Dipesan": false,
        "Siap Dikirim": false,
        "Perjalanan": false,
        "Terkirim": false,
        "Ditolak": false,
        "Batal": false,
      },
      onSpinnerSelected: (value) {});

  late ButtonFill btKormasiFilter = ButtonFill(controller: GetXCreator.putButtonFillController("btKormasiFilter"), label: "Konfirmasi Filter", onClick: () => saveFilter());

  late ButtonOutline btBersihkanFilter = ButtonOutline(controller: GetXCreator.putButtonOutlineController("btBersihkanFilter"), label: "Bersihkan Filter", onClick: () => clearFilter());

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting();
    scrollListener();
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    getListOrders();
  }

  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        if (isSearch.isTrue || isFilter.isTrue) {
          page++;
          getSearchOrder();
        } else {
          page++;
          getListOrders();
        }
      }
    });
  }

  void getListOrders() {
    Service.push(
        service: ListApi.getListOrders,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value, "DRAFT", "CONFIRMED", "BOOKED", "READY_TO_DELIVER", "DELIVERED", "CANCELLED", "REJECTED", "ON_DELIVERY","ALLOCATED"],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as SalesOrderListResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  orderList.value.add(result as Order);
                }
                if (isLoadMore.isTrue) {
                  isLoading.value = false;
                  isLoadMore.value = false;
                  isLoadData.value = false;
                } else {
                  isLoading.value = false;
                  isLoadData.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  page.value = (orderList.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                  isLoading.value = false;
                  isLoadData.value = false;
                } else {
                  isLoading.value = false;
                  isLoadData.value = false;
                }
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = false;
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
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
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  /// @Query("customerId") String customerId,
  /// @Query("salesPersonId") String salesPersonId,
  /// @Query("driverId") String driverId,
  /// @Query("status") String status,
  /// @Query("code") String code,
  /// @Query("sameBranch") bool sameBranch,
  /// @Query("withinProductionTeam") bool withinProductionTeam,
  /// @Query("customerCityId") int customerCityId,
  /// @Query("customerProvinceId") int customerProvinceId,
  /// @Query("customerName") String customerName,
  /// @Query("date") String date,
  /// @Query("minQuantityRange") int minQuantityRange,
  /// @Query("maxRangeQuantity") int maxRangeQuantity,
  /// @Query("createdBy") String createdBy,
  void getSearchOrder() {
    List<dynamic> body = [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value];
    if (isSearch.isTrue) {
      body.add(null); // customerId
      body.add(null); // salesPersonId
      body.add(null); // driverId
      body.add(null); // status
      body.add(null); // code
      body.add(null); // sameBranch
      body.add(null); // withinProductionTeam
      body.add(null); // customerCityId
      body.add(null); // customerProvinceId
      body.add(searchValue.value); // customerName
      body.add(null); // date
      body.add(null); // minQuantityRange
      body.add(null); // maxRangeQuantity
      body.add(null); // createdBy
    } else if (isFilter.isTrue) {
      Location? provinceSelect;

      if (spProvince.controller.textSelected.value.isNotEmpty) {
        provinceSelect = province.value.firstWhere(
          (element) => element!.provinceName == spProvince.controller.textSelected.value,
        );
      }

      Location? citySelect;
      if (spCity.controller.textSelected.value.isNotEmpty) {
        citySelect = city.value.firstWhere(
          (element) => element!.cityName == spCity.controller.textSelected.value,
        );
      }

      SalesPerson? salesSelect;
      if (spCreatedBy.controller.textSelected.value.isNotEmpty) {
        salesSelect = listSalesperson.value.firstWhere(
          (element) => element!.email == spCreatedBy.controller.textSelected.value,
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

      body.add(null); // customerId
      body.add(null); // salesPersonId
      body.add(null); // driverId
      body.add(status); // status
      body.add(null); // code
      body.add(null); // sameBranch
      body.add(null); // withinProductionTeam
      body.add(citySelect?.id); // customerCityId
      body.add(provinceSelect?.id); // customerProvinceId
      body.add(null); // customerName
      body.add(date); // date
      body.add(efMin.getInputNumber() != null ? (efMin.getInputNumber() ?? 0).toInt() : null); // minQuantityRange
      body.add(efMax.getInputNumber() != null ? (efMax.getInputNumber() ?? 0).toInt() : null); // maxRangeQuantity
      body.add(salesSelect?.id); // createdBy
    }
    Service.push(
        service: ListApi.getListOrdersFilter,
        context: context,
        body: body,
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as SalesOrderListResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  orderList.value.add(result as Order);
                }
                if (isLoadMore.isTrue) {
                  isLoadData.value = false;
                  isLoadMore.value = false;

                  listFilter.refresh();
                } else {
                  isLoadData.value = false;

                  listFilter.refresh();
                }
              } else {
                if (isLoadMore.isTrue) {
                  page.value = (orderList.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                  isLoadData.value = false;

                  listFilter.refresh();
                } else {
                  isLoadData.value = false;

                  listFilter.refresh();
                }
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoadData.value = false;
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
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
              isLoadData.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  _showBottomDialog() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
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
                  onTap: () => backFromForm(false),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.outlineColor)),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "images/icon_outbound.svg",
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

  void backFromForm(bool isInbound) {
    Get.back();
    isLoadData.value = true;
    orderList.value.clear();
    page.value = 1;
    Get.toNamed(RoutePage.newDataSalesOrder, arguments: isInbound)!.then((value) {
      if (isFilter.isTrue) {
        getSearchOrder();
      } else {
        getListOrder();
      }
    });
  }

  void getListOrder() {
    isLoading.value = true;
    orderList.value.clear();
    page.value = 1;
    Timer(const Duration(milliseconds: 100), () {
      getListOrders();
    });
  }

  void searchOrder(String text) {
    if (text.isNotEmpty) {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        page.value = 1;
        isSearch.value = true;
        listFilter.value.clear();
        isFilter.value = false;
        isLoadData.value = true;
        searchValue.value = text;
        orderList.value.clear();
        getSearchOrder();
      });
    } else {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        isSearch.value = false;
        isLoadData.value = true;
        searchValue.value = "";
        orderList.value.clear();
        page.value = 1;
        getListOrders();
      });
    }
  }

  void openFilter() {
    if (spCity.controller.textSelected.isEmpty) {
      spCity.controller.disable();
    }
    getSalesList();
    getProvince();
    showFilter();
  }

  void getProvince() {
    spProvince.controller
      ..disable()
      ..showLoading();
    Service.pushWithIdAndPacket(service: ListApi.getProvince, context: context, id: 1, packet: [province, spProvince], body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!], listener: _getListLocationListener);
  }

  void getCity(Location province) {
    spCity.controller
      ..disable()
      ..showLoading();
    Service.pushWithIdAndPacket(service: ListApi.getCity, context: context, id: 2, packet: [city, spCity], body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, province.id], listener: _getListLocationListener);
  }

  final _getListLocationListener = ResponseListener(
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
          (packet[0] as Rx<List<Location?>>).value.add(result);
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
        print(stacktrace);
        (packet[1] as SpinnerSearch).controller
          ..enable()
          ..hideLoading();
        Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
      },
      onTokenInvalid: Constant.invalidResponse());

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
                          listSalesperson.value.add(result);
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

      Get.back();
      orderList.value.clear();
      page.value = 1;
      isFilter.value = true;
      isSearch.value = false;
      isLoadData.value = true;
      getSearchOrder();
    } else {
        if(efMax.getInput().isEmpty && efMin.getInput().isEmpty) {            
            Get.back();
            orderList.value.clear();
            page.value = 1;
            isLoadData.value = true;
            getListOrders();
        }
    }
  }

  bool validationFilter() {
    if (efMax.getInput().isNotEmpty) {
        if( efMin.getInput().isEmpty){
            efMin.controller.showAlert();
            efMax.controller.showAlert();
            return false;
        }
    } else if (efMin.getInput().isNotEmpty) {
        if(efMax.getInput().isEmpty){
            efMax.controller.showAlert();
            efMin.controller.showAlert();
            return false;
        }
    }
    else if(efMax.getInput().isNotEmpty && efMin.getInput().isNotEmpty) {
        if(efMin.getInputNumber()! > efMax.getInputNumber()!) {
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
    listFilter.value.clear();
    Get.back();
    orderList.value.clear();
    page.value = 1;
    isFilter.value = false;
    isSearch.value = false;
    isLoadData.value = true;
    getListOrders();
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
      default:
    }

    listFilter.value.remove(key);
    listFilter.refresh();
    if (listFilter.value.isEmpty) {
      orderList.value.clear();
      page.value = 1;
      isFilter.value = false;
      isSearch.value = false;
      isLoadData.value = true;
      getListOrders();
    } else {
      page.value = 1;
      isLoadData.value = true;
      getSearchOrder();
    }
  }

  void pullRefresh() {
    orderList.value.clear();
    if (isSearch.isTrue) {
      page.value = 1;
      isLoadData.value = true;
      getSearchOrder();
    } else if (isFilter.isTrue) {
      page.value = 1;
      isLoadData.value = true;
      getSearchOrder();
    } else if (isSearch.isFalse && isFilter.isFalse) {
      page.value = 1;
      isLoadData.value = true;
      getListOrders();
    }
  }

  showFilter() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.95,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start ,
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
                  dtTanggalPenjualan,
                  spCreatedBy,
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
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: btKormasiFilter),
                      const SizedBox(width: 8),
                      Expanded(child: btBersihkanFilter),
                    ],
                  ),
                  const SizedBox(height: Constant.bottomSheetMargin),
                ],
              ),
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
