import '../engine_library.dart';
import '../sapronak_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class SapronakResponse {
  @IsChildren()
  List<Sapronak?> data;

  SapronakResponse({this.data = const []});

  static SapronakResponse toResponseModel(Map<String, dynamic> map) {
    return SapronakResponse(data: Mapper.children<Sapronak>(map['data']));
  }
}
