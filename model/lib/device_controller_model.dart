import '../engine_library.dart';
import 'controller_data_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class DeviceController{

    @IsChild()
    ControllerData? growthDay;

    @IsChild()
    ControllerData? fan;

    @IsChild()
    ControllerData? heater;

    @IsChild()
    ControllerData? cooler;

    @IsChild()
    ControllerData? lamp;

    @IsChild()
    ControllerData? alarm;

    @IsChild()
    ControllerData? resetTime;

    DeviceController({this.growthDay, this.fan,this.heater, this.cooler, this.lamp, this.alarm,
        this.resetTime});

    static DeviceController toResponseModel(Map<String, dynamic> map) {

        return DeviceController(
            growthDay: Mapper.child<ControllerData>(map['growthDay']),
            fan: Mapper.child<ControllerData>(map['fan']),
            heater: Mapper.child<ControllerData>(map['heater']),
            cooler: Mapper.child<ControllerData>(map['cooler']),
            lamp: Mapper.child<ControllerData>(map['lamp']),
            alarm: Mapper.child<ControllerData>(map['alarm']),
            resetTime: Mapper.child<ControllerData>(map['resetTime']),
        );
    }
}