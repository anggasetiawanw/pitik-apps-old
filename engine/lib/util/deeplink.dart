
// ignore_for_file: slash_for_doc_comments

import 'dart:convert';

import 'package:engine/model/firebase_message_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class Deeplink {

    static toTarget({required String target, dynamic arguments}) {
        List<dynamic> deeplinkRemoteConfig = jsonDecode(FirebaseRemoteConfig.instance.getValue('deeplink_target').asString());
        for (var element in deeplinkRemoteConfig) {
            FirebaseMessageModel firebaseMessageModel = FirebaseMessageModel.fromJson(element);
            if (firebaseMessageModel.target == target) {
                Get.toNamed(firebaseMessageModel.route, arguments: arguments);
                break;
            }
        }
    }
}