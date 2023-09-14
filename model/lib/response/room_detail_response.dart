import '../coop_model.dart';
import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class RoomDetailResponse {

    int code;
    Coop? data;

    RoomDetailResponse({required this.code, required this.data});

    static RoomDetailResponse toResponseModel(Map<String, dynamic> map) {
        return RoomDetailResponse(
            code: map['code'],
            data: Mapper.child<Coop>(map['data'])
        );
    }
}