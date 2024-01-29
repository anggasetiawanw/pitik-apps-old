part of 'data_receive_controller.dart';

extension PurhcaseReceiveController on ReceiveController {
  scrollPurchaseListener() async {
    scrollPurchaseController.addListener(() {
      if (scrollPurchaseController.position.maxScrollExtent == scrollPurchaseController.position.pixels) {
        isLoadMore.value = true;
        pagePurchase++;
        getListPurchase();
      }
    });
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
}
