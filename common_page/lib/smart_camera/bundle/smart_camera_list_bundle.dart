
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 10/11/2023

class SmartCameraBundle<T extends GetxController> {
    Coop getCoop;
    String routeHistoryDetail;
    String basePath;
    int? day;
    Function(T) onGetData;
    bool isCanTakePicture;
    SmartCameraBundle({required this.getCoop, required this.routeHistoryDetail, required this.basePath, this.day, required this.onGetData, this.isCanTakePicture = true});
}