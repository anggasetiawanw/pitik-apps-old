
import 'package:flutter/material.dart';

import 'global_var.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class DeviceStatus extends StatelessWidget{
    const DeviceStatus({super.key, required this.status, this.errorStatus = false});

    final bool? status;
    final bool? errorStatus;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                color:
                errorStatus != null && errorStatus == true ? Color(0xFFDD1E25):
                status == null ? GlobalVar.gray :
                status == true ? Color(0xFFCEFCD8) :
                Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(6)
            ),
            child: Center(
                child: Text(
                    errorStatus != null && errorStatus == true ? "Error" :
                    status == null ? "Non-Aktif" :
                    status == true ? "Aktif" :
                    "Non-Aktif",
                    style:
                    errorStatus != null && errorStatus == true ?TextStyle(color: Color(0xFFF0F0F0)):
                    status == null ? TextStyle(color: Color(0xFF2C2B2B)) :
                    status == true ? TextStyle(color: Color(0xFF14CB82)) :
                    TextStyle(color: Color(0xFF2C2B2B))
                )
            ),
        );
    }
}