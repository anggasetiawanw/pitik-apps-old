import 'package:model/engine_library.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/place_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/04/23

@SetupModel
class VendorModel {
  String? id;
  String? name;
  String? vendorName;
  String? priceBasis;
  bool? status;
  String? type;

  @IsChild()
  Location? city;

  @IsChild()
  Location? district;

  @IsChild()
  Location? province;

  @IsChildren()
  List<OperationUnitModel?>? purchasableProducts;

  VendorModel({this.id, this.name, this.vendorName, this.priceBasis, this.status, this.city, this.district, this.province, this.purchasableProducts, this.type});

  static VendorModel toResponseModel(Map<String, dynamic> map) {
    return VendorModel(
        id: map['id'],
        name: map['name'],
        vendorName: map['vendorName'],
        priceBasis: map['priceBasis'],
        status: map['status'],
        city: Mapper.child<Location>(map["city"]),
        district: Mapper.child<Location>(map["district"]),
        province: Mapper.child<Location>(map["province"]),
        purchasableProducts: Mapper.children<OperationUnitModel>(map['purchasableProducts']),
        type: map['type'],
    );
  }
}