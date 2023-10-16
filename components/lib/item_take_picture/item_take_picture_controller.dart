
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'dart:async';

import 'package:components/global_var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    Rx<Widget> image = Image.network(
        "",
        fit: BoxFit.fill,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
                child: CircularProgressIndicator(
                    color: GlobalVar.primaryOrange,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                )
            );
            },
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return SizedBox(
                width: double.infinity,
                height: 210,
                child:  Center(
                    child: CircularProgressIndicator(
                        color: GlobalVar.primaryOrange,
                    )
                ),
            );
            },
    ).obs;

    Rx<FadeInImage> fadeImage = FadeInImage(
        width: double.infinity,
        height: 210,
        image: AssetImage('images/bc_image.png'),
        placeholder: AssetImage('images/bc_image.png'),
        imageErrorBuilder:
            (context, error, stackTrace) {
            return Image.asset('images/bc_image.png', fit: BoxFit.cover);
    },
    fit: BoxFit.fill,
    ).obs;

    Future<bool> isValidUrl(Uri imageUrl) async{
        var response = await http.get(imageUrl);
        if(response.statusCode != 200){
            return false;
        }
        return true;
    }

    void reloadCheckUrl(String url){
        Timer(const Duration(milliseconds: 5000), () async {
            final uri = Uri.parse(url);
            if(await isValidUrl(uri)){
                image.value = Image.network(
                            url,
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: GlobalVar.primaryOrange,
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                    )
                                );
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return SizedBox(
                                    width: double.infinity,
                                    height: 210,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Center(
                                                child: CircularProgressIndicator(
                                                    color: GlobalVar.primaryOrange,
                                                )
                                            ),
                                        ],
                                ),
                                );
                            },
                        );
            }else{
                tryCount++;
                if(tryCount <= 10){
                    reloadCheckUrl(url);
                }else{
                    image.value = Image.network(
                        url,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child: CircularProgressIndicator(
                                    color: GlobalVar.primaryOrange,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                )
                            );
                        },
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return SizedBox(
                                width: double.infinity,
                                height: 210,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        SvgPicture.asset("images/wifi_off_icon.svg"),
                                        Text(
                                            "Koneksi terputus gagal mengambil gambar",
                                            style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.medium)
                                        ),
                                    ],
                                ),
                            );
                        },
                    );

                }
            }
        });
    }

    void loadUrlImage(String url){
        reloadCheckUrl(url);
        // Scheduler scheduler = Scheduler();
        // scheduler.maxRetry(4).listener(SchedulerListener(
        //     onTick: (packet) {
        //         // fadeImage.value = FadeInImage.assetNetwork(
        //         //     width: double.infinity,
        //         //     height: 210,
        //         //     image: url,
        //         //     placeholder: 'images/bc_image.png',
        //         //     imageErrorBuilder:
        //         //         (context, error, stackTrace) {
        //         //         return Image.asset('images/bc_image.png', fit: BoxFit.cover);
        //         //     },
        //         //     fit: BoxFit.fill,
        //         // );
        //         // fadeImage.refresh();
        //         // return true;
        //
        //         final uri = Uri.parse(url);
        //         isValidUrl(uri);
        //
        //         // image.value = Image.network(
        //         //     url,
        //         //     fit: BoxFit.fill,
        //         //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        //         //         if (loadingProgress == null) return child;
        //         //         return Center(
        //         //             child: CircularProgressIndicator(
        //         //                 color: GlobalVar.primaryOrange,
        //         //                 value: loadingProgress.expectedTotalBytes != null
        //         //                     ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
        //         //                     : null,
        //         //             )
        //         //         );
        //         //     },
        //         //     errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        //         //         return const SizedBox(
        //         //             width: double.infinity,
        //         //             height: 210
        //         //         );
        //         //     },
        //         // );
        //         image.refresh();
        //         return true;
        //     },
        //     onTickDone: (packet) {
        //         print("object TICKKKDONE $url");
        //         image.refresh();},
        //     onTickFail: (packet) {}
        // )).run(const Duration(seconds: 10));
    }


    @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
    @override
    void onReady() {
    // TODO: implement onReady
    super.onReady();
    // if(tryCount <=0 ){
    //     reloadTime();
    // }
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
