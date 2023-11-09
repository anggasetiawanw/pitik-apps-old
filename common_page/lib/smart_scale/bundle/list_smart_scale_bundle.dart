// ignore_for_file: slash_for_doc_comments

import 'package:common_page/smart_scale/list_smart_scale/list_smart_scale_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 08/09/2023
 */

class ListSmartScaleBundle {

    Function() getCoop;
    Function() isShowWeighingButton;
    Function(ListSmartScaleController controller) onGetSmartScaleListData;
    Function(ListSmartScaleController controller, int index) onCreateCard;
    Function() getWeighingBundle;

    ListSmartScaleBundle({required this.getCoop, required this.isShowWeighingButton, required this.onGetSmartScaleListData, required this.onCreateCard, required this.getWeighingBundle});
}