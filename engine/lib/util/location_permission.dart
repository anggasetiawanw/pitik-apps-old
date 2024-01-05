// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

Future<bool> handleLocationPermission() async {

    if (!await FlLocation.isLocationServicesEnabled) {
      // Location services are disabled.
        Get.snackbar(
            "Peringatan!",
            "Tolong Aktifkan layanan Lokasi (GPS)!",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
        );
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      // Cannot request runtime permission because location permission is denied forever.
      Get.snackbar(
            "Peringatan!",
            "Tolong Aktifkan layanan Lokasi (GPS)!",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
        );
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      // Ask the user for location permission.
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
            Get.snackbar(
                "Peringatan!",
                "Tolong Aktifkan layanan Lokasi (GPS)!",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
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