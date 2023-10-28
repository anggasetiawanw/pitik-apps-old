import 'package:model/engine_library.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';

@SetupModel
class OpnameModel {
  String? id;

  @IsChild()
  OperationUnitModel? operationUnit;
  String? code;
  String? operationUnitId;
  String? status;
  String? confirmedDate;
  String? reviewerId;
  double? totalWeight;
  int? totalQuantity;
  @IsChild()
  SalesPerson? reviewer;

  @IsChildren()
  List<Products?>? products;

  String? createdDate;
  String? createdBy;
  String? modifiedDate;
  String? modifiedBy;

  OpnameModel({
    this.id,
    this.code,
    this.operationUnit,
    this.confirmedDate,
    this.createdDate,
    this.createdBy,
    this.modifiedBy,
    this.modifiedDate,
    this.status,
    this.operationUnitId,
    this.products,
    this.totalWeight,
    this.totalQuantity,
    this.reviewerId,
    this.reviewer,
  });

  static OpnameModel toResponseModel(Map<String, dynamic> map) {
    if (map['totalWeight'] is int) {
      map['totalWeight'] = map['totalWeight'].toDouble();
    }
    return OpnameModel(
      id: map['id'],
      code: map['code'],
      operationUnit: Mapper.child<OperationUnitModel>(map['operationUnit']),
      confirmedDate: map['confirmedDate'],
      createdDate: map['createdDate'],
      createdBy: map['createdBy'],
      modifiedDate: map['modifiedDate'],
      modifiedBy: map['modifiedBy'],
      status: map['status'],
      operationUnitId: map['operationUnitId'],
      products: Mapper.children<Products>(map['products']),
      totalWeight: map['totalWeight'],
      totalQuantity: map['totalQuantity'],
      reviewerId: map['reviewerId'],
      reviewer: Mapper.child<SalesPerson>(map['reviewer']),
    );
  }
}
