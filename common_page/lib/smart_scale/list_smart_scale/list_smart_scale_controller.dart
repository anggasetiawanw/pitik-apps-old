// ignore_for_file: slash_for_doc_comments, constant_identifier_names

import 'package:common_page/smart_scale/bundle/list_smart_scale_bundle.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.idd>
/// @create date 08/09/2023

class ListSmartScaleController extends GetxController {
  BuildContext context;
  ListSmartScaleController({required this.context});

  ScrollController scrollController = ScrollController();
  RxList<SmartScale?> smartScaleList = RxList<SmartScale?>([]);

  var isLoadMore = false.obs;
  var pageSmartScale = 1.obs;
  var limit = 20.obs;
  var isLoading = false.obs;
  var dateFilter = ''.obs;

  late ListSmartScaleBundle bundle;
  late DateTimeField dateFilterField;

  /// The scrollListener function listens for scroll events and triggers a load
  /// more action when the user reaches the end of the scroll.
  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        getSmartScaleListData(dateFilter: dateFilter.value);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    bundle = Get.arguments;
    dateFilterField = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("filterListSmartScale"),
        label: "Pilih Tanggal",
        hint: "2023/08/15",
        alertText: "Tanggal harus pilih..!",
        flag: DateTimeField.DATE_FLAG,
        onDateTimeSelected: (dateTime, dateField) {
          dateField.controller.setTextSelected("${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}");
        });

    isLoading.value = true;
    scrollListener();
    getSmartScaleListData();
  }

  void showWeighingNotFound() => Get.snackbar(
        "Pesan",
        "Data timbang kosong...",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );

  // The function `getSmartScaleListData` retrieves data from an API and updates
  // the `smartScaleList` variable if the response is successful, otherwise it
  // displays an error message.
  //
  // Args:
  //   dateFilter (String): The `dateFilter` format in 'yyyy-MM-dd' parameter is used to filter the data
  // based on a specific date. It is an optional parameter that can be passed to
  // the `getSmartScaleListData` function. If a `dateFilter` value is provided,
  // it will be included in the request body when calling the `
  void getSmartScaleListData({String dateFilter = '', bool isPull = false}) {
    if ((dateFilter == '' && this.dateFilter.value != '') || (dateFilter != '' && this.dateFilter.value == '') || (dateFilter != '' && dateFilter != this.dateFilter.value) || isPull) {
      pageSmartScale.value = 1;
    }

    if (isPull) {
      isLoading.value = true;
    }

    this.dateFilter.value = dateFilter;
    bundle.onGetSmartScaleListData(this);
  }
}

class ListSmartScaleBinding extends Bindings {
  BuildContext context;
  ListSmartScaleBinding({required this.context});

  @override
  void dependencies() {
    Get.lazyPut<ListSmartScaleController>(() => ListSmartScaleController(context: context));
  }
}
