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
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class SalesOrderController extends GetxController {
    BuildContext context;
    SalesOrderController({required this.context});

    var page = 1.obs;
    var limit = 10.obs;
    Rx<List<Order?>> orderList = Rx<List<Order>>([]);

    var isLoading = false.obs;
    var isLoadMore = false.obs;
    var isFilter = false.obs;
    var isSearch = false.obs;
    var searchValue = "".obs;
    Timer? debounce;

    ScrollController scrollController = ScrollController();

    late ButtonFill btPenjualan = ButtonFill(
        controller: GetXCreator.putButtonFillController("btPenjualan"),
        label: "Buat Penjualan",
        onClick: () {
            backFromForm(false);
            // _showBottomDialog();
        });

    DateTimeField dtTanggalPenjualan = DateTimeField(controller: GetXCreator.putDateTimeFieldController("dtTanggalPenjualan"), label: "Tanggal Penjualan", hint: "dd MM yyyy", alertText: "", flag: 1,onDateTimeSelected: (date, dateField) {});

    SpinnerField spCreatedBy = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spCreatedBy"), label: "Dibuat Oleh", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});
    SpinnerField spProvince = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spProvince"), label: "Province", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});
    SpinnerField spCity = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spCity"), label: "Kota", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});
    EditField efMin = EditField(controller: GetXCreator.putEditFieldController("efMin"), label: "Rentang Min", hint: "Ketik Disini", alertText: "", textUnit: "Ekor", maxInput: 20, onTyping: (value,editField){});
    EditField efMax = EditField(controller: GetXCreator.putEditFieldController("efMax"), label: "Rentang Max", hint: "Ketik Disini", alertText: "", textUnit: "Ekor", maxInput: 20, onTyping: (value,editField){});
    SpinnerField spStatus = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spStatus"), label: "Status", hint: "Pilih Salah Satu", alertText: "", 
    items: const {
        "Draft" : false,
        "Terkonfirmasi" : false,
        "Teralokasi" : false,
        "Dipesan" : false,
        "Siap Dikirim" : false,
        "Perjalanan" : false,
        "Terkirim" : false,
        "Ditolak" : false,
        "Batal" : false,
    }, onSpinnerSelected: (value) {});

    ButtonFill btKormasiFilter = ButtonFill(controller: GetXCreator.putButtonFillController("btKormasiFilter"), label: "Konfirmasi Filter", onClick: (){});

    ButtonOutline btBersihkanFilter = ButtonOutline(controller: GetXCreator.putButtonOutlineController("btBersihkanFilter"), label: "Bersihkan Filter", onClick: (){});

    @override
    void onInit() {
        super.onInit();
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
            if (isSearch.isFalse) {
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
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value, "DRAFT", "CONFIRMED", "BOOKED", "READY_TO_DELIVER", "DELIVERED", "CANCELLED", "REJECTED", "ON_DELIVERY"],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                if ((body as SalesOrderListResponse).data.isNotEmpty) {
                    for (var result in body.data) {
                    orderList.value.add(result as Order);
                    }
                    if (isLoadMore.isTrue) {
                    isLoading.value = false;
                    isLoadMore.value = false;
                    } else {
                    isLoading.value = false;
                    }
                } else {
                    if (isLoadMore.isTrue) {
                    page.value = (orderList.value.length ~/ 10).toInt() + 1;
                    isLoadMore.value = false;
                    isLoading.value = false;
                    } else {
                    isLoading.value = false;
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
        if (searchValue.value.isNotEmpty) {
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
        } else {            
            body.add(null); // customerId
            body.add(null); // salesPersonId
            body.add(null); // driverId
            body.add(null); // status
            body.add(null); // code 
            body.add(null); // sameBranch
            body.add(null); // withinProductionTeam
            body.add(null); // customerCityId
            body.add(null); // customerProvinceId
            body.add(null); // customerName
            body.add(null); // date
            body.add(null); // minQuantityRange
            body.add(null); // maxRangeQuantity
            body.add(null); // createdBy
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
                    isLoading.value = false;
                    isLoadMore.value = false;
                    } else {
                    isLoading.value = false;
                    }
                } else {
                    if (isLoadMore.isTrue) {
                    page.value = (orderList.value.length ~/ 10).toInt() + 1;
                    isLoadMore.value = false;
                    isLoading.value = false;
                    } else {
                    isLoading.value = false;
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
        Get.toNamed(RoutePage.newDataSalesOrder, arguments: isInbound)!.then((value) {
        getListOrder();
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
        if (text.length > 1) {
        if (debounce?.isActive ?? false) debounce?.cancel();
        debounce = Timer(const Duration(milliseconds: 500), () {
            page.value = 1;
            isSearch.value = true;
            searchValue.value = text;
            orderList.value.clear();
            getSearchOrder();
        });
        } else if (text.length <= 1) {
        if (debounce?.isActive ?? false) debounce?.cancel();
        debounce = Timer(const Duration(milliseconds: 500), () {
            isLoading.value = false;
            isSearch.value = false;
            searchValue.value = "";
            orderList.value.clear();
            page.value = 1;
            getListOrders();
        });
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
                      dtTanggalPenjualan,
                      spCreatedBy,
                      spProvince,
                      spCity,
                      Row(children: [
                          Expanded(child: efMin),
                          const SizedBox(width: 8),
                          Expanded(child: efMax),
                      ],),
                      spStatus,
                      const Spacer(),
            
                      Row(children: [
                          Expanded(child: btKormasiFilter),
                          const SizedBox(width: 8),
                          Expanded(child: btBersihkanFilter),
                      ],),
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
