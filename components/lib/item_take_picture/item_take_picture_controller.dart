
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'dart:async';

import 'package:components/global_var.dart';
import 'package:engine/util/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ItemTakePictureCameraController extends GetxController {
    String tag;
    BuildContext context;
    ItemTakePictureCameraController({required this.tag, required this.context});

    var isShow = false.obs;
    var tryCount = 0.obs;

    late Scheduler scheduler;
    late String url;

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
            return const SizedBox(
                width: double.infinity,
                height: 210,
                child:  Center(
                    child: CircularProgressIndicator(
                        color: GlobalVar.primaryOrange,
                    )
                )
            );
        },
    ).obs;

    Future<bool> isValidUrl(Uri imageUrl) async {
        var response = await http.get(imageUrl);
        if (response.statusCode != 200) {
            return false;
        }

        return true;
    }

    void loadImage(String url) {
        Timer(const Duration(seconds: 6), () async {
            final uri = Uri.parse(url);
            if (await isValidUrl(uri)) {
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
                        return const SizedBox(
                            width: double.infinity,
                            height: 210,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Center(
                                        child: CircularProgressIndicator(color: GlobalVar.primaryOrange)
                                    ),
                                ],
                        ),
                        );
                    },
                );
            } else {
                tryCount++;
                if (tryCount <= 10) {
                    loadImage(url);
                } else {
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
                                        )
                                    ]
                                )
                            );
                        }
                    );
                }
            }
        });
    }
}

class ItemTakePictureCameraBindings extends Bindings {
    String tag;
    BuildContext context;
    ItemTakePictureCameraBindings({required this.tag, required this.context});

    @override
    void dependencies() => Get.lazyPut<ItemTakePictureCameraController>(() => ItemTakePictureCameraController(tag: tag, context: context));
}
