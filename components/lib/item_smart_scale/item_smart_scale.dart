// ignore_for_file: slash_for_doc_comments

import 'package:flutter/cupertino.dart';

import '../global_var.dart';
import '../library/engine_library.dart';
import '../library/model_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ItemSmartScale extends StatelessWidget {
    const ItemSmartScale({super.key, required this.smartScale, required this.onTap, this.indeksCamera = 0 });

    final SmartScale? smartScale;
    final Function() onTap;
    final int? indeksCamera ;

    @override
    Widget build(BuildContext context) {
        final DateTime executionDate = Convert.getDatetime(smartScale!.executionDate!);

        return GestureDetector(onTap: onTap,
            child: Container(
                margin: const EdgeInsets.only(top: 16 ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: GlobalVar.outlineColor),
                    borderRadius: BorderRadius.circular(8)),
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
                                                Text(
                                                    "Daftar Timbang ${Convert.getYear(executionDate)}/${Convert.getMonthNumber(executionDate)}/${Convert.getDay(executionDate)} - ${Convert.getHour(executionDate)}.${Convert.getMinute(executionDate)}",
                                                    style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 14, overflow: TextOverflow.clip),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(
                                                            child: Row(
                                                                children: [
                                                                    Text("Total Ayam:", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                    const SizedBox(width: 4),
                                                                    Text("${smartScale!.totalCount} Ekor", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                                ],
                                                            )
                                                        ),
                                                        Expanded(
                                                            child: Row(
                                                                children: [
                                                                    Text("Berat rata-rata:", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                    const SizedBox(width: 4),
                                                                    Flexible(child: Text("${smartScale!.averageWeight!.toStringAsFixed(2)} kg", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)))
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