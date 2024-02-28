// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';

import 'global_var.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class DeviceStatus extends StatelessWidget {
  const DeviceStatus({super.key, required this.status, this.errorStatus = false});

  final bool? status;
  final bool? errorStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: errorStatus != null && errorStatus == true
              ? const Color(0xFFDD1E25)
              : status == null
                  ? GlobalVar.gray
                  : status == true
                      ? const Color(0xFFCEFCD8)
                      : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
              errorStatus != null && errorStatus == true
                  ? "Error"
                  : status == null
                      ? "Non-Aktif"
                      : status == true
                          ? "Aktif"
                          : "Non-Aktif",
              style: errorStatus != null && errorStatus == true
                  ? const TextStyle(color: Color(0xFFF0F0F0))
                  : status == null
                      ? const TextStyle(color: Color(0xFF2C2B2B))
                      : status == true
                          ? const TextStyle(color: Color(0xFF14CB82))
                          : const TextStyle(color: Color(0xFF2C2B2B)))),
    );
  }
}
