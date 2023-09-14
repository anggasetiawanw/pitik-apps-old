import '../device_setting_model.dart';
import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class CoolerResponse {

    int code;
    DeviceSetting? data;

    CoolerResponse({required this.code, required this.data});

    static CoolerResponse toResponseModel(Map<String, dynamic> map) {
        return CoolerResponse(
            code: map['code'],
            data: Mapper.child<DeviceSetting>(map['data'])
        );
    }
}