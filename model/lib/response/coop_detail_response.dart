import '../coop_model.dart';
import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class CoopDetailResponse {

    int code;
    Coop? data;

    CoopDetailResponse({required this.code, required this.data});

    static CoopDetailResponse toResponseModel(Map<String, dynamic> map) {
        return CoopDetailResponse(
            code: map['code'],
            data: Mapper.child<Coop>(map['data'])
        );
    }
}