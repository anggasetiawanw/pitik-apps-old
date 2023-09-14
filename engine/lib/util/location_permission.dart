import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> handleLocationPermission() async {

    if (!await FlLocation.isLocationServicesEnabled) {
      // Location services are disabled.
        Get.snackbar(
            "Alert",
            "Enable Location, Please",
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
        );
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      // Cannot request runtime permission because location permission is denied forever.
      Get.snackbar(
            "Alert",
            "Enable Location, Please!",
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
        );
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      // Ask the user for location permission.
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever){
            Get.snackbar(
                "Alert",
                "Enable Location, Please!",
                snackPosition: SnackPosition.TOP,
                duration: Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
                );
            return false;
        }
    }

    // Location permission must always be allowed (LocationPermission.always)
    // to collect location data in the background.
    // if (background == true &&
    //     locationPermission == LocationPermission.whileInUse) return false;

    // Location services has been enabled and permission have been granted.
    return true;
}