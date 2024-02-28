import 'package:engine/util/mapper/mapper.dart';
import 'package:model/controller_data_model.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_setting_model.dart';
import 'package:model/device_summary_model.dart';
import '../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 05/10/2023

class DeeplinkMappingArguments {
  static List<dynamic> createArguments({required String target, required Map<String, dynamic> additionalParameters, bool isPplApp = true}) {
    Coop? coop;
    if (additionalParameters.containsKey('coop')) {
      coop = Mapper.child<Coop>(additionalParameters['coop']);
    }

    switch (target) {
      case 'id.pitik.mobile.smartcontroller.ui.activity.SmartControllerDashboardActivity':
        final Device? device = Mapper.child<Device>(additionalParameters['floor']);
        return [coop, device, 'v2/controller/coop/', RoutePage.smartMonitorController];
      case 'id.pitik.mobile.smartcontroller.ui.activity.MonitorActivity':
        final DeviceSummary? deviceSummary = Mapper.child<DeviceSummary>(additionalParameters['deviceSummary']);
        return [coop, deviceSummary, additionalParameters['deviceId'], additionalParameters['coopId']];
      case 'id.pitik.mobile.smartcontroller.ui.activity.FanActivity':
        final Device? device = Mapper.child<Device>(additionalParameters['floor']);
        final ControllerData? controllerFan = Mapper.child<ControllerData>(additionalParameters['fan']);
        return [device, controllerFan, 'v2/controller/coop/', false];
      case 'id.pitik.mobile.smartcontroller.ui.activity.FanDetailActivity':
        final Device? device = Mapper.child<Device>(additionalParameters['floor']);
        final ControllerData? controllerFan = Mapper.child<ControllerData>(additionalParameters['fan']);
        final DeviceSetting? deviceSetting = Mapper.child<DeviceSetting>(additionalParameters['fanDetail']);
        return [deviceSetting, device, controllerFan, 'v2/controller/coop/', false];
      case 'id.pitik.mobile.smartcontroller.ui.activity.GrowthDayActivity':
        final Device? device = Mapper.child<Device>(additionalParameters['floor']);
        final ControllerData? controllerGrowthDay = Mapper.child<ControllerData>(additionalParameters['growthDay']);
        return [device, controllerGrowthDay, 'v2/controller/coop/', false];
      case 'id.pitik.mobile.smartcontroller.ui.activity.CoolerActivity':
        final Device? device = Mapper.child<Device>(additionalParameters['floor']);
        final ControllerData? controllerCooler = Mapper.child<ControllerData>(additionalParameters['cooler']);
        return [device, controllerCooler, 'v2/controller/coop/', false];
      case 'id.pitik.mobile.smartcontroller.ui.activity.LampActivity':
        final Device? device = Mapper.child<Device>(additionalParameters['floor']);
        final ControllerData? controllerLamp = Mapper.child<ControllerData>(additionalParameters['lamp']);
        return [device, controllerLamp, 'v2/controller/coop/', false];
      case 'id.pitik.mobile.ui.activity.ChangePasswordActivity':
        return [false, isPplApp ? RoutePage.coopDashboard : RoutePage.farmingDashboard];
      case 'id.pitik.mobile.ListOrderActivity':
        return [coop, false];
      default:
        return coop != null ? [coop] : [];
    }
  }
}
