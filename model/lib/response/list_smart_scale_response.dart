import '../engine_library.dart';
import '../smart_scale/smart_scale_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class ListSmartScaleResponse {

    int code;

    @IsChildren()
    List<SmartScale?> data;

    ListSmartScaleResponse({required this.code, this.data = const []});

    static ListSmartScaleResponse toResponseModel(Map<String, dynamic> map) {
        return ListSmartScaleResponse(
            code: map['code'],
            data: Mapper.children<SmartScale>(map['data'])
        );
    }
}