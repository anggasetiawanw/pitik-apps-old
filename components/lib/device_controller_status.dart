// ignore_for_file: slash_for_doc_comments

import 'package:flutter/cupertino.dart';
import 'global_var.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class DeviceStatus extends StatelessWidget {
  const DeviceStatus({super.key, required this.status, required this.activeString, required this.inactiveString});
  final bool? status;
  final String? activeString;
  final String? inactiveString;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: status == null
              ? GlobalVar.gray
              : status == true && activeString == "Default"
                  ? const Color(0xFFFEF6D2)
                  : status == true
                      ? const Color(0xFFCEFCD8)
                      : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
              status == null
                  ? "$inactiveString"
                  : status == true
                      ? "$activeString"
                      : "$inactiveString",
              style: status == null
                  ? GlobalVar.blackTextStyle
                  : status == true && activeString == "Default"
                      ? const TextStyle(color: Color(0xFFF4B420))
                      : status == true
                          ? const TextStyle(color: Color(0xFF14CB82))
                          : const TextStyle(color: Color(0xFF2C2B2B)))),
    );
  }
}
