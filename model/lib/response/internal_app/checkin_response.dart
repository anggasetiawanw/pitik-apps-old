import 'package:model/engine_library.dart';
import 'package:model/internal_app/checkin_model.dart';

@SetupModel
class CheckInResponse {
  int code;
  CheckInModel? data;

  CheckInResponse({required this.code, required this.data});

  static CheckInResponse toResponseModel(Map<String, dynamic> map) {
    return CheckInResponse(code: map['code'], data: Mapper.child<CheckInModel>(map['data']));
  }
}
