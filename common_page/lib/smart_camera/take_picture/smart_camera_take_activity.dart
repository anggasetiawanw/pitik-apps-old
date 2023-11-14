
import 'package:common_page/smart_camera/take_picture/smart_camera_take_controller.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 10/11/2023

class SmartCameraTakeActivity extends GetView<SmartCameraTakeController> {
    const SmartCameraTakeActivity({super.key});

    @override
    Widget build(BuildContext context) {
        SmartCameraTakeController controller = Get.put(SmartCameraTakeController(context: context));
        return SafeArea(
            child: Obx(() =>
                Scaffold(
                    backgroundColor: Colors.white,
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: AppBarFormForCoop(
                            title: 'Smart Camera',
                            coop: controller.coop,
                            hideCoopDetail: true,
                        ),
                    ),
                    body: controller.recordImages.isEmpty ? Center(
                            child: Container(
                                width: double.infinity,
                                height: MediaQuery. of(context). size. height,
                                margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                                child: Column(
                                    children: [
                                        SvgPicture.asset("images/empty_icon.svg"),
                                        const SizedBox(height: 17),
                                        Text("Data Camera Belum Ada", textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium))
                                    ]
                                )
                            )
                        ) :
                        Column(
                            children: [
                                const SizedBox(height: 16),
                                Container(
                                    decoration: BoxDecoration(
                                        color: GlobalVar.primaryLight,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    padding: const EdgeInsets.all(12),
                                    child : Column(
                                        children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Expanded(child: Text("Detail Gambar ", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium))),
                                                ]
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Expanded(child: Text("Total Gambar", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)),
                                                    Text("${controller.totalCamera}", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium), overflow: TextOverflow.clip)
                                                ]
                                            )
                                        ]
                                    )
                                ),
                                Expanded(child: controller.listRecordCamera())
                            ]
                        )
                )
            )
        );
    }
}