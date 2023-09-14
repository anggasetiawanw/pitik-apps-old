
import 'package:flutter/cupertino.dart';

import 'global_var.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class DeviceStatus extends StatelessWidget{
    const DeviceStatus({super.key, required this.status, required this.activeString, required this.inactiveString});
    final bool? status;
    final String? activeString;
    final String? inactiveString;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                color: status == null ? GlobalVar.gray :
                status == true && activeString == "Default" ? Color(0xFFFEF6D2) :
                status == true ? Color(0xFFCEFCD8) :
                Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(6)
            ),
            child: Center(
                child: Text(
                    status == null ? "${inactiveString}" :
                    status == true ? "${activeString}" :
                    "${inactiveString}",
                    style: status == null ? GlobalVar.blackTextStyle :
                    status == true && activeString == "Default" ? TextStyle(color: Color(0xFFF4B420)) :
                    status == true ? TextStyle(color: Color(0xFF14CB82)) :
                    TextStyle(color: Color(0xFF2C2B2B))
                )
            ),
        );
    }
}