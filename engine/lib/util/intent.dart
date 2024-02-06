
// ignore_for_file: slash_for_doc_comments

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class Intent {

    toWithFeatureFlag({required String target, dynamic arguments}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.toNamed(targetFix, arguments: arguments);
    }

    offWithFeatureFlag({required String target, dynamic arguments}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.offNamed(targetFix, arguments: arguments);
    }

    offUntilWithFeatureFlag({required String target, dynamic arguments, required bool routeOff}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.offNamedUntil(targetFix, (Route<dynamic> route) => routeOff, arguments: arguments);
    }

    offAllWithFeatureFlag({required String target, dynamic arguments}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.offAllNamed(targetFix, arguments: arguments);
    }

    offAndToWithFeatureFlag({required String target, dynamic arguments}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.offAndToNamed(targetFix, arguments: arguments);
    }
}