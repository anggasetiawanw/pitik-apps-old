import 'package:model/engine_library.dart';

@SetupModel
class TokenDevice {
    String? id;
    String? token;

    TokenDevice({this.id, this.token});

    static TokenDevice toResponseModel(Map<String, dynamic> map) {
        return TokenDevice(
            id: map['id'],
            token: map['token']
        );
    }
}