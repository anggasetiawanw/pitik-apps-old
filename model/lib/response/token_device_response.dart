import 'package:model/engine_library.dart';
import 'package:model/token_device.dart';

@SetupModel
class TokenDeviceResponse {
    int? code;
    TokenDevice? data;

    TokenDeviceResponse({this.code, required this.data});

    static TokenDeviceResponse toResponseModel(Map<String, dynamic> map) {
        return TokenDeviceResponse(
            code: map['code'],
            data: Mapper.child<TokenDevice>(map['data'])
        );
    }
}