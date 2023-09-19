
import 'package:model/engine_library.dart';
import 'package:model/internal_app/place_model.dart';
import 'package:model/internal_app/product_model.dart';

import 'branch_model.dart';
import 'jagal_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/04/23

@SetupModel
class OperationUnitModel {
    String? id;
    String? operationUnitName;
    String? type;
    String? category;
    String? plusCode;
    double? latitude;
    double? longitude;
    bool? status;

    @IsChild()
    Location? city;

    @IsChild()
    Location? district;

    @IsChild()
    Location? province;  

    @IsChild()
    BranchModel? branch;  

    @IsChild()
    JagalModel? jagalData;

    @IsChildren()
    List<Products?>? purchasableProducts;

  OperationUnitModel({this.id, this.operationUnitName, this.type, this.city, this.district, this.province, this.status, this.latitude, this.longitude, this.plusCode, this.category, this.branch, this.jagalData,this.purchasableProducts});

  static OperationUnitModel toResponseModel(Map<String, dynamic> map) {
    return OperationUnitModel(
        id: map['id'],
        operationUnitName: map['operationUnitName'],
        type: map['type'],
        plusCode: map['plusCode'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        status: map['isArchived'],
        city: Mapper.child<Location>(map["city"]),
        district: Mapper.child<Location>(map["district"]),
        province: Mapper.child<Location>(map["province"]),  
        branch: Mapper.child<BranchModel>(map["branch"]),
        jagalData: Mapper.child<JagalModel>(map["jagalData"]),
        purchasableProducts: Mapper.children<Products>(map["purchasableProducts"]),
        category: map["category"]    
    );
  }
}