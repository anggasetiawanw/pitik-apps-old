import '../device_model.dart';
import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class DeviceDetailResponse {

    int code;
    Device? data;

    DeviceDetailResponse({required this.code, required this.data});

    static DeviceDetailResponse toResponseModel(Map<String, dynamic> map) {
        return DeviceDetailResponse(
            code: map['code'],
            data: Mapper.child<Device>(map['data'])
        );
    }
}