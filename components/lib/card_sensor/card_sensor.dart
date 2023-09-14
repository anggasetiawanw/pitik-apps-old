import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../button_fill/button_fill.dart';
import '../button_outline/button_outline.dart';
import '../get_x_creator.dart';
import '../global_var.dart';
import 'card_sensor_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class CardSensor extends StatelessWidget {
    final CardSensorController controller;
    CardSensor({super.key, required this.controller});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
        controller.isShow.isTrue
            ? Column(
            children: controller.index.value.map((int index) {
                return Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Column(
                        children: [
                            Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFDDAA5),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        topLeft: Radius.circular(8)
                                    )
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Container(
                                            margin: EdgeInsets.symmetric(horizontal: 16),
                                            child: Text("Sensor ${index + 1}")),
                                        GestureDetector(
                                            onTap: () {
                                                if (index == (controller.index.value[controller.itemCount.value - 1]) || controller.itemCount.value == 1) {
                                                    GlobalVar.track("Click_button_add_sensor");
                                                    controller.addCard();
                                                } else {
                                                    GlobalVar.track("Click_button_cancel_sensor");
                                                    _showBottomDialog(context, index, controller);
                                                }
                                            },
                                            child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 8),
                                                color: Colors.transparent,
                                                width: 48,
                                                height: 48,
                                                child: index == (controller.index.value[controller.itemCount.value - 1]) || controller.itemCount.value == 1 ?
                                                Icon(Icons.add, size: 30, color: GlobalVar.primaryOrange,)
                                                    :Padding(
                                                    padding: const EdgeInsets.all(12),
                                                    child: SvgPicture.asset("images/delete_sku.svg", fit: BoxFit.cover, width: 20, height: 20),
                                                )
                                            )
                                        )
                                    ],
                                ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: GlobalVar.outlineColor, width: 1),
                                        left: BorderSide(color: GlobalVar.outlineColor, width: 1),
                                        right: BorderSide(color: GlobalVar.outlineColor, width: 1),
                                        top: BorderSide(color: GlobalVar.outlineColor, width: 0),
                                    ),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                ),
                                child: Column(
                                    children: [
                                        controller.efSensorId.value[index],
                                        index == (controller.index.value[controller.itemCount.value - 1]) && controller.itemCount.value != 1 ?
                                        ButtonOutline(
                                            controller: GetXCreator.putButtonOutlineController("Cancel${index}"),
                                            label: "Cancel",
                                            onClick: (){
                                                _showBottomDialog(context, index, controller);
                                            })
                                            : Container(),
                                        SizedBox(height: 16,),
                                    ],
                                ),
                            )
                        ],
                    ),
                );
            }).toList(),
        )
            : Container());
    }

    _showBottomDialog(BuildContext context, int index, CardSensorController controller) {
        return showModalBottomSheet(
            isScrollControlled: true,
            useRootNavigator: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Container(
                                margin: EdgeInsets.only(top: 8),
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: GlobalVar.outlineColor,
                                    borderRadius: BorderRadius.circular(2),
                                ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 24, left: 16, right: 73),
                                child: Text(
                                    "Apakah kamu yakin ingin menghapus data Sensor?",
                                    style: GlobalVar.primaryTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold),
                                ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 8, left: 16, right: 52),
                                child: Text(
                                    "Data sensor yang kamu hapus akan hilang secara permanen pastikan kembali sebelum menghapus",
                                    style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 24),
                                child: SvgPicture.asset("images/ilustration_delete.svg"),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(
                                            child: ButtonFill(
                                                controller: GetXCreator.putButtonFillController("iyaSku${index}"),
                                                label: "Ya",
                                                onClick: () {
                                                    controller.removeCard(index);
                                                    Get.back();
                                                })),
                                        const SizedBox(width: 16),
                                        Expanded(
                                            child: ButtonOutline(
                                                controller: GetXCreator.putButtonOutlineController("tidakVisit${index}"),
                                                label: "Tidak",
                                                onClick: () {
                                                    Get.back();
                                                }
                                            )
                                        ),
                                    ],
                                ),
                            ),
                            const SizedBox(height: GlobalVar.bottomSheetMargin,)
                        ],
                    ),
                );
            }
        );
    }
}
