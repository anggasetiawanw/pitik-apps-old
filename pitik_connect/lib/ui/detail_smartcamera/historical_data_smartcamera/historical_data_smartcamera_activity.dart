
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/item_historical_smartcamera/item_historical_smartcamera.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'historical_data_smartcamera_controller.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 18/08/23
 */

class HistoricalDataSmartCamera extends GetView<HistoricalDataSmartCameraController>{
    const HistoricalDataSmartCamera({
        super.key
    });

    @override
    Widget build(BuildContext context) {
        final HistoricalDataSmartCameraController controller = Get.put(HistoricalDataSmartCameraController(
            context: context,
        ));

        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back()),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title: Text(
                    "Kamera ${controller.indeksCamera}",
                    style: GlobalVar.whiteTextStyle
                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),),
            );
        }

        Widget listRecordCamera(){
            return  Container(
                child: ListView.builder(
                    controller: controller.scrollCameraController,
                    itemCount: controller.isLoadMore.isTrue
                        ? controller.recordImages.value.length + 1
                        : controller.recordImages.value.length,
                    itemBuilder: (context, index) {
                        int length = controller.recordImages.value.length;
                        if (index >= length) {
                            return Column(
                                children: [
                                    Center(
                                        child: SizedBox(
                                            child: CircularProgressIndicator(
                                                color: GlobalVar.primaryOrange
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
                                            ItemHistoricalSmartCamera(
                                                controller: GetXCreator.putHistoricalSmartCameraController("ItemHistoricalSmartCamera",context),
                                                recordCamera: controller.recordImages.value[index],
                                                index: index,
                                                onOptionTap: () {
                                                    // _showButtonDialog(context, controller);
                                                },
                                            ),
                                            index == controller.recordImages.value.length - 1 ? SizedBox(height: 120)
                                                : Container(),
                                        ],
                                    ), // </Add>
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 24, right: 16),
                                    child: ListTile(
                                      trailing: PopupMenuButton(
                                          icon:  Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  color: GlobalVar.primaryLight,
                                                  border: Border(
                                                      bottom: BorderSide(color: GlobalVar.primaryOrange, width: 1),
                                                      left: BorderSide(color: GlobalVar.primaryOrange, width: 1),
                                                      right: BorderSide(color: GlobalVar.primaryOrange, width: 1),
                                                      top: BorderSide(color: GlobalVar.primaryOrange, width: 1),
                                                  ),
                                                  borderRadius: BorderRadius.circular(8)),
                                              child: SvgPicture.asset("images/dot_primary_orange_icon.svg", height: 24, width: 24,),
                                          ),
                                          itemBuilder: (context) {
                                              return [
                                                  PopupMenuItem(
                                                      value: 'Bagikan',
                                                      child:  Text(
                                                          "Bagikan",
                                                          style: GlobalVar.blackTextStyle
                                                              .copyWith(fontSize: 14),
                                                      ),
                                                  ),
                                                  PopupMenuItem(
                                                      value: 'Download',
                                                      child: Text('Download',
                                                          style: GlobalVar.blackTextStyle
                                                  .copyWith(fontSize: 14),),
                                                  )
                                              ];
                                          },
                                          onSelected: (String value){
                                              if(value == "Bagikan"){
                                                  GlobalVar.track("Click_option_menu_bagikan");
                                                  controller.setContentShare(controller.recordImages.value[index], false);
                                              }else{
                                                  GlobalVar.track("Click_option_menu_download");
                                                  controller.setContentShare(controller.recordImages.value[index], true );
                                              }
                                          },), // </Add>
                                  ),
                                )

                            ],

                            );
                        },
                ),
            );
        }

        return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: appBar(),),
            body: Stack(
                children: [
                Obx(() => controller.isLoading.isTrue ?
                Center(
                    child:
                    ProgressLoading(),) :
                controller.recordImages.value.isEmpty ?   Center(
                    child: Container(
                        width: double.infinity,
                        height: MediaQuery. of(context). size. height,
                        margin: EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
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
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.all(12),
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
                        //     controller.dtftakePicture),,
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
