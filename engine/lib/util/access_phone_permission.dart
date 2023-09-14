import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 24/08/23
 */



Future<bool> handlePermissionPhoneAccess() async {

    var status = await Permission.phone.status;
    if (!status.isGranted) {
        await Permission.phone.request();
    }

    if (!await MobileNumber.hasPhonePermission) {
        await MobileNumber.requestPhonePermission;
    }

    if (await Permission.phone.isDenied || !await MobileNumber.hasPhonePermission ) {
        // Location services are disabled.
        Get.snackbar(
            "Alert",
            "Enable Phone Access Please",
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
        );
        return false;
    }

    return true;
}