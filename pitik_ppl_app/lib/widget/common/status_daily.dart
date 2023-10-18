
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';

class StatusDailyReport extends StatelessWidget {
    final String status;
  const StatusDailyReport({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
        TextStyle textStyle;
        if(status == "Segera isi"){
            color = const Color(0xFFFEE4E2);
            textStyle = GlobalVar.redTextStyle;
        }
        else if(status == "Segera Review" ){
            color = const Color(0xFFFEEFD2);
            textStyle = GlobalVar.primaryTextStyle;
        }
        else if(status == "Sudah Isi" ){
            color = const Color(0xFFD0F5FD);
            textStyle = const TextStyle(color: Color(0xFF198BDB));
        }
        else if(status == "Sudah Review" ){
            color = const Color(0xFFCEFCD8);
            textStyle =const TextStyle(color: Color(0xFF14CB82));
        } 
        else {
            color = GlobalVar.gray;
            textStyle =GlobalVar.blackTextStyle;
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