
import 'package:engine/util/scheduler.dart';
import 'package:location/location.dart';
import 'package:trust_location/trust_location.dart';
import 'interface/gps_listener.dart';
import 'interface/schedule_listener.dart';
import 'dart:math' show cos, sqrt, asin;

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

class GpsUtil {
    static Map<String, double>? _locationMap;
    static final _location = Location();
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
    static Future on() async {
        _locationMap = {};
        _location.changeSettings(accuracy: LocationAccuracy.high);

        try {
            await _location.getLocation().then((data) {
              _locationMap!['longitude'] = data.longitude!;
              _locationMap!['latitude'] = data.latitude!;
              _locationMap!['accuracy'] = data.accuracy!;
              _locationMap!['altitude'] = data.altitude!;
              _locationMap!['speed'] = data.speed!;
              _locationMap!['speed_accuracy'] = data.speedAccuracy!;
            });
        } on Exception catch (e) {
            print('Location error : ${e.toString()}');
        }

        _location.onLocationChanged.listen((data) {
            _locationMap!['longitude'] = data.longitude!;
            _locationMap!['latitude'] = data.latitude!;
            _locationMap!['accuracy'] = data.accuracy!;
            _locationMap!['altitude'] = data.altitude!;
            _locationMap!['speed'] = data.speed!;
            _locationMap!['speed_accuracy'] = data.speedAccuracy!;
        });
    }

    /// It checks if the GPS is on or off.
    ///
    /// Args:
    ///   listener (GpsListener): The listener that will be called when the GPS is
    /// on or off.
    static void isOn(GpsListener listener) async {
        await _location.serviceEnabled().then((result) {
            if (result) {
                listener.isOn();
            } else {
                listener.isOff();
            }
        });
    }

    static void checkingMock({Function()? onIsMock}) async {
        bool isMockLocation = await TrustLocation.isMockLocation;
        if (isMockLocation && onIsMock != null) {
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