// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:components/edit_field_two_row/edit_field_two_row_controller.dart';
import 'package:components/multiple_dynamic_form_field/multiple_dynamic_form_field_controller.dart';
import 'package:components/multiple_form_field/multiple_form_field_controller.dart';
import 'package:components/stock_opname_field/stock_opname_field_controller.dart';
import 'package:components/stock_opname_two_field/stock_opname_two_field_controller.dart';
import 'package:components/switch_button/switch_button_controller.dart';
import 'package:components/switch_linear/switch_linar_controller.dart';
import 'package:components/table_field/table_field_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'button_fill/button_fill_controller.dart';
import 'button_outline/button_outline_controller.dart';
import 'card_camera/card_camera_controller.dart';
import 'card_floor/card_floor_controller.dart';
import 'card_sensor/card_sensor_controller.dart';
import 'date_time_field/datetime_field_controller.dart';
import 'edit_area_field/edit_area_field_controller.dart';
import 'edit_field/edit_field_controller.dart';
import 'edit_field_qr/edit_field_qrcode_controller.dart';
import 'expandable/expandable_controller.dart';
import 'expandable_device/expandable_device_controller.dart';
import 'expandable_monitor_real_time/expandable_monitor_real_time_controller.dart';
import 'graph_view/graph_view_controller.dart';
import 'item_decrease_temp/item_decrease_temperature_controller.dart';
import 'item_historical_smartcamera/item_historical_smartcamera_controller.dart';
import 'item_take_picture/item_take_picture_controller.dart';
import 'media_field/media_field_controller.dart';
import 'password_field/password_field_controller.dart';
import 'spinner_field/spinner_field_controller.dart';
import 'spinner_multi_field/spinner_multi_field_controller.dart';
import 'spinner_search/spinner_search_controller.dart';
import 'suggest_field/suggest_field_controller.dart';
import 'time_picker/time_picker_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class GetXCreator {

    static EditFieldController putEditFieldController(String tag) {
        return Get.put(EditFieldController(tag: tag), tag: tag);
    }

    static EditAreaFieldController putEditAreaFieldController(String tag) {
        return Get.put(EditAreaFieldController(tag: tag), tag: tag);
    }

    static PasswordFieldController putPasswordFieldController(String tag) {
        return Get.put(PasswordFieldController(tag: tag), tag: tag);
    }


    static ButtonFillController putButtonFillController(String tag) {
        return Get.put(ButtonFillController(tag: tag), tag: tag);
    }

    static ButtonOutlineController putButtonOutlineController(String tag) {
        return Get.put(ButtonOutlineController(tag: tag), tag: tag);
    }

    static SpinnerFieldController putSpinnerFieldController<T>(String tag) {
        return Get.put(SpinnerFieldController<T>(tag: tag), tag: tag);
    }

    static SpinnerMultiFieldController putSpinnerMultiFieldController<T>(String tag) {
        return Get.put(SpinnerMultiFieldController<T>(tag: tag), tag: tag);
    }

    static CardSensorController putCardSensorController(String tag, BuildContext context) {
        return Get.put(CardSensorController(tag: tag, context: context), tag: tag);
    }
    static CardCameraController putCardCameraController(String tag, BuildContext context) {
        return Get.put(CardCameraController(tag: tag, context: context), tag: tag);
    }

    static CardFloorController putCardFloorController(String tag, BuildContext context) {
        return Get.put(CardFloorController(tag: tag, context: context), tag: tag);
    }

    static EditFieldQRController putEditFieldQRController(String tag) {
        return Get.put(EditFieldQRController(tag: tag), tag: tag);
    }

    static ExpandableDeviceController putAccordionDeviceController(String tag, BuildContext context) {
        return Get.put(ExpandableDeviceController(tag: tag, context: context), tag: tag);
    }

    static ExpandableMonitorRealTimeController putAccordionMonitorRealTimeController(String tag, BuildContext context) {
        return Get.put(ExpandableMonitorRealTimeController(tag: tag, context: context), tag: tag);
    }

    static ExpandableController putAccordionController(String tag) {
        return Get.put(ExpandableController(tag: tag), tag: tag);
    }

    static ItemDecreaseTemperatureController putItemDecreaseController(String tag, BuildContext context) {
        return Get.put(ItemDecreaseTemperatureController(tag: tag, context: context), tag: tag);
    }

    static DateTimeFieldController putDateTimeFieldController(String tag) {
        return Get.put(DateTimeFieldController(tag: tag), tag: tag);
    }

    static SwitchButtonController putSwitchButtonController(String tag) {
        return Get.put(SwitchButtonController(tag: tag), tag: tag);
    }

    static GraphViewController putGraphViewController(String tag) {
        return Get.put(GraphViewController(tag: tag), tag: tag);
    }

    static TimePickerController putTimePickerController(String tag) {
        return Get.put(TimePickerController(tag: tag), tag: tag);
    }

    static ItemHistoricalSmartCameraController putHistoricalSmartCameraController(String tag, BuildContext context) {
        return Get.put(ItemHistoricalSmartCameraController(tag: tag, context: context), tag: tag);
    }

    static ItemTakePictureCameraController putItemTakePictureController(String tag, BuildContext context) {
        return Get.put(ItemTakePictureCameraController(tag: tag, context: context), tag: tag);
    }

    static MediaFieldController putMediaFieldController(String tag) {
        return Get.put(MediaFieldController(tag: tag), tag: tag);
    }

    static SpinnerSearchController putSpinnerSearchController<T>(String tag) {
        return Get.put(SpinnerSearchController<T>(tag: tag), tag: tag);
    }

    static SuggestFieldController putSuggestFieldController<T>(String tag) {
        return Get.put(SuggestFieldController<T>(tag: tag), tag: tag);
    }

    static EditFieldTwoRowController putEditFieldTwoRowController(String tag) {
        return Get.put(EditFieldTwoRowController(tag: tag), tag: tag);
    }
    static StockOpnameTwoFieldController putStockOpnameTwoField<T>(String tag) {
        return Get.put(StockOpnameTwoFieldController(tag: tag), tag: tag);
    }
    static StockOpnameFieldController putStockOpnameField<T>(String tag) {
        return Get.put(StockOpnameFieldController(tag: tag), tag: tag);
    }

    static TableFieldController putTableFieldController(String tag) {
        return Get.put(TableFieldController(tag: tag), tag: tag);
    }

    static MultipleFormFieldController putMultipleFormFieldController<T>(String tag) {
        return Get.put(MultipleFormFieldController<T>(tag: tag), tag: tag);
    }    
    static SwitchLinearController putSwitchLinearController(String tag) {
        return Get.put(SwitchLinearController(tag: tag), tag: tag);
    }

    static MultipleDynamicFormFieldController putMultipleDynamicFormFieldController<T>(String tag) {
        return Get.put(MultipleDynamicFormFieldController<T>(tag: tag), tag: tag);
    }
/*
    static SkuCardPurchaseController putSkuCardPurchaseController(String tag, BuildContext context) {
        return Get.put(SkuCardPurchaseController(tag: tag, context: context), tag: tag);
    }

    static SkuCardOrderController putSkuCardOrderController(String tag, BuildContext context) {
        return Get.put(SkuCardOrderController(tag: tag, context: context), tag: tag);
    }
    static SkuCardRemarkController putSkuCardRemarkController(String tag, BuildContext context) {
        return Get.put(SkuCardRemarkController(tag: tag, context: context), tag: tag);
    }
    static SkuRejectController putSkuCardRejectSO(String tag, List<Products?> products) {
        return Get.put(SkuRejectController(tag: tag, products: products), tag: tag,);
    }
    static SkuCardGrController putSkuCardGrOrder(String tag, List<Products?> products) {
        return Get.put(SkuCardGrController(tag: tag, products: products), tag: tag,);
    }*/
}