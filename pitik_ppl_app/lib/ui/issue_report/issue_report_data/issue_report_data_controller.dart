import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/issue.dart';
import 'package:model/response/issue_list_response.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';

class IssueReportDataController extends GetxController {
  BuildContext context;
  IssueReportDataController({required this.context});

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  Coop coop = Get.arguments[0] as Coop;
  RxList<Issue?> issueList = <Issue?>[].obs;
  int limit = 10;
  int page = 1;
  ScrollController scrollController = ScrollController();

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    scrollListener();
    getIssueList();
  }

  scrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        page++;
        getIssueList();
      }
    });
  }

  void refreshList() {
    isLoading.value = true;
    page = 1;
    getIssueList();
  }

  void getIssueList() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              Service.push(
                  apiKey: ApiMapping.api,
                  service: ListApi.issueList,
                  context: context,
                  body: [
                    'Bearer ${auth.token}',
                    auth.id,
                    "v2/issues/list/${coop.farmingCycleId}",
                    page,
                    limit,
                    "DESC",
                  ],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        if ((body as IssueListResponse).data.isNotEmpty) {
                          if (page == 1) {
                            issueList.clear();
                            issueList.value = body.data;
                          } else {
                            issueList.addAll(body.data);
                          }
                        }

                        isLoadMore.value = false;
                        isLoading.value = false;
                      },
                      onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        isLoadMore.value = false;
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
                        isLoadMore.value = false;
                        isLoading.value = false;
                      },
                      onTokenInvalid: () => GlobalVar.invalidResponse()))
            }
          else
            {GlobalVar.invalidResponse()}
        });
  }
}

class IssueReportDataBindings extends Bindings {
  BuildContext context;
  IssueReportDataBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => IssueReportDataController(context: context));
  }
}
