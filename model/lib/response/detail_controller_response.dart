import '../device_controller_model.dart';
import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class DetailControllerResponse {

    int code;
    DeviceController? data;

    DetailControllerResponse({required this.code, required this.data});

    static DetailControllerResponse toResponseModel(Map<String, dynamic> map) {
        return DetailControllerResponse(
            code: map['code'],
            data: Mapper.child<DeviceController>(map['data'])
        );
    }
}