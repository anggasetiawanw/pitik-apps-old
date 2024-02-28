import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import '../../utils/enum/lead_status.dart';

class LeadStatus extends StatelessWidget {
  const LeadStatus({required this.leadStatus, super.key});

  final String? leadStatus;

  @override
  Widget build(BuildContext context) {
    Color color;
    TextStyle textStyle;
    if (leadStatus == LeadStatusEnum.belum) {
      color = const Color(0xFFFEE4E2);
      textStyle = AppTextStyle.redTextStyle;
    } else if (leadStatus == LeadStatusEnum.akan) {
      color = const Color(0xFFFEEFD2);
      textStyle = AppTextStyle.primaryTextStyle;
    } else if (leadStatus == LeadStatusEnum.pernah) {
      color = const Color(0xFFD0F5FD);
      textStyle = const TextStyle(color: Color(0xFF198BDB));
    } else if (leadStatus == LeadStatusEnum.rutin) {
      color = const Color(0xFFCEFCD8);
      textStyle = const TextStyle(color: Color(0xFF14CB82));
    } else {
      color = AppColors.grey;
      textStyle = AppTextStyle.blackTextStyle;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
        leadStatus ?? LeadStatusEnum.na,
        style: textStyle,
      )),
    );
  }
}
