part of 'data_receive_controller.dart';

extension PurhcaseReceiveController on ReceiveController {
  void resetAllBodyPurhcaseValue() {
    pagePurchase.value = 1;
    listPurchase.value.clear();
    for (int i = 0; i < bodyGeneralPurhcase.length; i++) {
      bodyGeneralPurhcase[i] = null;
    }
    bodyGeneralPurhcase[BodyQueryPurhcase.token.index] = Constant.auth!.token;
    bodyGeneralPurhcase[BodyQueryPurhcase.auth.index] = Constant.auth!.id;
    bodyGeneralPurhcase[BodyQueryPurhcase.xAppId.index] = Constant.xAppId;
    bodyGeneralPurhcase[BodyQueryPurhcase.page.index] = pagePurchase.value;
    bodyGeneralPurhcase[BodyQueryPurhcase.limit.index] = limit.value;
    bodyGeneralPurhcase[BodyQueryPurhcase.statusConfirmed.index] = "CONFIRMED";
    bodyGeneralPurhcase[BodyQueryPurhcase.statusReceived.index] = "RECEIVED";
    bodyGeneralPurhcase[BodyQueryPurhcase.withinProductionTeam.index] = AppStrings.TRUE_LOWERCASE;
  }

  void openFilterPurchase() {
    if (spSku.controller.textSelected.isEmpty) {
      spSku.controller.disable();
    }
    if (spCategory.controller.textSelected.isNotEmpty) {
      spSku.controller.enable();
    }
    if (spSumber.controller.textSelected.isEmpty) {
      spSumber.controller.disable();
    }
    if (spJenisSumber.controller.textSelected.isNotEmpty) {
      spSumber.controller.enable();
    }

    spJenisSumber.controller.visibleSpinner();
    spTujuan.controller.visibleSpinner();
    getCategorySku();
    getListDestinationPurchase();
    showFilter();
  }

  scrollPurchaseListener() async {
    scrollPurchaseController.addListener(() {
      if (scrollPurchaseController.position.maxScrollExtent == scrollPurchaseController.position.pixels) {
        isLoadMore.value = true;
        pagePurchase++;
        getListPurchase();
      }
    });
  }

  void filterPurchase() {
    resetAllBodyPurhcaseValue();

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
    if (spTujuan.controller.textSelected.value.isNotEmpty) {
      operationUnitSelect = listDestinationPurchase.value.firstWhere(
        (element) => element!.operationUnitName == spTujuan.controller.textSelected.value,
      );
    }

    OperationUnitModel? jagalSelect;
    VendorModel? vendorSelect;

    if (spJenisSumber.controller.textSelected.value.isNotEmpty) {
      if (spJenisSumber.controller.textSelected.value == "Jagal Eksternal") {
        jagalSelect = listSourceJagal.value.firstWhereOrNull((element) => element!.operationUnitName == spSumber.controller.textSelected.value);
      } else {
        vendorSelect = listSourceVendor.value.firstWhereOrNull((element) => element!.vendorName == spSumber.controller.textSelected.value);
      }
    }

    String? status;
    switch (spStatus.controller.textSelected.value) {
      case "Terkonfirmasi":
        status = "CONFIRMED";
        break;
      case "Diterima":
        status = "RECEIVED";
        break;
      case "Dibatalkan":
        status = "CANCELLED";
        break;
      default:
    }

    if(status != null){
        bodyGeneralPurhcase[BodyQueryPurhcase.statusConfirmed.index] = null;
        bodyGeneralPurhcase[BodyQueryPurhcase.statusReceived.index] = null;
    }

    String? date = dtTanggalFilterReceive.controller.textSelected.value.isEmpty ? null : DateFormat("yyyy-MM-dd").format(dtTanggalFilterReceive.getLastTimeSelected());
    bodyGeneralPurhcase[BodyQueryPurhcase.createdDate.index] = date;
    bodyGeneralPurhcase[BodyQueryPurhcase.productCategoryId.index] = categorySelect?.id;
    bodyGeneralPurhcase[BodyQueryPurhcase.productItemId.index] = productSelect?.id;
    bodyGeneralPurhcase[BodyQueryPurhcase.operationUnitId.index] = operationUnitSelect?.id;
    bodyGeneralPurhcase[BodyQueryPurhcase.vendorId.index] = vendorSelect?.id;
    bodyGeneralPurhcase[BodyQueryPurhcase.jagalId.index] = jagalSelect?.id;
    bodyGeneralPurhcase[BodyQueryPurhcase.status.index] = status;
    bodyGeneralPurhcase[BodyQueryPurhcase.source.index] = spJenisSumber.controller.textSelected.value.isEmpty
        ? null
        : spJenisSumber.controller.textSelected.value == "Jagal Eksternal"
            ? "JAGAL"
            : "VENDOR";
    isLoadingPurchase.value = true;
    getListPurchase();
  }

