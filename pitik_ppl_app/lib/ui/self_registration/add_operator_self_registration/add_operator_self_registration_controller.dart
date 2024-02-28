import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/custom_dialog.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/listener/custom_dialog_listener.dart';
import 'package:components/password_field/password_field.dart';
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
import 'package:model/profile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api_mapping/api_mapping.dart';

class AddOperatorSelfRegistrationController extends GetxController {
  BuildContext context;
  AddOperatorSelfRegistrationController({required this.context});
  Coop coop = Coop();
  RxBool isLoading = false.obs;

  EditField efHandphoneNumber = EditField(
    controller: GetXCreator.putEditFieldController('efHandphoneNumber'),
    label: 'Username (No. Handphone & No. WhatsApp)*',
    hint: '08xxxxxxxxxxxxx',
    alertText: 'Nomor handphone Wa harus diisi',
    textUnit: '',
    maxInput: 20,
    inputType: TextInputType.number,
    onTyping: (value, controller) {},
  );

  EditField efOperatorName = EditField(
    controller: GetXCreator.putEditFieldController('efOperatorName'),
    label: 'Nama Operator*',
    hint: 'Ketik disini',
    alertText: 'Nama Operator harus diisi',
    textUnit: '',
    maxInput: 20,
    onTyping: (value, controller) {},
  );

