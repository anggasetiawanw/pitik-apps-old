
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import 'interface/schedule_listener.dart';
import 'scheduler.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class BluetoothLeService {

    bool _useTimeout = false;
    int _secondTimeoutTime = 5;
    final Scheduler _scheduler = Scheduler();

    final _flutterReactiveBle = FlutterReactiveBle();
    late StreamSubscription _listener;

    /// The function sets a timeout value for a BluetoothLeService object.
    ///
    /// Args:
    ///   active (bool): The "active" parameter is a boolean value that determines
    /// whether the timeout feature should be enabled or disabled. If set to true,
    /// the timeout feature will be enabled. If set to false, the timeout feature
    /// will be disabled.
    ///   timeout (int): The timeout parameter is an integer value that represents
    /// the duration of the timeout in seconds.
    ///
    /// Returns:
    ///   The BluetoothLeService object is being returned.
    BluetoothLeService timeout(bool active, int timeout) {
        _useTimeout = active;
        _secondTimeoutTime = timeout;

        return this;
    }

    /// The function checks if the platform is Android and requests Bluetooth
    /// permissions, then proceeds to run a Bluetooth scan.
    ///
    /// Args:
    ///   bluetoothLeConstant (BluetoothLeConstant): The BluetoothLeConstant
    /// parameter is an object that contains constant values related to Bluetooth
    /// Low Energy (BLE) communication. It may include properties such as UUIDs,
    /// service names, characteristic names, etc.
    ///   deviceNameHandle (List<String>): The `deviceNameHandle` parameter is a
    /// list of strings that represents the names or handles of the devices you want
    /// to scan for.
    ///   listener (BluetoothLeCallback): The listener parameter is an instance of
    /// the BluetoothLeCallback interface. It is used to receive callbacks and
    /// notifications related to Bluetooth Low Energy (BLE) operations, such as
    /// device discovery, connection, and data transmission.
    BluetoothLeService start(BluetoothLeConstant bluetoothLeConstant, List<String> deviceNameHandle, BluetoothLeCallback listener) {
        if (Platform.isAndroid) {
            [
                Permission.bluetooth,
                Permission.bluetoothConnect,
                Permission.bluetoothScan
            ]
            .request().then((status) => _runningScan(bluetoothLeConstant, deviceNameHandle, listener));
        } else {
            _runningScan(bluetoothLeConstant, deviceNameHandle, listener);
        }

        return this;
    }

    /// The function `stop()` cancels a listener.
    stop() => _listener.cancel();

    /// The `_runningScan` function scans for Bluetooth devices and generates data
    /// based on the device name and manufacturer data.
    ///
    /// Args:
    ///   bluetoothLeConstant (BluetoothLeConstant): The `bluetoothLeConstant`
    /// parameter is an object of type `BluetoothLeConstant`. It likely contains
    /// constant values or configurations related to Bluetooth Low Energy (BLE)
    /// communication.
    ///   deviceNameHandle (List<String>): A list of device names that need to be
    /// handled during the scan.
    ///   listener (BluetoothLeCallback): The `listener` parameter is an instance of
    /// the `BluetoothLeCallback` interface or class. It is used to provide
    /// callbacks for various events that occur during the scanning process. The
    /// `BluetoothLeCallback` interface or class likely contains methods such as
    /// `onDisabled()`, `onTimeout()`, and
    ///
    /// Returns:
    ///   There is no explicit return statement in the given code snippet.
    /// Therefore, the method does not return any value.
    _runningScan(BluetoothLeConstant bluetoothLeConstant, List<String> deviceNameHandle, BluetoothLeCallback listener) {
        _flutterReactiveBle.statusStream.listen((status) {
            if (status == BleStatus.poweredOff) {
                listener.onDisabled();
            }
        });

        _listener = _flutterReactiveBle.scanForDevices(withServices: []).listen((result) {
            if (deviceNameHandle.contains(result.name)) {
                _generateData(bluetoothLeConstant, result.manufacturerData, listener);

                if (_useTimeout) {
                    _scheduler.listener(SchedulerListener(
                        onTick: (packet) {
                            listener.onTimeout();
                            return true;
                        },
                        onTickDone: (packet) {},
                        onTickFail: (packet) {}
                    ));
                    _scheduler.stop();
                    _scheduler.always(false).run(Duration(seconds: _secondTimeoutTime));
                }
            }
        }, onError: (exception, stacktrace) {});
    }

    /// The function `_generateData` takes in a constant, a list of bytes, and a
    /// callback listener, and based on the constant value, it generates either a
    /// hex or text output from the bytes and passes it to the listener.
    ///
    /// Args:
    ///   constant (BluetoothLeConstant): The constant parameter is of type
    /// BluetoothLeConstant, which is an enum that represents the type of result to
    /// generate. It can have two possible values: HEX_RESULT or TEXT_RESULT.
    ///   bytes (List<int>): A list of integers representing the bytes of data
    /// received from a Bluetooth Low Energy device.
    ///   listener (BluetoothLeCallback): The `listener` parameter is an instance of
    /// the `BluetoothLeCallback` interface or class. It is used to receive the
    /// generated data from the `_generateData` method. The `BluetoothLeCallback`
    /// interface or class should define a method called `onLeReceived` which takes
    /// a single parameter representing
    _generateData(BluetoothLeConstant constant, List<int> bytes, BluetoothLeCallback listener) {
        try {
            if (constant == BluetoothLeConstant.HEX_RESULT) {
                listener.onLeReceived(_generateHex(bytes));
            } else if (constant == BluetoothLeConstant.TEXT_RESULT) {
                String output = '';
                String hexaDes = _generateHex(bytes);

                for (int k = 0; k < hexaDes.length; k += 2) {
                    String str = hexaDes.substring(k, k + 2);
                    output += String.fromCharCode(int.parse(str, radix: 16));
                }

                listener.onLeReceived(output.toString());
            }
        } catch (exception, stacktrace) {
            print('$exception -> $stacktrace');
        }
    }

    /// The `_generateHex` function takes a list of integers representing bytes and
    /// returns a string representing the hexadecimal values of those bytes.
    ///
    /// Args:
    ///   bytes (List<int>): A list of integers representing bytes.
    ///
    /// Returns:
    ///   a string representation of the hexadecimal values of the bytes in the
    /// input list.
    String _generateHex(List<int> bytes) {
        List hexChars = [];
        hexChars.length = bytes.length * 2;
        List<String> hexArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];

        for (int j = 0; j < bytes.length; j++) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }

        return hexChars.join();
    }
}

/// The `enum BluetoothLeConstant` is defining an enumeration that represents two
/// possible constant values: `HEX_RESULT` and `TEXT_RESULT`. This enumeration is
/// used to specify the type of result that will be received from the Bluetooth Low
/// Energy (BLE) device. The `HEX_RESULT` indicates that the result will be in
/// hexadecimal format, while the `TEXT_RESULT` indicates that the result will be in
/// text format. This enumeration is used in the `BluetoothLeService` class to
/// determine how to process and handle the received data from the BLE device.
enum BluetoothLeConstant {
    HEX_RESULT,
    TEXT_RESULT
}

/// The BluetoothLeCallback class is used to define callback functions for receiving
/// data, handling disabled Bluetooth, and handling timeouts in a Bluetooth Low
/// Energy connection.
class BluetoothLeCallback {
    Function(String data) onLeReceived;
    Function() onDisabled;
    Function() onTimeout;

    BluetoothLeCallback({required this.onLeReceived, required this.onDisabled, required this.onTimeout});
}