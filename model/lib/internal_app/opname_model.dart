import 'package:model/engine_library.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/product_model.dart';

@SetupModel
class OpnameModel {
    String? id;

    @IsChild()
    OperationUnitModel? operationUnit;
    String? code;
    String? operationUnitId;
    String? status;
    String? confirmedDate;

    @IsChildren()
    List<Products?>? products;

    String? createdDate;
    String? createdBy;
    String? modifiedDate;
    String? modifiedBy;

    OpnameModel({this.id,this.code, this.operationUnit,this.confirmedDate, this.createdDate, this.createdBy, this.modifiedBy, this.modifiedDate, this.status, this.operationUnitId, this.products});

    static OpnameModel toResponseModel(Map<String, dynamic> map) {
        return OpnameModel(
            id: map['id'],
            code : map['code'],
            operationUnit: Mapper.child<OperationUnitModel>(map['operationUnit']),
            confirmedDate: map['confirmedDate'],
            createdDate: map['createdDate'],
            createdBy: map['createdcreatedBy_by'],
            modifiedDate: map['modifiedDate'],
            modifiedBy: map['modifiedBy'],
            status: map['status'],
            operationUnitId: map['operationUnitId'],
            products: Mapper.children<Products>(map['products']),
        );
    }
}