import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NetworkErrorItem extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return WillPopScope(child:Scaffold(
            body: Container(
                height: Get.height, //Get.height = MediaQuery.of(context).size.height
                width: Get.width, //Get.width = MediaQuery.of(context).size.width
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        SvgPicture.asset("images/internet_na.svg", height: 120, width: 120,),
                        const SizedBox(height: 30),
                        const Text(
                            'Oops.. koneksi internet terputus',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const Text(
                            'periksa koneksimu dan coba lagi',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                    ],
                ),
            ),
        ), onWillPop: () async => false );
    }
}