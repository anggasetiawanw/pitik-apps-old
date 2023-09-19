import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/07/23


class NetworkErrorItem extends StatelessWidget {
  const NetworkErrorItem({super.key});

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
                        Icon(Icons.wifi, size: 200, color: GlobalVar.primaryOrange,),
                        const SizedBox(height: 30),
                        const Text(
                            'Sedang tidak ada jaringan',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const Text(
                            'Periksa kembali koneksi internet kamu !',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                    ],
                ),
            ),
        );
    }
}