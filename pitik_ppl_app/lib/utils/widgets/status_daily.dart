/// @author [Angga Setiawan Wahyudin]
/// @email [anggasetiaw@gmail.com]
/// @create date 2023-11-15 11:44:51
/// @modify date 2023-11-15 11:44:51
/// @desc [description]

import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:pitik_ppl_app/utils/enums/daily_report_enum.dart';

class StatusDailyReport extends StatelessWidget {
    final String status;
  const StatusDailyReport({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
        TextStyle textStyle;
        if(status == EnumDailyReport.REVIEW_SOON || status == EnumDailyReport.FILL_SOON){
            color = const Color(0xFFFEF6D2);
            textStyle =const TextStyle(color: Color(0xFFF4B420));
        }
        else if(status == EnumDailyReport.REVIEWED || status == EnumDailyReport.FILLED){
            color = const Color(0xFFD0F5FD);
            textStyle = const TextStyle(color: Color(0xFF198BDB));
        }
        else if(status == EnumDailyReport.FINISHED ){
            color = const Color(0xFFCEFCD8);
            textStyle =const TextStyle(color: Color(0xFF14CB82));
        } 
        else {
            color = const Color(0xFFFDDFD1);
            textStyle =GlobalVar.redTextStyle;
        }
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6)
        ),
        child: Center(
            child: Text(status,
            style: textStyle,
            )
        ),
    );
  }
}
