
// ignore_for_file: slash_for_doc_comments

import 'package:common_page/smart_scale/detail_smart_scale/detail_smart_scale_controller.dart';
import 'package:common_page/smart_scale/weighing_smart_scale/smart_scale_weighing_controller.dart';
import 'package:model/auth_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 08/09/2023
 */

class SmartScaleWeighingBundle {

    Function() routeSave;
    Function() routeEdit;
    Function() routeDetail;
    Function(SmartScaleWeighingController controller, Auth auth, bool isEdit) getBodyRequest;
    Function(DetailSmartScaleController controller, Auth auth) getBodyDetail;
    bool saveToDb;
    String? weighingNumber;
    Function(dynamic)? onGetSubmitResponse;

    SmartScaleWeighingBundle({
        required this.routeSave,
        required this.routeEdit,
        required this.routeDetail,
        required this.getBodyRequest,
        required this.getBodyDetail,
        this.saveToDb = true,
        this.weighingNumber,
        this.onGetSubmitResponse
    });
}