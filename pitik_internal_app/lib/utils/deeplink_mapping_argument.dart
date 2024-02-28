import 'dart:convert';

import 'package:engine/util/mapper/mapper.dart';
import 'package:get/get.dart';
import 'package:model/internal_app/opname_model.dart';
import 'package:model/internal_app/terminate_model.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class DeepLinkUtils {
  static Future<void> process(String pushNotificationPayload) async {
    if (pushNotificationPayload.isNotEmpty) {
      Map<String, dynamic> payload = jsonDecode(pushNotificationPayload);
      if (payload['request'] != null) {
        payload = jsonDecode(payload['request']);
      }
      Constant.pushNotifPayload.value = "";
      switch (payload['target']) {
        case "id.pitik.mobile.mobile_flutter.detail_disposal":
          TerminateModel? terminateModel = Mapper.child<TerminateModel>(payload['additionalParameters']["disposal"]);
          if (terminateModel != null) {
            // _readNotif(payload['id']);
            await Get.toNamed(RoutePage.terminateDetail, arguments: terminateModel);
          }
          break;
        case "id.pitik.mobile.mobile_flutter.detail_opname":
          OpnameModel? opnameModel = Mapper.child<OpnameModel>(payload['additionalParameters']["opname"]);
          if (opnameModel != null) {
            // _readNotif(payload['id']);
            await Get.toNamed(RoutePage.stockDetail, arguments: opnameModel);
          }
          break;
        default:
          break;
      }
    }
  }
  // TODO : For Future if `ID` of Notification has been implemented
//   static void _readNotif(String id) {
//     Service.push(
//         apiKey: ApiMapping.userApi,
//         service: ListApi.updateNotification,
//         context: Get.context!,
//         body: [Constant.auth!.token, Constant.auth!.id, "v2/notifications/read/$id", ""],
//         listener: ResponseListener(
//             onResponseDone: (code, message, body, id, packet) {},
//             onResponseFail: (code, message, body, id, packet) {
//               Get.snackbar(
//                 "Pesan",
//                 "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
//                 snackPosition: SnackPosition.TOP,
//                 colorText: Colors.white,
//                 backgroundColor: Colors.red,
//               );
//             },
//             onResponseError: (exception, stacktrace, id, packet) {
//               Get.snackbar(
//                 "Pesan",
//                 "Terjadi Kesalahan Internal",
//                 snackPosition: SnackPosition.TOP,
//                 colorText: Colors.white,
//                 backgroundColor: Colors.red,
//               );
//             },
//             onTokenInvalid: () => Constant.invalidResponse()));
//   }
}
