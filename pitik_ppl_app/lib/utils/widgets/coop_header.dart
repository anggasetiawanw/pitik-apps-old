import 'package:components/global_var.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model/coop_model.dart';

class CoopHeader extends StatelessWidget {
  const CoopHeader({
    super.key,
    required this.coop,
  });

  final Coop coop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16, top: 8),
      decoration: const BoxDecoration(
        color: GlobalVar.primaryOrange,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${coop.coopName} (Hari ${coop.day})",
            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "DOC-In ${DateFormat("yyyy-MM-dd").format(Convert.getDatetime(coop.startDate!))}",
            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}