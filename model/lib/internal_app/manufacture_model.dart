
import 'package:model/engine_library.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/product_model.dart';

@SetupModel
class ManufactureModel {
    String? id;
    String? code;
    String? operationUnitId;
    String? status;
    String? createdDate;
    String? createdBy;
    String? modifiedDate;
    String? modifiedBy;
    
    @IsChild()
    OperationUnitModel? operationUnit;

    @IsChild()
    Products? input;
    @IsChildren()
    List<Products?>? output;

    ManufactureModel({this.id, this.status, this.createdDate, this.createdBy, this.modifiedBy, this.modifiedDate, this.operationUnit, this.input, this.output, this.operationUnitId, this.code});

    static ManufactureModel toResponseModel(Map<String, dynamic> map) {
        return ManufactureModel(
            id: map['id'],
            status : map['status'],
            createdDate: map['createdDate'],
            createdBy: map['createdBy'],
            modifiedBy: map['modifiedBy'],
            modifiedDate: map['modifiedDate'],
            operationUnit: Mapper.child<OperationUnitModel>(map['operationUnit']),
            input: Mapper.child<Products>(map['input']), 
            output: Mapper.children<Products>(map['output']),  
            operationUnitId: map['operationUnitId'],
            code: map['code']
        );
    }
}