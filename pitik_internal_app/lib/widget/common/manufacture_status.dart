import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';

class ManufactureStatus extends StatelessWidget {
    const ManufactureStatus({super.key, required this.manufactureStatus});

    final String? manufactureStatus;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(                
                color: manufactureStatus == null ? AppColors.grey :
                       manufactureStatus == "INPUT_DRAFT" ? const Color(0xFFFEEFD2) :
                       manufactureStatus == "INPUT_CONFIRMED" ? const Color(0xFFD0F5FD) :
                       manufactureStatus == "INPUT_BOOKED" ? const Color(0xFFFAEDCF) :
                       manufactureStatus == "OUTPUT_DRAFT" ? const Color(0xFFFEF6D2) :
                       manufactureStatus == "OUTPUT_CONFIRMED" ? const Color(0xFFD0F5FD) :
                       const Color(0xFFFDDFD1),
                borderRadius: BorderRadius.circular(6)
            ),
            child: Center(
                child: Text(
                    manufactureStatus == null ? "N/A" :
                       manufactureStatus== "INPUT_DRAFT" ? "Input Draft" :
                       manufactureStatus == "INPUT_CONFIRMED" ? "Input Terkonfirmasi" :
                       manufactureStatus== "INPUT_BOOKED" ? "Dipesan" :
                       manufactureStatus== "OUTPUT_DRAFT" ? "Output Draft" :
                       manufactureStatus == "OUTPUT_CONFIRMED" ?  "Output Terkonfirmasi" : "Dibatalkan" ,
                style: manufactureStatus == null ? AppTextStyle.blackTextStyle :
                       manufactureStatus== "INPUT_DRAFT" ? const TextStyle(color: Color(0xFFF47B20)) :
                       manufactureStatus == "INPUT_CONFIRMED" ? const TextStyle(color: Color(0xFF198BDB)) :
                       manufactureStatus== "INPUT_BOOKED" ? const TextStyle(color: Color(0xFFAB6116)) :
                       manufactureStatus== "OUTPUT_DRAFT" ? const TextStyle(color: Color(0xFFF4B420)) :
                       manufactureStatus == "OUTPUT_CONFIRMED" ? const TextStyle(color: Color(0xFF198BDB)) :
                       const TextStyle(color: Color(0xFFDD1E25)),
                )
            ),
        );
    }
}
