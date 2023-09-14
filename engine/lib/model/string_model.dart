import 'base_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.id>
 *@create date 31/07/23
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
