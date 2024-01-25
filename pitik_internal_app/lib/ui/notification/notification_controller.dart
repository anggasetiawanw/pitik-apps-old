import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/notification.dart';
import 'package:pitik_internal_app/api_mapping/api_mapping.dart';

class NotificationController extends GetxController {
  BuildContext context;
  NotificationController({required this.context});

  RxList<Notifications> notificationList = <Notifications>[].obs;
  int page = 1;
  int limit = 10;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    // getListNotification();
    scrollListener();
  }

  // @override
  // void onReady() {
  //     super.onReady();
  // }
  // @override
  // void onClose() {
  //     super.onClose();
  // }
  void pullRefresh() {
    isLoading.value = true;
    notificationList.clear();
    page = 1;
    getListNotification();
  }

  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        page++;
        getListNotification();
      }
    });
  }

  void onReadAllNotification(){
    isLoading.value = true;
    AuthImpl().get().then((auth) => {
        if (auth != null){
            Service.push(
                apiKey: ApiMapping.api,
                service: ListApi.readAllNotifications,
                context: context,
                body: [
                    'Bearer ${auth.token}',
                    auth.id,
                    "",
                ],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        notificationList.clear();
                        page = 1;
                        getListNotification();
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,);
                        isLoading.value = true;
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,);
                        isLoading.value = true;
                    },
                        onTokenInvalid: () => GlobalVar.invalidResponse()))
                }
        else
            {GlobalVar.invalidResponse()}
    });
  }

  void onTapNotification(int index) {
    isLoading.value = true;
    if (notificationList[index].isRead == false) {
      AuthImpl().get().then((auth) => {
            if (auth != null)
              {
                Service.push(
                    apiKey: ApiMapping.api,
                    service: ListApi.updateNotification,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, "v2/notifications/read/${notificationList[index].id}", ""],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                        //   notificationList[index].isRead = true;
                        //   notificationList.refresh();
                        //   if (notificationList[index].target != null && notificationList[index].target!.isNotEmpty) {
                        //     if (notificationList[index].target == "id.pitik.mobile.ui.activity.LoginActivity") {
                        //       GlobalVar.invalidResponse();
                        //     } else {
                        //       Deeplink.toTarget(
                        //         target: notificationList[index].target!,
                        //         arguments: DeeplinkMappingArguments.createArguments(
                        //           target: notificationList[index].target!,
                        //           additionalParameters: notificationList[index].additionalParameters!,
                        //         ),
                        //       );
                        //     }
                        //   }
                        //   isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                          Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                          );
                          isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                          Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                          );
                          isLoading.value = false;
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()))
              }
            else
              {GlobalVar.invalidResponse()}
          });
    }
  }

  void getListNotification() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              Service.push(
                  apiKey: ApiMapping.api,
                  service: ListApi.notifications,
                  context: context,
                  body: ['Bearer ${auth.token}', auth.id, page, limit],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        if (body.data.isNotEmpty) {
                          for (var result in body.data) {
                            notificationList.add(result as Notifications);
                          }
                          isLoading.value = false;
                          if (isLoadMore.isTrue) {
                            isLoadMore.value = false;
                          }
                        } else {
                          if (isLoadMore.isTrue) {
                            page = (notificationList.length ~/ 10).toInt() + 1;
                            isLoadMore.value = false;
                          } else {
                            isLoading.value = false;
                          }
                        }
                      },
                      onResponseFail: (code, message, body, id, packet) {
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
                          "Terjadi Kesalahan Internal",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                      },
                      onTokenInvalid: () => GlobalVar.invalidResponse()))
            }
          else
            {GlobalVar.invalidResponse()}
        });
  }
}

class NotificationBindings extends Bindings {
  BuildContext context;
  NotificationBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController(context: context));
  }
}
