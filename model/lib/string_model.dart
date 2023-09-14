import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class StringModel {
    String? data;
    StringModel({this.data});

    static StringModel toResponseModel(Map<String, dynamic> map) {
        return StringModel(
            data: map['data']
        );
    }
}
