
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/record_model.dart';

import '../global_var.dart';
import 'item_historical_smartcamera_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ItemHistoricalSmartCamera extends StatelessWidget{
    final ItemHistoricalSmartCameraController controller;
    const ItemHistoricalSmartCamera({super.key, required this.recordCamera, required this.onOptionTap, required this.controller, required this.index, this.isCanCrowdednessCorrection = false});

    final RecordCamera? recordCamera;
    final Function() onOptionTap;
    final int index;
    final bool isCanCrowdednessCorrection;

    @override
    Widget build(BuildContext context) {
        controller.recordCamera.value = recordCamera ?? RecordCamera();
        final DateTime takePictureDate = Convert.getDatetime(recordCamera!.createdAt!);

        return Obx(() =>
            controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : Column(
                children: [
                    const SizedBox(height: 16),
                    Stack(
                        children: [
                            ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8)
                                ),
                                child: Container(
                                    color: GlobalVar.gray,
                                    child:
                                    Image.network(
                                        recordCamera!.link!,
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
                                            );
                                        }
                                    )
                                )
                            ),
                            GestureDetector(
                                onTap: () {
                                    if (controller.isShow.isTrue) {
                                        controller.isShow.value = false;
                                    } else {
                                        controller.isShow.value = true;
                                    }
                                },
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container()
                                )
                            ),
                            Obx(() =>
                            controller.isShow.isFalse ?
                            Container() :
                            Align(
                                alignment: const Alignment(1, -1),
                                child: GestureDetector(
                                    onTap: () {
                                        // _showBottomDialog(context, controller);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(top: 60, right: 30),
                                        width: 135,
                                        height: 66,
                                        child: Stack(
                                            children: [
                                                Container(
                                                    margin: const EdgeInsets.only(top: 8),
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(6)),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    const SizedBox(width: 8),
                                                                    Text(
                                                                        "Edit",
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontSize: 12),
                                                                    )
                                                                ]
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    const SizedBox(width: 8),
                                                                    Text(
                                                                        "Ubah Nama",
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontSize: 12),
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    )
                                                ),
                                                Align(
                                                    alignment: const Alignment(1, -1),
                                                    child: Image.asset(
                                                        "images/triangle_icon.png",
                                                        height: 17,
                                                        width: 17,
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                            )
                        ]
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 8, bottom: 16, right: 16, left: 16),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: GlobalVar.outlineColor),
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8)
                            )
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Expanded(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        const SizedBox(height: 8),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        "Gambar ${index+1} - ${recordCamera!.sensor!.room!.roomType!.name!}",
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 16, overflow: TextOverflow.clip),
                                                                    )
                                                                )
                                                            ]
                                                        ),
                                                        const SizedBox(height: 16),
                                                        Text(
                                                            "${recordCamera!.sensor!.room!.building!.name!} - ${recordCamera!.sensor!.room!.roomType!.name!}",
                                                            style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip),
                                                        ),
                                                        const SizedBox(height: 16),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        "Jam Ambil Gambar",
                                                                        style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip)
                                                                    )
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                        "${takePictureDate.day}/${takePictureDate.month}/${takePictureDate.year} ${takePictureDate.hour}:${takePictureDate.minute}",
                                                                        textAlign: TextAlign.end,
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip)
                                                                    )
                                                                )
                                                            ]
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        "Temperature",
                                                                        style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip)
                                                                    )
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                        recordCamera!.temperature == null ? " - °C" : "${recordCamera!.temperature!} °C",
                                                                        textAlign: TextAlign.end,
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip)
                                                                    )
                                                                )
                                                            ]
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        "Kelembaban",
                                                                        style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip)
                                                                    )
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                        recordCamera!.humidity == null ? " - %" : "${recordCamera!.humidity!} %",
                                                                        textAlign: TextAlign.end,
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip)
                                                                    )
                                                                )
                                                            ]
                                                        ),
                                                        isCanCrowdednessCorrection && controller.recordCamera.value.isCrowded == null ? Column(
                                                            children: [
                                                                const SizedBox(height: 8),
                                                                controller.spCrowdedness,
                                                                controller.eaCrowdedness,
                                                                const SizedBox(height: 8),
                                                                ButtonFill(controller: GetXCreator.putButtonFillController('btnCrowdednessSubmit'), label: 'Submit', onClick: () => controller.submit())
                                                            ],
                                                        ) : const SizedBox()
                                                    ]
                                                )
                                            )
                                        ]
                                    )
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }
}