import '../engine_library.dart';
import '../realization_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class RealizationResponse {
  int? code;

  @IsChildren()
  List<Realization?> data;

  RealizationResponse({this.code, this.data = const []});

  static RealizationResponse toResponseModel(Map<String, dynamic> map) {
    return RealizationResponse(code: map['code'], data: Mapper.children<Realization>(map['data']));
  }
}
