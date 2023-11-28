
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/item_take_picture/item_take_picture.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_connect/ui/detail_smartcamera/take_picture_result/take_picture_result_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 28/08/23

class TakePictureResult extends GetView<TakePictureResultController>{
    const TakePictureResult({
        super.key
    });

    @override
    Widget build(BuildContext context) {
        final TakePictureResultController controller = Get.put(TakePictureResultController(
            context: context,
        ));

        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back()),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title: Text(
                    "Ambil Gambar",
                    style: GlobalVar.whiteTextStyle
                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),),
            );
        }

        Widget listRecordCamera(){
            return  ListView.builder(
                controller: controller.scrollCameraController,
                itemCount: controller.isLoadMore.isTrue
                    ? controller.recordImages.value.length + 1
                    : controller.recordImages.value.length,
                itemBuilder: (context, index) {
                    int length = controller.recordImages.value.length;
                    if (index >= length) {
                        return const Column(
                            children: [
                                Center(
                                    child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: ProgressLoading(
                                        ),
                                    ),
                                ),
                                SizedBox(height: 120),
                            ],
                        );
                    }
                    return Stack(
                        children: [
                            ListTile(
                                title: Column(
                                    children: [
                                        ItemTakePictureCamera(
                                            controller: GetXCreator.putItemTakePictureController("ItemTakePictureCamera${index}",context),
                                            recordCamera: controller.recordImages.value[index],
                                            index: index,
                                            onOptionTap: () {
                                                // _showButtonDialog(context, controller);
                                            },
                                        ),
                                        index == controller.recordImages.value.length - 1 ? const SizedBox(height: 120)
                                            : Container(),
                                    ],
                                ), // </Add>
                            ),
                        ],

                        );
                    },
            );
        }

        return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: appBar(),),
            body: Stack(
                children: [
                Obx(() =>
                controller.isLoading.isTrue ?
                const Center(
                    child:
                    ProgressLoading(),) :
                controller.recordImages.value.isEmpty ?   Center(
                    child: Container(
                        width: double.infinity,
                        height: MediaQuery. of(context). size. height,
                        margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                        child: Column(
                            children: [
                                SvgPicture.asset("images/empty_icon.svg"),
                                const SizedBox(
                                    height: 17,),
                                Text("Data Camera Belum Ada",
                                    textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)
                            ],
                        ),
                    )
                ) :                     Column(
                    children: [
                        const SizedBox(
                            height: 16,),
                        Container(
                            decoration: BoxDecoration(
                                color: GlobalVar.primaryLight,
                                borderRadius: BorderRadius.circular(8)),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            child : Column(
                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(child: Text("Detail Gambar ", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium))),
                                          ],),
                                    const SizedBox(
                                        height: 12,),
                                    Obx(() => controller.isLoading.isTrue ? Container()
                                        : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(child: Text("Total Gambar", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)),
                                            Text("${controller.totalCamera}", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium), overflow: TextOverflow.clip)
                                        ],
                                    ))
                                ]
                            ),
                        ),
                        // Container(
                        //     margin: EdgeInsets.only(right: 16, left: 16),
                        //     child:
                        //     controller.dtftakePicture),
                        Expanded(child: listRecordCamera())
                    ],
                ),
                ),
                    // bottomNavBar()
                ],
            ),
        );


    }

}
