import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/custom_dialog.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/listener/custom_dialog_listener.dart';
import 'package:components/media_field/media_field.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/issue.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';

class IssueReportFormController extends GetxController {
  BuildContext context;
  IssueReportFormController({required this.context});

  Coop coop = Get.arguments[0] as Coop;
  RxList<Issue?> issueTypeList = <Issue?>[].obs;
  RxBool isLoadingPicture = false.obs;
  RxBool isLoading = false.obs;
  RxList<MediaUploadModel?> mediaListUpload = <MediaUploadModel?>[].obs;

  SpinnerField sfCategory = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("issueCategory"),
    label: "Kategori Isu",
    hint: "Pilih Kategori yang sesuai",
    alertText: "Category Perlu dipilih",
    items: const {},
    onSpinnerSelected: (value) {},
  );

  EditField efDescription = EditField(
    controller: GetXCreator.putEditFieldController("Deskripsi Isu Tambah"),
    label: "Deksripsi Isu",
    hint: "Tuliskan Deskripsi Isu",
    alertText: "",
    textUnit: "",
    onTyping: (value, control) {},
    maxInput: 500,
    inputType: TextInputType.multiline,
    height: 160,
  );

  late MediaField mfPhoto = MediaField(
    controller: GetXCreator.putMediaFieldController("photoInAddIssue"),
    onMediaResult: (media) => AuthImpl().get().then((auth) {
      if (auth != null) {
        if (media != null) {
          isLoadingPicture.value = true;
          Service.push(
              service: ListApi.uploadImage,
              context: Get.context!,
              body: ['Bearer ${auth.token}', auth.id, "issue", media],
              listener: ResponseListener(
                  onResponseDone: (code, message, body, id, packet) {
                    mediaListUpload.clear();
                    mediaListUpload.add(body.data);
                    mfPhoto.getController().setInformasiText("File telah terupload");
                    mfPhoto.getController().showInformation();
                    isLoadingPicture.value = false;
                  },
                  onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar("Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: Colors.red);

                    isLoadingPicture.value = false;
                  },
                  onResponseError: (exception, stacktrace, id, packet) {
                    Get.snackbar("Pesan", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: Colors.red);

                    isLoadingPicture.value = false;
                  },
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        }
      } else {
        GlobalVar.invalidResponse();
      }
    }),
    label: "Upload Foto Atau Video",
    hint: "Upload Foto Atau Video",
    alertText: "",
  );

  late ButtonFill btSave = ButtonFill(controller: GetXCreator.putButtonFillController("saveLaporIssue"), label: "Simpan", onClick: () => addIssue());
  ButtonOutline btCancel = ButtonOutline(controller: GetXCreator.putButtonOutlineController("cancelLaporIssue"), label: "Batal", onClick: () => Get.back());

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    getIssueTypes();
  }

  void getIssueTypes() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              Service.push(
                  apiKey: ApiMapping.api,
                  service: ListApi.issueTypes,
                  context: context,
                  body: ['Bearer ${auth.token}', auth.id, "v2/issues/types/${coop.farmingCycleId}"],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        issueTypeList.clear();
                        issueTypeList.value = body.data;
                        Map<String, bool> map = {};
                        for (var element in issueTypeList) {
                          map[element!.text!] = false;
                        }
                        sfCategory.getController().generateItems(map);
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

  bool validation() {
    bool isValid = true;
    // if (sfCategory.getController().textSelected.value.isEmpty) {
    //   isValid = false;
    //   sfCategory.getController().showAlert();
    // }
    if (efDescription.getInput().isEmpty) {
      isValid = false;
      efDescription.getController().showAlert();
    }
    if (mediaListUpload.isEmpty) {
      isValid = false;
      mfPhoto.getController().showAlert();
    }
    return isValid;
  }

  Issue generatePayload() {
    Issue? idType = issueTypeList.firstWhereOrNull((element) => element?.text == sfCategory.getController().textSelected.value);
    Issue issue = Issue(
      description: Uri.encodeFull(efDescription.getInput()),
      issueTypeId: idType?.id,
      photoValue: mediaListUpload,
      farmingCycleId: coop.farmingCycleId,
    );
    return issue;
  }

  void addIssue() {
    if (validation()) {
      AuthImpl().get().then((auth) => {
            isLoading.value = true,
            if (auth != null)
              {
                Service.push(
                    apiKey: ApiMapping.api,
                    service: ListApi.addIssue,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, Mapper.asJsonString(generatePayload())],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                          CustomDialog(Get.context!, Dialogs.YES_OPTION).title("Success!").message("Isu berhasil di kirim!").titleButtonOk("Penugasan").listener(CustomDialogListener(onDialogOk: (context, idx, list) => Get.back(), onDialogCancel: (context, idx, list) {})).show();
                        },
                        onResponseFail: (code, message, body, id, packet) {
                          CustomDialog(Get.context!, Dialogs.YES_OPTION)
                              .title("Error!")
                              .message(
                                "${(body).error!.message}",
                              )
                              .titleButtonOk("Tutup")
                              .listener(CustomDialogListener(
                                  onDialogOk: (context, idx, list) {
                                    Get.back();
                                  },
                                  onDialogCancel: (context, idx, list) {}))
                              .show();
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
}

class IssueReportFormBindings extends Bindings {
  BuildContext context;
  IssueReportFormBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => IssueReportFormController(context: context));
  }
}
