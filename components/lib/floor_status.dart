// ignore_for_file: slash_for_doc_comments

import 'package:flutter/cupertino.dart';
import 'global_var.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class FloorStatus extends StatelessWidget {
  const FloorStatus({super.key, required this.floorStatus});

  final String? floorStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
            color: floorStatus == null
                ? GlobalVar.gray
                : floorStatus == "active"
                    ? const Color(0xFFCEFCD8)
                    : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(6)),
        child: Center(
            child: Text(
                floorStatus == null
                    ? "Non-Aktif"
                    : floorStatus == "active"
                        ? "Aktif"
                        : "Non-Aktif",
                style: floorStatus == null
                    ? GlobalVar.blackTextStyle
                    : floorStatus == "active"
                        ? const TextStyle(color: Color(0xFF14CB82))
                        : const TextStyle(color: Color(0xFF2C2B2B)))));
  }
}
