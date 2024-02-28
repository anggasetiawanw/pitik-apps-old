// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class NetworkStatusService extends GetxService {
  bool isInitial = true;
  NetworkStatusService({bool showDialog = true, Function()? route, Function()? notificationDisconnected}) {
    InternetConnectionChecker().onStatusChange.listen(
      (status) async {
        if (showDialog) {
          _getNetworkStatus(status, route, notificationDisconnected);
        }
      },
    );
  }

  void _getNetworkStatus(InternetConnectionStatus status, Function()? route, Function()? notificationDisconnected) {
    if (status == InternetConnectionStatus.connected) {
      _validateSession(route); //after internet connected it will redirect to home page
    } else {
      notificationDisconnected ?? ();
    }
  }

  void _validateSession(Function()? route) async {
    if (isInitial) {
      isInitial = false;
      Get.offNamedUntil('/', (_) => false);
    } else {
      route ?? ();
    }
  }
}

class StreamInternetConnection {
  static void init({bool showDialog = true, Function()? route, Function()? notificationDisconnected}) async {
    Get.put<NetworkStatusService>(NetworkStatusService(showDialog: showDialog, route: route, notificationDisconnected: notificationDisconnected), permanent: true);
  }
}
