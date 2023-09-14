
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'item_decrease_temperature_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class ItemDecreaseTemperature extends StatelessWidget {
    final ItemDecreaseTemperatureController controller;
    ItemDecreaseTemperature({super.key, required this.controller});

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
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        // topRight: Radius.circular(8),
                                        // topLeft: Radius.circular(8)
                                    )
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Container(
                                            margin: EdgeInsets.symmetric(horizontal: 16),
                                            child: Text("Group ${index + 1}", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14),
                                                overflow: TextOverflow.clip)),],
                                ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: GlobalVar.outlineColor, width: 1),
                                        left: BorderSide(color: GlobalVar.outlineColor, width: 0),
                                        right: BorderSide(color: GlobalVar.outlineColor, width: 0),
                                        top: BorderSide(color: GlobalVar.outlineColor, width: 0),
                                    ),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                        Expanded(
                                            child: Container(
                                                margin: EdgeInsets.only(right: 4),
                                                child: controller.efDayTotal.value[index])),
                                        Expanded(child: Container(
                                            margin: EdgeInsets.only(left: 4),
                                            child: controller.efDecreaseTemp.value[index])),
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

}
