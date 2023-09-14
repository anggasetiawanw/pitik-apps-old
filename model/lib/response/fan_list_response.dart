import '../device_setting_model.dart';
import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class FanListResponse {

    int code;

    @IsChildren()
    List<DeviceSetting?>? data;

    FanListResponse({required this.code, required this.data});

    static FanListResponse toResponseModel(Map<String, dynamic> map) {
        return FanListResponse(
            code: map['code'],
            data: Mapper.children<DeviceSetting>(map['data']),
        );
    }
}