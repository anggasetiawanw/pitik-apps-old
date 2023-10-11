
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../edit_field/edit_field.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ItemTakePictureCameraController extends GetxController {
    String tag;
    BuildContext context;
    ItemTakePictureCameraController({required this.tag, required this.context});

    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<EditField>> efDayTotal = Rx<List<EditField>>([]);
    Rx<List<EditField>> efDecreaseTemp = Rx<List<EditField>>([]);

    var itemCount = 0.obs;
    var expanded = false.obs;
    var isShow = false.obs;
    var isLoadApi = false.obs;
    var numberList = 0.obs;
    var tryCount = 0.obs;
    var isImageLoaded = false.obs;
    var reloadUrl = false.obs;

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;
    void visibleCard() => isShow.value = true;
    void invisibleCard() => isShow.value = false;

    void reloadTime(){
        // reloadUrl.value = true;
        print("TIMER HIHI ${reloadUrl.value}");
        if(tryCount.value < 5) {
          Timer(const Duration(milliseconds: 10000), () {
              reloadUrl.value = true;
              print("TIMER HOHO ${reloadUrl.value}");
              print("TIMER HUUUA ${tryCount}");
              tryCount.value += 1;
              reloadTime();
        });
        }
    }

    // Future<bool> isValidUrl(Uri imageUrl) async{
    //     var response = await http.get(imageUrl);
    //     if(response.statusCode != 200){
    //         Get.snackbar(
    //             "Pesan", "Gambar belum tersedia!",
    //             snackPosition: SnackPosition.BOTTOM,
    //             colorText: Colors.white,
    //             duration: const Duration(seconds: 5),
    //             backgroundColor: Colors.red,
    //         );
    //         return false;
    //     }
    //     return true;
    // }

    @override
    void onReady() {
    // TODO: implement onReady
    super.onReady();
    if(tryCount <=0 ){
        reloadTime();
    }
  }
}

class ItemTakePictureCameraBindings extends Bindings {
    String tag;
    BuildContext context;
    ItemTakePictureCameraBindings({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ItemTakePictureCameraController>(() => ItemTakePictureCameraController(tag: tag, context: context));
    }
}
