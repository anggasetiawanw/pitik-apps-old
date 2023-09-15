
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../global_var.dart';
import '../library/model_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class CardListSmartController extends StatelessWidget {
    final Device device;
    final Function() onTap;
    final bool isItemList;
    static const String GOOD = "good";
    static const String BAD = "bad";

    const CardListSmartController({super.key, required this.device, required this.onTap, this.isItemList = false});

    @override
    Widget build(BuildContext context) {
        Widget itemSensor(String title, SensorData sensorData) {
            return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: GlobalVar.outlineColor, width: 1),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                        color:Color(0xFFFFF6ED),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                            bottomRight: Radius.circular(4),
                                            bottomLeft: Radius.circular(4)
                                        )
                                    ),
                                    child: Center(
                                        child: Center(
                                            child: title == "Temperature"? SvgPicture.asset("images/temperature_icon.svg") : SvgPicture.asset("images/humidity_icon.svg") ,
                                        )
                                    )
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child:
                                    Text(
                                        title,
                                        style: GlobalVar.blackTextStyle.copyWith(fontSize: 14),
                                        overflow: TextOverflow.clip)
                                )
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Text(
                                        "${sensorData.value ?? 0}",
                                        style: sensorData.status == GOOD ? GlobalVar.greenTextStyle : sensorData.status == BAD ? GlobalVar.redTextStyle : GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold),
                                        overflow: TextOverflow.clip
                                    )
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child:
                                    Text(
                                        title == "Temperature"? "°C" : sensorData.uom ?? "%",
                                        style: GlobalVar.primaryTextStyle.copyWith(fontSize: 14),
                                        overflow: TextOverflow.clip
                                    )
                                )
                            ]
                        )
                    ]
                )
            );
        }

        return GestureDetector(
            onTap: onTap,
            child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(color: GlobalVar.outlineColor, width: 1),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    isItemList == true ? device.deviceName! : "Kondisi Lantai",
                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                                )
                            ]
                        ),
                        if (device.deviceSummary != null)...[
                            if(device.deviceSummary!.temperature != null)...[
                                itemSensor("Temperature", device.deviceSummary!.temperature!),
                            ],
                            if(device.deviceSummary!.relativeHumidity != null)...[
                                itemSensor("Kelembaban", device.deviceSummary!.relativeHumidity!),
                            ],
                        ] else...[
                            itemSensor("Temperature", SensorData()),
                            itemSensor("Kelembaban", SensorData()),
                        ],
                        const SizedBox(height: 6),
                    ]
                )
            )
        );
    }
}