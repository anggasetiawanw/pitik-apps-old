
// ignore_for_file: prefer_final_fields

import 'package:engine/util/location_permission.dart';
import 'package:engine/util/scheduler.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'interface/gps_listener.dart';
import 'interface/schedule_listener.dart';
import 'dart:math' show cos, sqrt, asin;

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

class GpsUtil {
    static Map<String, double?> _locationMap = {
        'longitude': -1,
        'latitude': -1,
        'accuracy': -1,
        'altitude': -1,
        'speed': -1,
        'speed_accuracy': -1
    };
    static bool _isMock = false;

    /// `mock(true)` will make all the network calls in the app to be mocked
    ///
    /// Args:
    ///   mock (bool): true if you want to mock the data, false if you want to use
    /// the real data.
    static void mock(bool mock) {
        _isMock = mock;
    }

    /// It gets the current location of the user.
    static Future<void> onStream({interval = 10000}) async {
        final hasPermission = await handleLocationPermission();
        if (hasPermission) {
            FlLocation.getLocationStream(interval: interval, accuracy: LocationAccuracy.high)
                .handleError((error) => print('Location error : ${error.toString()}'))
                .listen((event) {
                _locationMap['longitude'] = event.longitude;
                _locationMap['latitude'] = event.latitude;
                _locationMap['accuracy'] = event.accuracy;
                _locationMap['altitude'] = event.altitude;
                _locationMap['speed'] = event.speed;
                _locationMap['speed_accuracy'] = event.speedAccuracy;
                _isMock = event.isMock;
            });
        }
    }

    static Future<void> getLatestLocation({isMock = true}) async {
        final hasPermission = await handleLocationPermission();
        if (hasPermission) {
            const timeLimit = Duration(seconds: 10);
            await FlLocation.getLocation(timeLimit: timeLimit).then((event) async {
                if (isMock && event.isMock) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, Gps Mock Detected",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                } else {
                    _locationMap!['longitude'] = event.longitude;
                    _locationMap!['latitude'] = event.latitude;
                    _locationMap!['accuracy'] = event.accuracy;
                    _locationMap!['altitude'] = event.altitude;
                    _locationMap!['speed'] = event.speed;
                    _locationMap!['speed_accuracy'] = event.speedAccuracy;
                }
            });
        }
    }

    /// It checks if the GPS is on or off.
    ///
    /// Args:
    ///   listener (GpsListener): The listener that will be called when the GPS is
    /// on or off.
    static void isOn(GpsListener listener) async {
        await FlLocation.isLocationServicesEnabled.then((result) {
            if (result) {
                listener.isOn();
            } else {
                listener.isOff();
            }
        });
    }

    static void checkingMock({Function()? onIsMock}) async {
        if (_isMock && onIsMock != null) {
            onIsMock();
        }
    }

    /// If the locationMap is not null, return the value of the longitude key in the
    /// locationMap.
    ///
    /// Returns:
    ///   The latitude and longitude of the current location.
    static double? longitude() {
        return _locationMap!['longitude'];
    }

    /// > If the locationMap is not null, return the latitude value from the
    /// locationMap
    ///
    /// Returns:
    ///   The latitude of the current location.
    static double? latitude() {
        return _locationMap!['latitude'];
    }

    /// `return _locationMap!['accuracy'];`
    ///
    /// The `!` is a Dart operator that says "I know this is not null, so don't
    /// worry about it."
    ///
    /// The `?` is a Dart operator that says "This might be null, so be careful."
    ///
    /// The `?` operator is used in the function's return type, and the `!` operator
    /// is used in the function's body
    ///
    /// Returns:
    ///   The accuracy of the location.
    static double? accuracy() {
        return _locationMap!['accuracy'];
    }

    /// If the locationMap is not null, return the value of the key 'altitude' in
    /// the locationMap, otherwise return null.
    ///
    /// Returns:
    ///   The altitude of the device.
    static double? altitude() {
        return _locationMap!['altitude'];
    }

    /// If the locationMap is not null, return the value of the speed key in the
    /// locationMap.
    ///
    /// Returns:
    ///   The speed of the device.
    static double? speed() {
        return _locationMap!['speed'];
    }

    /// `speedAccuracy` returns the speed accuracy of the current location
    ///
    /// Returns:
    ///   The speed accuracy of the location.
    static double? speedAccuracy() {
        return _locationMap!['speed_accuracy'];
    }

    /// Run the GPS scheduler for the given duration, and always force the GPS
    /// scheduler to run, even if the GPS scheduler is not ready to run.
    ///
    /// Args:
    ///   duration (Duration): The duration of the test.
    static void force({required Duration duration, required GpsListener gpsListener, Function()? onIsMock}) async {
        await Scheduler()
              .listener(SchedulerListener(
                    onTick: <bool>(packet) {
                        GpsUtil.isOn(gpsListener);
                        if (GpsUtil._isMock) {
                            GpsUtil.checkingMock(onIsMock: onIsMock);
                        }

                        return true;
                    },
                    onTickDone: (packet) {},
                    onTickFail: (packet) {}
              ))
              .always(true)
              .run(duration);
    }

    static double calculateDistance(double latitudeCompare, double longitudeCompare) {
        double currentLatitude = latitude()!;
        double currentLongitude = longitude()!;

        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 - c((latitudeCompare - currentLatitude) * p)/2 + c(currentLatitude * p) * c(latitudeCompare * p) * (1 - c((longitudeCompare - currentLongitude) * p))/2;

        return 12742 * asin(sqrt(a));
    }
}