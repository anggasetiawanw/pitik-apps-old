import 'package:common_page/library/component_library.dart';
import 'package:common_page/transaction_success_activity.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:model/error/error.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 19/02/2024

class RegisterController extends GetxController {
  BuildContext context;
  RegisterController({required this.context});

  EditField efFullName = EditField(controller: GetXCreator.putEditFieldController('registerFullName'), label: 'Nama Lengkap', hint: 'Tuliskan nama lengkap', alertText: 'Harus diisi..!', textUnit: '', maxInput: 100, onTyping: (text, field) {});

  EditField efEmail = EditField(
      controller: GetXCreator.putEditFieldController('registerEmail'),
      label: 'Email',
      hint: 'Tuliskan alamat email yang digunakan',
      alertText: 'Harus diisi..!',
      textUnit: '',
      maxInput: 100,
      inputType: TextInputType.emailAddress,
      onTyping: (text, field) {});

  EditField efPhoneNumber = EditField(
      controller: GetXCreator.putEditFieldController('registerPhoneNumber'),
      label: 'Nomor Handphone',
      hint: 'Nomor handphone yang digunakan',
      alertText: 'Harus diisi..!',
      textUnit: '',
      maxInput: 16,
      inputType: TextInputType.phone,
      onTyping: (text, field) {});

  EditField efBusinessYear = EditField(
      controller: GetXCreator.putEditFieldController('registerBusinessYear'),
      label: 'Sudah berapa lama memiliki usaha peternakan?',
      hint: 'Lama usaha peternakan',
      alertText: 'Harus diisi..!',
      textUnit: 'Tahun',
      maxInput: 10,
      inputType: TextInputType.number,
      onTyping: (text, field) {});

  EditField efCoopCapacity = EditField(
      controller: GetXCreator.putEditFieldController('registerCoopCapacity'),
      label: 'Kapasitas Kandang',
      hint: 'Tuliskan jumlah kapasitas kandang',
      alertText: 'Harus diisi..!',
      textUnit: 'Ekor',
      maxInput: 20,
      inputType: TextInputType.number,
      onTyping: (text, field) {});

  EditField efLocation =
      EditField(controller: GetXCreator.putEditFieldController('registerLocation'), label: 'Lokasi Kandang', hint: 'Pegunungan, permukiman penduduk...', alertText: 'Harus diisi..!', textUnit: '', maxInput: 200, onTyping: (text, field) {});

  EditField efAddress = EditField(controller: GetXCreator.putEditFieldController('registerAddress'), label: 'Alamat', hint: 'Tuliskan alamat kandang', alertText: 'Harus diisi..!', textUnit: '', maxInput: 200, onTyping: (text, field) {});

  EditField efProvince = EditField(controller: GetXCreator.putEditFieldController('registerProvince'), label: 'Provinsi', hint: 'Tuliskan nama provinsi', alertText: 'Harus diisi..!', textUnit: '', maxInput: 200, onTyping: (text, field) {});

  EditField efCity = EditField(controller: GetXCreator.putEditFieldController('registerCity'), label: 'Kota/Kabupaten', hint: 'Tuliskan nama kota/kabupaten', alertText: 'Harus diisi..!', textUnit: '', maxInput: 200, onTyping: (text, field) {});

  TextEditingController googlePlaceController = TextEditingController();
  late GooglePlaceAutoCompleteTextField googlePlaceAutoCompleteTextField;

  var coopTypeState = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    String pushText = "AIzaSyAhvl6";
    String pushTextNext = "CLduhTKTTI";
    String pushTextNextAgain = "zB7ieVfrey";
    String pushTextLast = "HrFJxC6U";

    googlePlaceAutoCompleteTextField = GooglePlaceAutoCompleteTextField(
      textEditingController: googlePlaceController,
      googleAPIKey: "$pushText$pushTextNext$pushTextNextAgain$pushTextLast",
      boxDecoration: const BoxDecoration(color: GlobalVar.primaryLight),
      inputDecoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        counterText: "",
        hintText: 'Cari nama kecamatan',
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9E9D9D)),
        fillColor: GlobalVar.primaryLight,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: GlobalVar.primaryOrange,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: GlobalVar.primaryLight,
              width: 2.0,
            )),
        filled: true,
      ),
      debounceTime: 400,
      countries: const ["id"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {},
      itemClick: (Prediction prediction) {
        googlePlaceController.text = prediction.terms!.length == 4
            ? prediction.terms![0].value ?? ''
            : prediction.terms!.length == 5
                ? prediction.terms![1].value ?? ''
                : prediction.terms![2].value ?? '';
        efCity.setInput(prediction.terms!.length == 4
            ? prediction.terms![1].value ?? ''
            : prediction.terms!.length == 5
                ? prediction.terms![2].value ?? ''
                : prediction.terms![3].value ?? '');
        efProvince.setInput(prediction.terms!.length == 4
            ? prediction.terms![2].value ?? ''
            : prediction.terms!.length == 5
                ? prediction.terms![3].value ?? ''
                : prediction.terms![4].value ?? '');
      },
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [const Icon(Icons.location_on), const SizedBox(width: 7), Expanded(child: Text(prediction.description ?? ""))],
          ),
        );
      },
      isCrossBtnShown: false,
    );
  }

  void saveRegister() {
    isLoading.value = true;
    Service.push(
        apiKey: 'userApi',
        service: ListApi.register,
        context: context,
        body: [
          efFullName.getInput(),
          efEmail.getInput(),
          efPhoneNumber.getInput(),
          efBusinessYear.getInputNumber(),
          coopTypeState.value,
          efCoopCapacity.getInputNumber(),
          efLocation.getInput(),
          efAddress.getInput(),
          efCity.getInput(),
          efProvince.getInput(),
          googlePlaceController.text
        ],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              isLoading.value = false;
              Get.off(TransactionSuccessActivity(keyPage: "registerSuccess", message: "Terima Kasih Telah Mendaftar Menjadi Kawan Pitik", showButtonHome: false, onTapClose: () => Get.back(), onTapHome: () {}));
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
            onTokenInvalid: () => GlobalVar.invalidResponse()));
  }
}

class RegisterBinding extends Bindings {
  BuildContext context;
  RegisterBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<RegisterController>(() => RegisterController(context: context));
}
