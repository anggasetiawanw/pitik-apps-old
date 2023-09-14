import '../engine_library.dart';
import '../growth_day_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class GrowthDayResponse {

    int code;
    GrowthDay? data;

    GrowthDayResponse({required this.code, required this.data});

    static GrowthDayResponse toResponseModel(Map<String, dynamic> map) {
        return GrowthDayResponse(
            code: map['code'],
            data: Mapper.child<GrowthDay>(map['data'])
        );
    }
}