  void getListSourceVendor() {
    spSumber.controller
      ..disable()
      ..showLoading();
    Service.push(
        service: ListApi.getListVendors,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var vendor in (body as VendorListResponse).data) {
                mapList[vendor!.vendorName!] = false;
              }
              for (var result in body.data) {
                listSourceVendor.value.add(result);
              }
              Timer(const Duration(milliseconds: 100), () {
                spSumber.controller
                  ..generateItems(mapList)
                  ..setTextSelected("")
                  ..hideLoading()
                  ..enable()
                  // ignore: invalid_use_of_protected_member
                  ..refresh();
              });
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
              spSumber.controller.hideLoading();
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan Internal",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              spSumber.controller.hideLoading();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getListJagalExternal() {
    spSumber.controller
      ..disable()
      ..showLoading();
    Service.push(
        service: ListApi.getListJagalExternal,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, "JAGAL", "EXTERNAL"],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
          Map<String, bool> mapList = {};
          for (var customer in (body as ListOperationUnitsResponse).data) {
            mapList[customer!.operationUnitName!] = false;
          }
          for (var result in body.data) {
            listSourceJagal.value.add(result!);
          }
          Timer(const Duration(milliseconds: 100), () {
            spSumber.controller
              ..generateItems(mapList)
              ..setTextSelected("")
              ..hideLoading()
              ..enable()
              // ignore: invalid_use_of_protected_member
              ..refresh();
          });
        }, onResponseFail: (code, message, body, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spSumber.controller.hideLoading();
        }, onResponseError: (exception, stacktrace, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan Internal",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spSumber.controller.hideLoading();
        }, onTokenInvalid: () {
          Constant.invalidResponse();
        }));
  }

  void getListDestinationPurchase() {
    spTujuan.controller
      ..disable()
      ..showLoading();
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE, 0],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
          Map<String, bool> mapList = {};
          for (var customer in (body as ListOperationUnitsResponse).data) {
            mapList[customer!.operationUnitName!] = false;
          }
          spTujuan.controller.generateItems(mapList);

          for (var result in body.data) {
            listDestinationPurchase.value.add(result!);
          }
          spTujuan.controller.hideLoading();
          spTujuan.controller.enable();
          // ignore: invalid_use_of_protected_member
          spTujuan.controller.refresh();
        }, onResponseFail: (code, message, body, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spTujuan.controller.hideLoading();
        }, onResponseError: (exception, stacktrace, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan Internal",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spTujuan.controller.hideLoading();
        }, onTokenInvalid: () {
          Constant.invalidResponse();
        }));
  }

  void getListPurchase() {
    Service.push(
        service: ListApi.getGoodReceiptPOList,
        context: context,
        body: bodyGeneralPurhcase,
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListPurchaseResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listPurchase.value.add(result as Purchase);
                }
                isLoadingPurchase.value = false;
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  pagePurchase.value = (listPurchase.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoadingPurchase.value = false;
                }
              }
              countingApi();
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
              isLoadingPurchase.value = false;
              countingApi();
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
              isLoadingPurchase.value = false;
              countingApi();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}
