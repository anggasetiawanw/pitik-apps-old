import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CheckVersion {
  String appStoreId;
  String androidAppBundleId;

  CheckVersion({required this.appStoreId, required this.androidAppBundleId});

  Future<void> check(BuildContext context) async {
    String version = "";
    String suggestionVersion = "";
    if (Platform.isAndroid) {
      version = FirebaseRemoteConfig.instance.getString("pitik_android_version");
      suggestionVersion = FirebaseRemoteConfig.instance.getString("pitik_android_suggestion");
      if (version.isNotEmpty && suggestionVersion.isNotEmpty) {
        await _checkVersionUpdate(version, suggestionVersion);
      }
    } else {
      version = FirebaseRemoteConfig.instance.getString("pitik_ios_version");
      suggestionVersion = FirebaseRemoteConfig.instance.getString("pitik_ios_suggestion");
      if (version.isNotEmpty && suggestionVersion.isNotEmpty) {
        await _checkVersionUpdate(version, suggestionVersion);
      }
    }
  }

  Future<void> _checkVersionUpdate(String version, String suggestionVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    bool mustBeUpdate = false;
    bool forceUpdate = false;

    List<String> verCurr = packageInfo.version.split(".");
    List<String> verSuggestion = suggestionVersion.split(".");

    if (double.parse('${verCurr[0]}.${verCurr[1]}') <= double.parse('${verSuggestion[0]}.${verSuggestion[1]}')) {
      if (version != "" && version != "0.0.0") {
        List<String> verPlay = version.split(".");
        // print("$verPlay and $verCurr");
        if (int.parse(verPlay[0]) > int.parse(verCurr[0])) {
          mustBeUpdate = true;
          forceUpdate = true;
        } else if (int.parse(verPlay[0]) == int.parse(verCurr[0])) {
          if (int.parse(verPlay[1]) > int.parse(verCurr[1])) {
            mustBeUpdate = true;
          }
        }
      }

      if (mustBeUpdate) {
        if (forceUpdate) {
          _popupDialogForce(isForceUpdate: true);
        } else {
          _popupDialogForce(isForceUpdate: false);
        }
      }
    }
  }

  void _updateApp() {
    OpenStore.instance.open(
      appStoreId: appStoreId,
      androidAppBundleId: androidAppBundleId,
    );
  }

  void _popupDialogForce({required bool isForceUpdate}) {
    Get.dialog(
        Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 24,
                      color: Color(0xFFF47B20),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Informasi!",
                      style: TextStyle(color: Colors.black, fontFamily: 'Montserrat_Medium', fontWeight: FontWeight.w700, fontSize: 16, decoration: TextDecoration.none),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Versi terbaru tersedia, mohon lakukan pembaruan aplikasi.",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat_Medium',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                if (isForceUpdate)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 32,
                        width: 100,
                        color: Colors.transparent,
                      ),
                      SizedBox(width: 120, child: _buttonOk(onPress: () => _updateApp(), label: "Update")),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 120, child: _buttonNo(onPress: () => Get.back(), label: "Tutup")),
                      SizedBox(width: 120, child: _buttonOk(onPress: () => _updateApp(), label: "Update")),
                    ],
                  ),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }

  Widget _buttonOk({required Function() onPress, required String label}) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF47B20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontFamily: 'Montserrat_Medium', fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );
  }

  Widget _buttonNo({required Function() onPress, required String label}) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFFFFF).withOpacity(1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: Color(0xFFF47B20)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFFF47B20), fontFamily: 'Montserrat_Medium', fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );
  }
}
