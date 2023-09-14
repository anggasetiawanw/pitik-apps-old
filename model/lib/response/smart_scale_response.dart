import '../engine_library.dart';
import '../smart_scale/smart_scale_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class SmartScaleResponse {

    int code;

    @IsChild()
    SmartScale? data;

    SmartScaleResponse({required this.code, this.data});

    static SmartScaleResponse toResponseModel(Map<String, dynamic> map) {
        return SmartScaleResponse(
            code: map['code'],
            data: Mapper.child<SmartScale>(map['data'])
        );
    }
}