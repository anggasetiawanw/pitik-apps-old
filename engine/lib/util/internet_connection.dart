import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../ui/network_service/network_service_activity.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.id>
 *@create date 31/07/23
 */

class NetworkStatusService extends GetxService {
    bool isInitial = true;
    NetworkStatusService() {
        // InternetConnectionChecker().onStatusChange.listen(
        //         (status) async {
        //         _getNetworkStatus(status);
        //     },
        // );
    }

    void _getNetworkStatus(InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
            _validateSession(); //after internet connected it will redirect to home page
        } else {
            Get.dialog(NetworkErrorItem(), useSafeArea: false); // If internet loss then it will show the NetworkErrorItem widget
        }
    }

    void _validateSession() async {
        if(isInitial) {
            isInitial = false;
            Get.offNamedUntil('/', (_)=> false);
        } else {
            // Auth? auth = await AuthImpl().get();
            // UserGoogle? userGoogle = await UserGoogleImpl().get();
            // Profile? userProfile = await ProfileImpl().get();
            // if (auth == null || userGoogle == null ||userProfile == null ) {
            //     Get.offNamedUntil(RoutePage.loginPage, (_)=> false);
            // } else {
            //     GlobalVar.auth = auth;
            //     GlobalVar.userGoogle = userGoogle;
            //     GlobalVar.profileUser = userProfile;
            //     Get.back();
            // }
        }
    }
}

class StreamInternetConnection {
    static void init() async {
        Get.put<NetworkStatusService>(NetworkStatusService(), permanent: true);
    }
}