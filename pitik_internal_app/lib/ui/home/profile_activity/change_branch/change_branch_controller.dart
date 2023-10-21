import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import 'package:lottie/lottie.dart';
import 'package:model/branch.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/response/%20branch_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class ChangeBranchController extends GetxController {
    BuildContext context;
    ChangeBranchController({required this.context});

    SpinnerSearch spBranch = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController("spBranch"), label: "Branch", hint: "Pilih Salah Satu", alertText: "Branch harus dipilih!", items: const {}, onSpinnerSelected: (value) {});
    late ButtonFill btSimpan = ButtonFill(controller: GetXCreator.putButtonFillController("btSimpan"), label: "Simpan", onClick: (){
        if(spBranch.controller.textSelected.isEmpty){
            spBranch.controller.showAlert();
            return;
        }
        _showBottomDialog();
        
    });
    late ButtonFill btYakin = ButtonFill(controller: GetXCreator.putButtonFillController("btYakin"), label: "Iya", onClick: () {
        Get.back();
        changeBranch();

    });
    late ButtonOutline btTidakYakin = ButtonOutline(controller: GetXCreator.putButtonOutlineController("btTidakYakin"), label: "Tidak", onClick: () => Get.back());

    Rx<List<Branch?>> listBranch = Rx<List<Branch?>>([]);
    var isLoading = false.obs;
    @override
    void onInit() {
        super.onInit();
        spBranch.controller.disable();
    }
    @override
    void onReady() {
        super.onReady();
        spBranch.controller.setTextSelected(Constant.profileUser!.branch!.name!);
        getBranch();
    }

    void getBranch(){
        AuthImpl().get().then((auth) => {
            if (auth != null){
                spBranch.controller.showLoading(),
                Service.push(
                    apiKey: "api",
                    service: ListApi.getBranch,
                    context: context,
                    body: [
                        'Bearer ${auth.token}',
                        auth.id,
                        Constant.xAppId,
                    ],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            for (var result in (body as ListBranchResponse).data) {
                                listBranch.value.add(result);
                            }

                            Map<String, bool> mapList = {};
                            for (var branch in body.data) {
                                mapList[branch!.name!] = false;
                            }
                            spBranch.controller.generateItems(mapList);
                            spBranch.controller.hideLoading();
                            spBranch.controller.enable();
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                            spBranch.controller.hideLoading();
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                            spBranch.controller.hideLoading();
                        },
                            onTokenInvalid: () => Constant.invalidResponse()))
                    }
            else
                {Constant.invalidResponse()}
        });
    }

    void changeBranch(){
        Branch? branchSelected = listBranch.value.firstWhere((element) => element!.name == spBranch.controller.textSelected.value);
        Customer customer = Customer();
        customer.branchId = branchSelected!.id;
        AuthImpl().get().then((auth) => {
            if (auth != null){
                isLoading.value = true,
                Service.push(
                    service: ListApi.editUser,
                    context: context,
                    body: [
                        'Bearer ${auth.token}',
                        auth.id,
                        Constant.xAppId,
                        ListApi.pathEditUser(auth.id!),
                        Mapper.asJsonString(customer)
                    ],
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
                                backgroundColor: Colors.red,);
                            isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                            isLoading.value = false;
                        },
                            onTokenInvalid: () => Constant.invalidResponse()))
                    }
            else
                {Constant.invalidResponse()}
        });
    }    

    _showBottomDialog() {
          return showModalBottomSheet(
              isScrollControlled: true,
              useRootNavigator: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
              context: Get.context!,
              builder: (context) {
                  return Container(
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
                              Container(
                                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                                  child: Text(
                                      "Apakah kamu yakin data yang dimasukan sudah benar?",
                                      style: AppTextStyle.primaryTextStyle
                                          .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                                  ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                                  child: const Text(
                                      "Pastikan semua data yang kamu masukan semua sudah benar",
                                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 24),
                                child: Lottie.asset(
                                    'images/yakin.json',
                                    height: 140,
                                    width: 130,
                                    fit: BoxFit.cover,
                                )),
                              Container(
                                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                          Expanded(child: btYakin),
                                          const SizedBox(
                                              width: 16,
                                          ),
                                          Expanded(
                                              child: btTidakYakin,
                                          ),
                                      ],
                                  ),
                              ),
                              const SizedBox(height: Constant.bottomSheetMargin,)
                          ],
                      ),
                  );
              });
      }

}

class ChangeBranchBindings extends Bindings {
    BuildContext context;
    ChangeBranchBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => ChangeBranchController(context: context));
    }
}
