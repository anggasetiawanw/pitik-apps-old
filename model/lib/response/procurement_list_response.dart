import '../engine_library.dart';
import '../procurement_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class ProcurementListResponse {
  @IsChildren()
  List<Procurement?> data;

  ProcurementListResponse({this.data = const []});

  static ProcurementListResponse toResponseModel(Map<String, dynamic> map) {
    return ProcurementListResponse(data: Mapper.children<Procurement>(map['data']));
  }
}