  SpinnerField efTask = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController('efTask'),
    label: 'Tugas*',
    hint: 'Pilih disini',
    alertText: 'Tugas harus diisi',
    items: const {
      'Kepala Kandang': false,
      'Anak Kandang': false,
    },
    onSpinnerSelected: (value) {},
  );

  PasswordField efPassword = PasswordField(
    controller: GetXCreator.putPasswordFieldController('efPassword'),
    label: 'Kata Sandi*',
    hint: 'Ketik disini',
    alertText: 'Kata Sandi harus diisi',
    maxInput: 20,
    onTyping: (value) {},
  );

  late PasswordField efConfirmPassword = PasswordField(
    controller: GetXCreator.putPasswordFieldController('efConfirmPassword'),
    label: 'Konfirmasi Kata Sandi*',
    hint: 'Ketik disini',
    alertText: 'Konfirmasi Kata Sandi harus diisi',
    maxInput: 20,
    onTyping: (value) {
      efConfirmPassword.controller.alertText.value = 'Konfirmasi Kata Sandi harus diisi';
    },
  );

  late ButtonFill btnSubmit = ButtonFill(
    controller: GetXCreator.putButtonFillController('btnSubmit'),
    label: 'Buat Akun',
    onClick: () {
      if (validation()) {
        submit();
      }
    },
  );

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0] as Coop;
  }

  bool validation() {
    bool isValid = true;
    if (efHandphoneNumber.getInput().isEmpty) {
      efHandphoneNumber.controller.showAlert();
      Scrollable.ensureVisible(efHandphoneNumber.controller.formKey.currentContext!);
      isValid = false;
    }
    if (efOperatorName.getInput().isEmpty) {
      efOperatorName.controller.showAlert();
      Scrollable.ensureVisible(efOperatorName.controller.formKey.currentContext!);
      isValid = false;
    }
    if (efTask.controller.textSelected.isEmpty) {
      efTask.controller.showAlert();
      Scrollable.ensureVisible(efTask.controller.formKey.currentContext!);
      efTask.controller.update();
      isValid = false;
    }
    if (efPassword.getInput().isEmpty) {
      efPassword.controller.showAlert();
      efPassword.controller.update();
      isValid = false;
    }
    if (efConfirmPassword.getInput().isEmpty) {
      efConfirmPassword.controller.showAlert();
      efConfirmPassword.controller.update();
      isValid = false;
    }

    if (efPassword.getInput() != efConfirmPassword.getInput()) {
      efConfirmPassword.controller.alertText.value = 'Kata Sandi tidak sama';
      efConfirmPassword.controller.showAlert();
      efConfirmPassword.controller.update();
      isValid = false;
    }
    return isValid;
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
                          Text('Apakah yakin data yang kamu masukan sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                          const SizedBox(height: 16),
                          Text('Kandang ${coop.coopName}', style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold)),
                          const SizedBox(height: 8),
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Username/No. Handphone', style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                    const SizedBox(width: 8),
                                    Text(efHandphoneNumber.getInput(), style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Nama Operator', style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                    const SizedBox(width: 8),
                                    Text(efOperatorName.getInput(), style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tugas', style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                    const SizedBox(width: 8),
                                    Text(efTask.controller.textSelected.value, style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                  child: ButtonFill(
                                      controller: GetXCreator.putButtonFillController('YakinAddOp'),
                                      label: 'Yakin',
                                      onClick: () {
                                        Get.back();
                                        addOperator(auth.token!, auth.id!);
                                      })),
                              const SizedBox(width: 8),
                              Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController('TidakYakinAddOperator'), label: 'Tidak Yakin', onClick: () => Get.back())),
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

  void addOperator(String token, String id) {
    isLoading.value = true;
    Service.push(
        apiKey: ApiMapping.api,
        service: ListApi.addOperator,
        context: context,
        body: ['Bearer $token', id, 'v2/self-registration/coop-operator', Mapper.asJsonString(generatePayload())],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Get.off(
                TransactionSuccessActivity(
                  keyPage: 'addOperator',
                  message: 'Selamat kamu berhasil melakukan penugasan kepada operator kandang',
                  showButtonHome: false,
                  onTapClose: () {
                    Get.back();
                    Get.back();
                  },
                  onTapHome: () {},
                ),
              );
            },
            onResponseFail: (code, message, body, id, packet) {
              if ((body as ErrorResponse).error!.name == 'BAD_REQUEST_SELF_REGISTRATION_1') {
                CustomDialog(Get.context!, Dialogs.YES_OPTION)
                    .title('Perhatian!')
                    .message(
                      '${body.error!.message}',
                    )
                    .titleButtonOk('Penugasan')
                    .listener(CustomDialogListener(
                        onDialogOk: (context, idx, list) {
                          Get.back();
                        },
                        onDialogCancel: (context, idx, list) {}))
                    .show();
              } else if (body.error!.name == 'BAD_REQUEST_SELF_REGISTRATION_2') {
                CustomDialog(context, Dialogs.YES_OPTION)
                    .title('Perhatian!')
                    .message(
                      '${body.error!.message}',
                    )
                    .titleButtonOk('Chat WA')
                    .listener(CustomDialogListener(
                        onDialogOk: (context, idx, list) async {
                          final String getUrl =
                              'https://api.whatsapp.com/send?phone=6281280709907&text=saya ${GlobalVar.profileUser?.fullName} pemilik kandang ${coop.coopName}. Mohon bantuannya untuk membuat akun operator kandang saya karena saya telah memiliki >10 operator kandang. Terima kasih.';
                          final Uri url = Uri.parse(Uri.encodeFull(getUrl));
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Could not launch $url');
                          }
                          Get.back();
                        },
                        onDialogCancel: (context, idx, list) {}))
                    .show();
              } else {
                Get.snackbar(
                  'Pesan',
                  'Terjadi Kesalahan, ${body.error!.message}',
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
                isLoading.value = false;
                Get.back();
                Get.back();
              }
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan Internal',
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
              Get.back();
              Get.back();
            },
            onTokenInvalid: () => GlobalVar.invalidResponse()));
  }

  Profile generatePayload() {
    final Profile profile = Profile();
    profile.farmingCycleId = coop.farmingCycleId;
    profile.fullName = efOperatorName.getInput();
    profile.phoneNumber = efHandphoneNumber.getInput();
    profile.role = efTask.controller.textSelected.value;
    profile.password = efPassword.getInput();
    return profile;
  }
}

class AddOperatorSelfRegistrationBindings extends Bindings {
  BuildContext context;
  AddOperatorSelfRegistrationBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => AddOperatorSelfRegistrationController(context: context));
  }
}
