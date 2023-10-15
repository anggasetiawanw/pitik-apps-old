// ignore_for_file: must_be_immutable

import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'global_var.dart';

class AppBarFormForCoop extends StatelessWidget {
    String title;
    Coop coop;
    AppBarFormForCoop({super.key, required this.title, required this.coop});

    @override
    Widget build(BuildContext context) {
        DateTime? startDate = coop.startDate == null ? null : Convert.getDatetime(coop.startDate!);
        return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                color: GlobalVar.primaryOrange
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            GestureDetector(
                                onTap: () => Get.back(),
                                child: const Icon(Icons.arrow_back, color: Colors.white),
                            ),
                            Text(title, style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: Colors.white)),
                            const SizedBox()
                        ],
                    ),
                    const SizedBox(height: 16),
                    Text(coop.coopName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text('DOC-In ${startDate == null ? '-' : '${Convert.getYear(startDate)}-${Convert.getMonthNumber(startDate)}-${Convert.getDay(startDate)}'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.white))
                ],
            ),
        );
    }
}