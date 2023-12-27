import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_multi_field/spinner_multi_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/assign_operator.dart';
import 'package:model/coop_model.dart';
import 'package:model/data_farmcycle_id.dart';
import 'package:model/error/error.dart';
import 'package:model/profile.dart';
import 'package:model/response/profile_list_response.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';

class TaskSelfRegistrationController extends GetxController {
  BuildContext context;
  TaskSelfRegistrationController({required this.context});

  Coop coop = Coop();
  RxBool isLoading = false.obs;
  RxList<Profile> listOperator = <Profile>[].obs;

  SpinnerMultiField sfOperator = SpinnerMultiField(controller: GetXCreator.putSpinnerMultiFieldController("sfOperatorAddTask"), label: "Operator Kandang", hint: "Pilih Operator Kandang", alertText: "Operator Kandang Harus dipilih", items: const [], onSpinnerSelected: (value) => {});

  late ButtonFill btSubmit = ButtonFill(
    controller: GetXCreator.putButtonFillController("btSubmitAddTask"),
    label: "Tugaskan",
    onClick: () => {
      if (validate()) {submit()}
    },
  );
  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) => getAvailableOperator());
  }

  void getAvailableOperator() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              isLoading.value = true,
              Service.push(
                  apiKey: ApiMapping.api,
                  service: ListApi.getAssignableOperators,
                  context: context,
                  body: ['Bearer ${auth.token}', auth.id, "v2/farming-cycles/${coop.farmingCycleId}/operators/available"],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        listOperator.clear();
                        listOperator.addAll((body as ProfileListResponse).data.map((e) => e!).toList());
                        List<String> items = [];
                        for (var element in listOperator) {
                          items.add(element.fullName!);
                        }
                        sfOperator.controller.generateItems(items);
                        Map<String, String> subtitle = {};
                        for (var element in listOperator) {
                          subtitle[element.fullName!] = "${element.role} ${element.phoneNumber}";
                        }
                        sfOperator.controller.generateSubtitles(subtitle);
                        sfOperator.controller.showSubtitle();
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

  bool validate() {
    bool valid = true;
    if (sfOperator.controller.selectedValue.value.isEmpty) {
      valid = false;
      sfOperator.controller.showAlert();
    }
    return valid;
  }

  void submit() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
                isScrollControlled: true,
                context: Get.context!,
                builder: (context) => Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                          const SizedBox(height: 16),
                          Text('Apakah yakin melakukan penugasan dengan benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                          const SizedBox(height: 16),
                          Text("Kandang ${coop.coopName}", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold)),
                          const SizedBox(height: 16),
                          Text("Operator Kandang", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold)),
                          const SizedBox(height: 8),
                          Column(
                            children: List.generate(
                              sfOperator.controller.selectedValue.value.length,
                              (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sfOperator.controller.selectedValue.value[index], style: GlobalVar.blackTextStyle.copyWith(fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text(sfOperator.controller.subtitles[sfOperator.controller.selectedValue.value[index]] ?? "", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                  child: ButtonFill(
                                      controller: GetXCreator.putButtonFillController("YakinAddOp"),
                                      label: "Yakin",
                                      onClick: () {
                                        Get.back();
                                        addTask(auth.token!, auth.id!);
                                      })),
                              const SizedBox(width: 8),
                              Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("TidakYakinAddOperator"), label: "Tidak Yakin", onClick: () => Get.back())),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            }
          else
            {GlobalVar.invalidResponse()}
        });
  }

  void addTask(String token, String id) {
    Get.back();
    isLoading.value = true;
    Service.push(
        apiKey: ApiMapping.api,
        service: ListApi.assignOperator,
        context: context,
        body: [token, id, "v2/farming-cycles/${coop.farmingCycleId}/operators", Mapper.asJsonString(generatedAssignOperator())],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Get.back();
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              Get.back();
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan Internal",
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              Get.back();
            },
            onTokenInvalid: () => GlobalVar.invalidResponse()));
  }

  AssignOperator generatedAssignOperator() {
    AssignOperator assignOperator = AssignOperator();
    assignOperator.operatorIds = [];
    for (var element in sfOperator.controller.selectedValue.value) {
      Profile? profile = listOperator.firstWhere((e) => e.fullName == element);
      assignOperator.operatorIds!.add(DataFarmCycleId(id: profile.id));
    }
    return assignOperator;
  }
}

class TaskSelfRegistrationBindings extends Bindings {
  BuildContext context;
  TaskSelfRegistrationBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => TaskSelfRegistrationController(context: context));
  }
}
