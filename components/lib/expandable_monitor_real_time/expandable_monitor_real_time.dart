// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:model/coop_model.dart';

import '../global_var.dart';
import '../progress_loading/progress_loading.dart';
import 'expandable_monitor_real_time_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ExpandableMonitorRealTime extends StatelessWidget {
    ExpandableMonitorRealTimeController controller;
    String headerText;
    bool expanded;
    String value;
    String unitValue;
    String icon;
    int valueTextColor;
    Coop coop;
    String roomId;
    String sensorType;
    String targetLabel;
    String averageLabel;
    String? deviceIdForController;
    String? coopIdForController;
    Function(bool) onExpand;

    ExpandableMonitorRealTime({super.key, required this.controller, required this.headerText, this.expanded = false, required this.value, required this.unitValue, this.icon = "images/temperature_icon.svg",
                               this.valueTextColor = 0xFF2C2B2B, required this.onExpand, required this.coop, required this.roomId, required this.sensorType, this.averageLabel = "", this.targetLabel = "",
                               this.deviceIdForController, this.coopIdForController});

    ExpandableMonitorRealTimeController getController() => Get.find(tag: controller.tag);

    @override
    Widget build(BuildContext context) {
        controller.expanded.value = expanded;

        return Obx(() =>
            GFAccordion(
                margin: const EdgeInsets.only(top: 16),
                titleChild: Row(
                    children: [
                        Row(
                            children: [
                                Container(
                                    width: 64,
                                    height: 64,
                                    margin: const EdgeInsets.only(left: 6, right: 6),
                                    decoration: const BoxDecoration(
                                        color:Color(0xFFFFF6ED),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6),
                                            bottomLeft: Radius.circular(6)
                                        )
                                    ),
                                    child: Center(child: SvgPicture.asset(icon, width: 32, height: 32))
                                )
                            ]
                        ),
                        const SizedBox(width: 8),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(headerText, style: GlobalVar.greyTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium)),
                                const SizedBox(height: 8,),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Text("$value $unitValue", style: TextStyle(color: Color(valueTextColor), fontSize: 24, fontWeight: GlobalVar.medium))
                                    ]
                                )
                            ]
                        )
                    ]
                ),
                textStyle: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium),
                onToggleCollapsed: (isExpand) {
                    onExpand(isExpand);
                    if (isExpand) {
                        controller.expand();
                        if (deviceIdForController != null) {
                            controller.getRealTimeHistoricalDataForSmartController(sensorType: sensorType, day: 1, deviceIdForController: deviceIdForController!, coopIdForController: coopIdForController!);
                        } else {
                            controller.getRealTimeHistoricalData(sensorType: sensorType, coop: coop, day: 1, roomId: roomId);
                        }

                        controller.indexTab.value = 0 ;
                    } else {
                        controller.collapse();
                    }
                },
                collapsedTitleBackgroundColor: const Color(0xFFFFFFFF),
                expandedTitleBackgroundColor: const Color(0xFFFFFFFF),
                showAccordion: controller.expanded.value,
                collapsedIcon: Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: SvgPicture.asset("images/arrow_down.svg")
                ),
                expandedIcon: SvgPicture.asset("images/arrow_up.svg"),
                titleBorder: Border.all(color: GlobalVar.outlineColor),
                titleBorderRadius: controller.expanded.isTrue ? const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)) : const BorderRadius.all(Radius.circular(10)),
                contentBorder: const Border(
                    bottom: BorderSide(color:GlobalVar.outlineColor, width: 1),
                    left: BorderSide(color: GlobalVar.outlineColor, width: 1),
                    right: BorderSide(color: GlobalVar.outlineColor, width: 1),
                    top: BorderSide(color: GlobalVar.outlineColor, width: 0)
                ),
                contentBorderRadius: controller.expanded.isTrue ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)) : const BorderRadius.all(Radius.circular(10)),
                contentChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text("Riwayat $headerText Kandang", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium)),
                                sensorType == "temperature" || sensorType == "relativeHumidity" ? GestureDetector(
                                    onTap: () => controller.showSensorMappingBottomSheet(),
                                    child: SvgPicture.asset('images/information_blue_icon.svg'),
                                ) : const SizedBox()
                            ]
                        ),
                        const SizedBox(height: 16),
                        Row(
                            children: [
                                targetLabel == "" ? Container() :
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        const SizedBox(width: 16),
                                        SvgPicture.asset("images/circle_green.svg"),
                                        const SizedBox(width: 12),
                                        Text(targetLabel, style: GlobalVar.blackTextStyle),

                                    ],
                                ),
                                averageLabel == "" ? Container() :
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        const SizedBox(width: 24,),
                                        SvgPicture.asset("images/circle_primary_orange.svg"),
                                        const SizedBox(width: 12,),
                                        Text(averageLabel, style: GlobalVar.blackTextStyle),
                                    ],
                                )
                            ]
                        ),
                        const SizedBox(height: 16),
                        Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: GridView(
                                controller: ScrollController(keepScrollOffset: false),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisExtent: 28,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: List.generate(controller.sensorPositionList.length, (index) {
                                    return Row(
                                        children: [
                                            Container(
                                                width: 2,
                                                height: 2,
                                                decoration: const BoxDecoration(
                                                    color: GlobalVar.black,
                                                    shape: BoxShape.circle
                                                )
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                                controller.sensorPositionList[index] == null || controller.sensorPositionList[index]!.position == null ? '-' : controller.sensorPositionList[index]!.position!,
                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                            )
                                        ],
                                    );
                                }),
                            ),
                        ),
                        controller.isLoading.isTrue ?
                        const Center(child: SizedBox(height: 124, width: 124, child: ProgressLoading())) : controller.gvSmartMonitoring,
                        Container(
                            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    GestureDetector(
                                        onTap: () {
                                            controller.indexTab.value = 0;
                                            if (deviceIdForController != null) {
                                                controller.getRealTimeHistoricalDataForSmartController(sensorType: sensorType, day: 1, deviceIdForController: deviceIdForController!, coopIdForController: coopIdForController!);
                                            } else {
                                                controller.getRealTimeHistoricalData(sensorType: sensorType, coop: coop, day: 1, roomId: roomId);
                                            }
                                        },
                                        child: Column(
                                            children: [
                                                Text("1 Hari", style: controller.indexTab == 0 ? GlobalVar.primaryTextStyle : GlobalVar.blackTextStyle),
                                                const SizedBox(height: 8),
                                                Container(
                                                    height: 2,
                                                    width: 48,
                                                    color: controller.indexTab == 0 ? GlobalVar.primaryOrange : Colors.white,
                                                )
                                            ],
                                        ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                            controller.indexTab.value = 1;
                                            if (deviceIdForController != null) {
                                                controller.getRealTimeHistoricalDataForSmartController(sensorType: sensorType, day: 3, deviceIdForController: deviceIdForController!, coopIdForController: coopIdForController!);
                                            } else {
                                                controller.getRealTimeHistoricalData(sensorType: sensorType, coop: coop, day: 3, roomId: roomId);
                                            }
                                        },
                                        child: Column(
                                            children: [
                                                Text("3 Hari", style: controller.indexTab == 1 ? GlobalVar.primaryTextStyle : GlobalVar.blackTextStyle),
                                                const SizedBox(height: 8),
                                                Container(
                                                    height: 2,
                                                    width: 48,
                                                    color: controller.indexTab == 1 ? GlobalVar.primaryOrange : Colors.white,
                                                  )
                                              ]
                                        )
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                            controller.indexTab.value = 2;
                                            if (deviceIdForController != null) {
                                                controller.getRealTimeHistoricalDataForSmartController(sensorType: sensorType, day: 7, deviceIdForController: deviceIdForController!, coopIdForController: coopIdForController!);
                                            } else {
                                                controller.getRealTimeHistoricalData(sensorType: sensorType, coop: coop, day: 7, roomId: roomId);
                                            }
                                        },
                                        child: Column(
                                            children: [
                                                Text("7 Hari", style: controller.indexTab == 2 ? GlobalVar.primaryTextStyle : GlobalVar.blackTextStyle),
                                                const SizedBox(height: 8),
                                                Container(
                                                    height: 2,
                                                    width: 48,
                                                    color: controller.indexTab == 2 ? GlobalVar.primaryOrange : Colors.white,
                                                )
                                            ]
                                        )
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                            controller.indexTab.value = 3;
                                            if (deviceIdForController != null) {
                                                controller.getRealTimeHistoricalDataForSmartController(sensorType: sensorType, day: -1, deviceIdForController: deviceIdForController!, coopIdForController: coopIdForController!);
                                            } else {
                                                controller.getRealTimeHistoricalData(sensorType: sensorType, coop: coop, day: -1, roomId: roomId);
                                            }
                                        },
                                        child: Column(
                                            children: [
                                                Text("1 Siklus", style: controller.indexTab == 3 ? GlobalVar.primaryTextStyle : GlobalVar.blackTextStyle),
                                                const SizedBox(height: 8),
                                                Container(
                                                    height: 2,
                                                    width: 48,
                                                    color: controller.indexTab == 3 ? GlobalVar.primaryOrange : Colors.white,
                                                )
                                            ]
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }
}
