import '../coop_model.dart';
import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class CoopListResponse {

    int code;

    @IsChildren()
    List<Coop?>? data;

    CoopListResponse({required this.code, required this.data});

    static CoopListResponse toResponseModel(Map<String, dynamic> map) {
        return CoopListResponse(
            code: map['code'],
            data: Mapper.children<Coop>(map['data']),
        );
    }
}