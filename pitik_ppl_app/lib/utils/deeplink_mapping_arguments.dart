
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/controller_data_model.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_setting_model.dart';
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 05/10/2023

class DeeplinkMappingArguments {

    static List<dynamic> createArguments({required String target, required Map<String, dynamic> additionalParameters}) {
        Coop? coop;
        if (additionalParameters.containsKey('coop')) {
            coop = Mapper.child<Coop>(additionalParameters["coop"]);
        }

        switch (target) {
            case "id.pitik.mobile.smartcontroller.ui.activity.FanActivity":
                Device? device = Mapper.child<Device>(additionalParameters["floor"]);
                ControllerData? controllerFan = Mapper.child<ControllerData>(additionalParameters["fan"]);
                return [device, controllerFan, 'v2/controller/coop/', false];
            case "id.pitik.mobile.smartcontroller.ui.activity.FanDetailActivity":
                Device? device = Mapper.child<Device>(additionalParameters["floor"]);
                ControllerData? controllerFan = Mapper.child<ControllerData>(additionalParameters["fan"]);
                DeviceSetting? deviceSetting = Mapper.child<DeviceSetting>(additionalParameters["fanDetail"]);
                return [deviceSetting, device, controllerFan, 'v2/controller/coop/', false];
            case "id.pitik.mobile.ui.activity.ChangePasswordActivity":
                return [false, RoutePage.coopDashboard];
            case "id.pitik.mobile.ListOrderActivity":
                return [coop, false];
            default:
                return coop != null ? [coop] : [];
        }
    }
}