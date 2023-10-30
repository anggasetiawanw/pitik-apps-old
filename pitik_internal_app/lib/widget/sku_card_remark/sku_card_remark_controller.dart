import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/internal_app/category_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 27/05/23

class SkuCardRemarkController extends GetxController {
  String tag;
  BuildContext context;
  SkuCardRemarkController({required this.tag, required this.context});

  Rx<List<int>> index = Rx<List<int>>([]);
  Rx<List<SpinnerField>> spinnerCategories = Rx<List<SpinnerField>>([]);
  Rx<List<SpinnerField>> spinnerTypePotongan = Rx<List<SpinnerField>>([]);
  Rx<List<EditField>> editFieldJumlahAyam = Rx<List<EditField>>([]);
  Rx<List<EditField>> editFieldPotongan = Rx<List<EditField>>([]);
  Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);

  var itemCount = 0.obs;
  var expanded = false.obs;
  var isShow = true.obs;
  var isLoadApi = false.obs;

  void expand() => expanded.value = true;
  void collapse() => expanded.value = false;
  void visibleCard() => isShow.value = true;
  void invisibleCard() => isShow.value = false;

  var idx = 0.obs;

  @override
  void onInit() {
    super.onInit();
    addCard();
  }

  addCard() {
    index.value.add(idx.value);
    int numberList = idx.value;

    spinnerCategories.value.add(
      SpinnerField(
          controller: GetXCreator.putSpinnerFieldController("spin${numberList}Remark"),
          label: "Kategori SKU*",
          hint: "Pilih Salah Satu",
          alertText: "Kategori SKU harus dipilih!",
          items: const {},
          onSpinnerSelected: (value) {
            try {
              if (listCategories.value.isNotEmpty) {
                CategoryModel? selectCategory = listCategories.value.firstWhereOrNull((element) => element!.name! == value);
                if (selectCategory != null) {
                  if (spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.LIVE_BIRD || spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.AYAM_UTUH || spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.BRANGKAS || spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.KARKAS) {
                    editFieldJumlahAyam.value[numberList].controller.enable();
                  } else {
                    editFieldJumlahAyam.value[numberList].controller.disable();
                  }
                  editFieldJumlahAyam.value[numberList].setInput("");
                }
              }
            } catch (e, st) {
              Get.snackbar("Error", "$e $st");
            }
          }),
    );

    spinnerTypePotongan.value.add(
      SpinnerField(
          controller: GetXCreator.putSpinnerFieldController("spinTypePotongan${numberList}Remark"),
          label: "Jenis Potongan",
          hint: "Pilih Salah Satu",
          alertText: "Jenis Potongan Harus Dipilih",
          items: const {
            "Potong Biasa": false,
            "Bekakak": false,
          },
          onSpinnerSelected: (value) {
            if (value == "Potong Biasa") {
              editFieldPotongan.value[numberList].controller.visibleField();
            } else {
              editFieldPotongan.value[numberList].controller.invisibleField();
            }
          }),
    );

    editFieldJumlahAyam.value.add(EditField(controller: GetXCreator.putEditFieldController("editJumlah${numberList}Remark"), label: "Jumlah Ekor", hint: "Ketik di sini", alertText: "Kolom Ini Harus Di Isi", textUnit: "Ekor", inputType: TextInputType.number, maxInput: 20, onTyping: (value, control) {}));

    editFieldPotongan.value.add(EditField(controller: GetXCreator.putEditFieldController("editPotongan${numberList}Remark"), label: "Potongan", hint: "Ketik di sini", alertText: "Kolom Ini Harus Di Isi", textUnit: "Potongan", inputType: TextInputType.number, maxInput: 20, onTyping: (value, control) {}));

    itemCount.value = index.value.length;
    editFieldPotongan.value[numberList].controller.invisibleField();
    idx.value++;
  }

  removeCard(int idx) {
    index.value.removeWhere((item) => item == idx);
    itemCount.value = index.value.length;
  }

  setMaplist(List<CategoryModel?> map) {
    listCategories.value = map;
  }

  List validation() {
    bool isValid = true;
    String error = "";
    final temp = <String>[];
    for (int i = 0; i < index.value.length; i++) {
      int whichItem = index.value[i];
      if (spinnerCategories.value[whichItem].controller.textSelected.value.isEmpty) {
        spinnerCategories.value[whichItem].controller.showAlert();
        Scrollable.ensureVisible(spinnerCategories.value[whichItem].controller.formKey.currentContext!);
        isValid = false;
        return [isValid, error];
      }

      if (spinnerCategories.value[whichItem].controller.textSelected.value == AppStrings.AYAM_UTUH || spinnerCategories.value[whichItem].controller.textSelected.value == AppStrings.BRANGKAS || spinnerCategories.value[whichItem].controller.textSelected.value == AppStrings.LIVE_BIRD) {
        if (editFieldJumlahAyam.value[whichItem].getInput().isEmpty) {
          editFieldJumlahAyam.value[whichItem].controller.showAlert();
          Scrollable.ensureVisible(editFieldJumlahAyam.value[whichItem].controller.formKey.currentContext!);

          isValid = false;
          return [isValid, error];
        }

        if (editFieldPotongan.value[whichItem].getInput().isEmpty) {
          editFieldPotongan.value[whichItem].controller.showAlert();
          Scrollable.ensureVisible(editFieldPotongan.value[whichItem].controller.formKey.currentContext!);

          isValid = false;
          return [isValid, error];
        }
      }

      if (temp.contains(spinnerCategories.value[whichItem].controller.textSelected.value)) {
        for (int j = 0; j < index.value.length; j++) {
          int whereItem = index.value[j];
          if ((spinnerCategories.value[whereItem].controller.textSelected.value == spinnerCategories.value[whichItem].controller.textSelected.value) && (whereItem != whichItem)) {
            // if(spinnerSku.value[whereItem].controller.textSelected.value == spinnerSku.value[whichItem].controller.textSelected.value){
            //     error = spinnerSku.value[whichItem].controller.textSelected.value;
            //         spinnerSku.value[whichItem].controller
            //             ..alertText.value = "Duplikat Jenis Ukuran  $error"
            //             ..showAlert();

            //         spinnerSku.value[whereItem].controller
            //             ..alertText.value = "Duplikat Jenis Ukuran $error"
            //             ..showAlert();
            //             Scrollable.ensureVisible(spinnerSku.value[whichItem].controller.formKey.currentContext!);

            //         Get.snackbar(
            //             "Alert", "Duplikat Jenis Ukuran  $error",
            //             snackPosition: SnackPosition.TOP,
            //             backgroundColor: Colors.red,
            //             duration: const Duration(seconds: 5),
            //             colorText: Colors.white
            //         );
            //         isValid = false;
            //         return [isValid, error];
            // } else {
            //     spinnerSku.value[whereItem].controller.hideAlert();
            //     spinnerSku.value[whichItem].controller.hideAlert();
            // }
            error = spinnerCategories.value[whichItem].controller.textSelected.value;
            spinnerCategories.value[whichItem].controller
              ..alertText.value = "Duplikat Kategori SKU $error"
              ..showAlert();
            spinnerCategories.value[whereItem].controller
              ..alertText.value = "Duplikat Kategori SKU $error"
              ..showAlert();
            Get.snackbar("Alert", "Duplikat Jenis Ukuran  $error", snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, duration: const Duration(seconds: 3), colorText: Colors.white);
            Scrollable.ensureVisible(spinnerCategories.value[whichItem].controller.formKey.currentContext!);
          } else {
            spinnerCategories.value[whereItem].controller.hideAlert();
            spinnerCategories.value[whichItem].controller.hideAlert();
          }
        }
      } else {
        temp.add(spinnerCategories.value[whichItem].controller.textSelected.value);
      }
    }

    return [isValid, error];
  }
}

class SkuCardRemarkBinding extends Bindings {
  String tag;
  BuildContext context;

  SkuCardRemarkBinding({required this.tag, required this.context});

  @override
  void dependencies() {
    Get.lazyPut<SkuCardRemarkController>(() => SkuCardRemarkController(tag: tag, context: context));
  }
}
