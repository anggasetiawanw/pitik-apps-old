import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';

class TerminateStatus extends StatelessWidget {
    const TerminateStatus({super.key, required this.terminateStatus});

    final String? terminateStatus;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(                
                color: terminateStatus == null ? AppColors.grey :
                       terminateStatus == "DRAFT" ? const Color(0xFFFEEFD2) :
                       terminateStatus == "CONFIRMED" ? const Color(0xFFD0F5FD) :
                       terminateStatus == "BOOKED" ? const Color(0xFFFAEDCF) :
                       terminateStatus == "FINISHED" ? const Color(0xFFCEFCD8) :
                       const Color(0xFFFDDFD1),
                borderRadius: BorderRadius.circular(6)
            ),
            child: Center(
                child: Text(
                       terminateStatus== "DRAFT" ? "Draft" :
                       terminateStatus == "CONFIRMED" ? "Terkonfirmasi" :
                       terminateStatus== "BOOKED" ? "Dipesan" :
                       terminateStatus== "FINISHED" ? "Selesai" : "Dibatalkan",
                style: terminateStatus == null ? AppTextStyle.blackTextStyle :
                       terminateStatus== "DRAFT" ? const TextStyle(color: Color(0xFFF47B20)) :
                       terminateStatus == "CONFIRMED" ? const TextStyle(color: Color(0xFF198BDB)) :
                       terminateStatus== "BOOKED" ? const TextStyle(color: Color(0xFFAB6116)) :
                       terminateStatus== "FINISHED" ? const TextStyle(color: Color(0xFF14CB82)) :
                       const TextStyle(color: Color(0xFFDD1E25)),
                )
            ),
        );
    }
}
