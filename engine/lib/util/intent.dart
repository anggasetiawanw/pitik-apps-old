
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

    toWithFeatureFlag({required String target, dynamic arguments, Function(dynamic)? then}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.toNamed(targetFix, arguments: arguments)!.then((value) => then != null ? then(value) : {});
    }

    offWithFeatureFlag({required String target, dynamic arguments, Function(dynamic)? then}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.offNamed(targetFix, arguments: arguments)!.then((value) => then != null ? then(value) : {});
    }

    offUntilWithFeatureFlag({required String target, dynamic arguments, required bool routeOff, Function(dynamic)? then}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.offNamedUntil(targetFix, (Route<dynamic> route) => routeOff, arguments: arguments)!.then((value) => then != null ? then(value) : {});
    }

    offAllWithFeatureFlag({required String target, dynamic arguments, Function(dynamic)? then}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.offAllNamed(targetFix, arguments: arguments)!.then((value) => then != null ? then(value) : {});
    }

    offAndToWithFeatureFlag({required String target, dynamic arguments, Function(dynamic)? then}) {
        String targetFix = '/$target${FirebaseRemoteConfig.instance.getValue(target).asString()}';
        Get.offAndToNamed(targetFix, arguments: arguments)!.then((value) => then != null ? then(value) : {});
    }
}