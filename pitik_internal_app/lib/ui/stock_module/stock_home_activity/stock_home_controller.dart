import 'dart:async';
import 'dart:math';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/opname_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/list_opnames_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/stock_aggregate_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/controllers/tab_detail_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockHomeController extends GetxController {
  BuildContext context;
  StockHomeController({required this.context});
  final TabDetailController tabController = Get.put(TabDetailController());
  List<Color> colors = [Colors.redAccent, Colors.orange, Colors.green, Colors.cyan, Colors.lightGreen, Colors.deepPurple, Colors.black];

  Rx<List<PieData>> pieData = Rx<List<PieData>>([]);
  Rx<List<ChartData>> chartData = Rx<List<ChartData>>([]);

  ScrollController scrollController = ScrollController();
  late TooltipBehavior tooltip;
  Map<String, bool> mapList = {};
  var page = 1.obs;
  var limit = 10.obs;
  var isLoading = false.obs;
  var isLoadingOpname = false.obs;
  var isLoadingStock = false.obs;
  var isLoadMore = false.obs;
  var load = false.obs;
  OperationUnitModel? sourceStock;
  Rx<List<OperationUnitModel?>> listOperationUnits = Rx<List<OperationUnitModel?>>([]);
  Rx<List<OpnameModel?>> listOpname = Rx<List<OpnameModel?>>([]);
  OperationUnitModel? selectSourceOpname;
  Products? selectCategory;
  late SpinnerField sourceLatestStock = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("sourceLatestStock"),
      label: "Sumber*",
      hint: "Pilih Salah Satu",
      alertText: "Sumber Harus dipilih!",
      items: const {},
      onSpinnerSelected: (value) {
        if (listOperationUnits.value.isNotEmpty) {
          OperationUnitModel? selectSource = listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == value);
          if (selectSource != null) {
            // isLoadingStock.value = true;
            // pieData.value.clear();
            // getLatestStock(selectSource.id!);
            categoryStock.controller.setTextSelected("");
            sourceStock = selectSource;
            Map<String, bool> mapStock = {};
            for (var units in selectSource.purchasableProducts!) {
              mapStock[units!.name!] = false;
            }
            categoryStock.controller.generateItems(mapStock);
            categoryStock.controller.enable();
          }
        }
      });

  late SpinnerField categoryStock = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("catStockOpname"),
      label: "Kategori SKU*",
      hint: "Pilih salah satu",
      alertText: "Sumber harus dipilih!",
      items: const {},
      onSpinnerSelected: (value) {
        if (sourceStock != null) {
          selectCategory = sourceStock!.purchasableProducts!.firstWhereOrNull((element) => element!.name == value);
          chartData.value.clear();
          getLatestStock(sourceStock!.id!, selectCategory!.id!);
        }
      });

  late SpinnerField sourceOpname = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("souceOpname"),
      label: "Sumber*",
      hint: "Pilih Salah Satu",
      alertText: "Sumber Harus Di pilih",
      items: const {},
      onSpinnerSelected: (value) {
        if (listOperationUnits.value.isNotEmpty) {
          selectSourceOpname = listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == value);
          if (selectSourceOpname != null) {
            isLoadingOpname.value = true;
            listOpname.value.clear();

            page.value = 0;
            getListOpname();
          }
        }
      });

  late ButtonFill stockOpnameButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("stockOpname"),
      label: "Stock Opname",
      onClick: () {
        GlobalVar.track("Click_Stock_Opname");
        Get.toNamed(RoutePage.stockOpname, arguments: [null, false, selectSourceOpname])!.then((value) {
          Timer(const Duration(milliseconds: 500), () {
            if (selectSourceOpname != null) {
              isLoadingOpname.value = true;
              listOpname.value.clear();
              page.value = 0;
              getListOpname();
            }
          });
        });
      });

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    scrollListener();
    sourceLatestStock.controller.invisibleSpinner();
    categoryStock.controller.disable();
    tabListener();
    tooltip = TooltipBehavior(enable: true);
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    getListSourceUnit();
  }

  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        if (listOpname.value.isNotEmpty) {
          isLoadMore.value = true;
          page++;
          getListOpname();
        }
      }
    });
  }

  tabListener() async {
    tabController.controller.addListener(() {
      if (tabController.controller.index == 1 && sourceLatestStock.items.values.isEmpty) {
        sourceLatestStock.controller.generateItems(mapList);
      }
    });
  }

  void pullRefresh() {
    if (selectSourceOpname != null) {
      isLoadingOpname.value = true;
      listOpname.value.clear();
      page.value = 1;
      getListOpname();
    }
  }

  void getListSourceUnit() {
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE, 0],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              for (var units in (body as ListOperationUnitsResponse).data) {
                mapList[units!.operationUnitName!] = false;
              }
              sourceLatestStock.controller.generateItems(mapList);
              sourceOpname.controller.generateItems(mapList);
              for (var result in body.data) {
                listOperationUnits.value.add(result);
              }
              isLoading.value = false;
              sourceLatestStock.controller.visibleSpinner();
              timeEnd = DateTime.now();
              Duration totalTime = timeEnd.difference(timeStart);
              GlobalVar.trackRenderTime("Stock_Home", totalTime);
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
              isLoading.value = false;
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

  void getListOpname() {
    Service.push(
        service: ListApi.getListOpname,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, selectSourceOpname!.id, page.value, limit.value],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListOpnameResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listOpname.value.add(result as OpnameModel);
                }
                isLoadingOpname.value = false;
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  page.value = (listOpname.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoadingOpname.value = false;
                }
              }
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
              isLoadingOpname.value = false;
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
              isLoadingOpname.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getLatestStock(String id, String productCategoryId) {
    Service.push(
        service: ListApi.getLatestStockOpname,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetListStockByUnit(id), productCategoryId],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Random random = Random();
              chartData.value.clear();
              for (var units in (body as ListStockAggregateResponse).data[0]!.productItems!) {
                if (body.data[0]!.productCategoryName == AppStrings.LIVE_BIRD || body.data[0]!.productCategoryName == AppStrings.AYAM_UTUH || body.data[0]!.productCategoryName == AppStrings.BRANGKAS || body.data[0]!.productCategoryName == AppStrings.KARKAS) {
                  units!.name!.replaceAll("${body.data[0]!.productCategoryName}", "");
                  units.name!.replaceAll("kg}", "");
                  chartData.value.add(ChartData(body.data[0]!.productCategoryName!, units.name!, units.availableQuantity!, units.availableWeight!, Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1)));
                } else {
                  chartData.value.add(ChartData(body.data[0]!.productCategoryName!, units!.name!, 0, units.availableWeight!, Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1)));
                }
              }
              chartData.value.sort((b, a) => a.x.compareTo(b.x));
              chartData.refresh();

              // chartData.value.forEach((element) {
              //     print("CHART DATA ->>>> ${element.x}");
              // });

              isLoadingStock.value = false;
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
              isLoadingStock.value = false;
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                "Pesan",
                "Something Wrong,$exception}",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoadingStock.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}

class StockHomeBindings extends Bindings {
  BuildContext context;
  StockHomeBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => StockHomeController(context: context));
  }
}

class PieData {
  PieData(this.x, this.y, this.amount, [this.color]);
  final String x;
  final double y;
  final int? amount;
  final Color? color;
}

class ChartData {
  ChartData(this.y1, this.x, this.y, this.y2, [this.color]);
  final String x;
  final String y1;
  final int y;
  final double y2;
  final Color? color;
}
