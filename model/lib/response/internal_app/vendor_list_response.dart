import 'package:model/engine_library.dart';
import 'package:model/internal_app/vendor_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 11/05/23

@SetupModel
class VendorListResponse {
  int? code;
  List<VendorModel?> data;

  VendorListResponse({this.code, required this.data});

  static VendorListResponse toResponseModel(Map<String, dynamic> map) => VendorListResponse(
        code: map['code'],
        data: Mapper.children<VendorModel>(map['data']),
      );
}
