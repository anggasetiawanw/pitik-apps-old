
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/list_smart_scale_response.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 08/09/2023

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

    late Coop coop;
    late Device device;

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
        coop = Get.arguments[1];
        device = Get.arguments[0];
        isLoading.value = true;
        scrollListener();
        getSmartScaleListData();
    }

    /// The function `getSmartScaleListData` retrieves data from an API and updates
    /// the `smartScaleList` variable if the response is successful, otherwise it
    /// displays an error message.
    ///
    /// Args:
    ///   dateFilter (String): The `dateFilter` format in 'yyyy-MM-dd' parameter is used to filter the data
    /// based on a specific date. It is an optional parameter that can be passed to
    /// the `getSmartScaleListData` function. If a `dateFilter` value is provided,
    /// it will be included in the request body when calling the `
    void getSmartScaleListData({String dateFilter = '', bool isPull = false}) => AuthImpl().get().then((auth) {
        if (auth != null) {
            if ((dateFilter == '' && this.dateFilter.value != '') || (dateFilter != '' && this.dateFilter.value == '') || (dateFilter != '' && dateFilter != this.dateFilter.value) || isPull) {
                pageSmartScale.value = 1;
            }

            if (isPull) {
                isLoading.value = true;
            }

            this.dateFilter.value = dateFilter;
            Service.push(
                apiKey: "smartScaleApi",
                service: ListApi.getListSmartScale,
                context: context,
                body: [auth.token, auth.id, pageSmartScale.value, limit.value, device.roomId, this.dateFilter.value == '' ? null : this.dateFilter.value],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if (pageSmartScale.value == 1) {
                            smartScaleList.clear();
                            if ((body as ListSmartScaleResponse).data.isNotEmpty) {
                                smartScaleList.value = body.data;
                                pageSmartScale++;
                            }
                        } else {
                            if ((body as ListSmartScaleResponse).data.isNotEmpty) {
                                smartScaleList.addAll(body.data);
                                pageSmartScale++;
                            }
                        }

                        isLoadMore.value = false;
                        isLoading.value = false;
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        isLoadMore.value = false;
                        isLoading.value = false;
                        Get.snackbar(
                            "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                        );
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        isLoadMore.value = false;
                        isLoading.value = false;
                    },
                    onTokenInvalid: GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });
}

class ListSmartScaleBinding extends Bindings {

    BuildContext context;

    ListSmartScaleBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ListSmartScaleController>(() => ListSmartScaleController(context: context));
    }
}