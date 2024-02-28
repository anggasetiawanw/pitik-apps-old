// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/convert.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class NetworkErrorItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height, //Get.height = MediaQuery.of(context).size.height
        width: Get.width, //Get.width = MediaQuery.of(context).size.width
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi, size: 200, color: Convert.hexToColor("#F47B20")),
            const SizedBox(height: 30),
            const Text(
              'Internet connection lost!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Text(
              'Check your connection and try again.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
