// ignore_for_file: slash_for_doc_comments

import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

import '../global_var.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ItemSmartScaleDay extends StatelessWidget {
    const ItemSmartScaleDay({super.key, required this.smartScale, required this.onTap, this.isRedChild = false});

    final bool isRedChild;
    final SmartScale smartScale;
    final Function() onTap;

    @override
    Widget build(BuildContext context) {
        final DateTime date = Convert.getDatetime(smartScale.date!);

        return GestureDetector(onTap: onTap,
            child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(width: isRedChild ? 0 : 1.4, color: GlobalVar.outlineColor),
                    borderRadius: BorderRadius.circular(8),
                    color: isRedChild ? GlobalVar.redBackground : Colors.transparent
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
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text("Hari Ke ${smartScale.day}", style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 16, overflow: TextOverflow.clip, color: isRedChild ? GlobalVar.red : GlobalVar.black)),
                                                        Text("${Convert.getYear(date)}-${Convert.getMonthNumber(date)}-${Convert.getDay(date)}", style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 10, overflow: TextOverflow.clip, color: GlobalVar.grayText)),
                                                    ],
                                                ),
                                                const SizedBox(height: 6),
                                                smartScale.totalCount == null || smartScale.totalCount == 0 ? Text(
                                                    "Belum ada data timbang!",
                                                    style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip, color: isRedChild ? GlobalVar.red : GlobalVar.black)
                                                ) : Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(
                                                            child: Row(
                                                                children: [
                                                                    Text("Total Sampel:", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                    const SizedBox(width: 4),
                                                                    Text("${smartScale.totalCount} Ekor", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                                ],
                                                            )
                                                        ),
                                                        Expanded(
                                                            child: Row(
                                                                children: [
                                                                    Text("Berat rata-rata:", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                    const SizedBox(width: 4),
                                                                    Flexible(child: Text("${smartScale.avgWeight == null ? '-' : smartScale.avgWeight!.toStringAsFixed(2)} kg", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)))
                                                                ]
                                                            )
                                                        )
                                                    ]
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