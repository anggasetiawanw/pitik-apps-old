import '../engine_library.dart';
import '../procurement_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class ProcurementDetailResponse {

    @IsChild()
    Procurement? data;

    ProcurementDetailResponse({this.data});

    static ProcurementDetailResponse toResponseModel(Map<String, dynamic> map) {
        return ProcurementDetailResponse(
            data: Mapper.child<Procurement>(map['data'])
        );
    }
}