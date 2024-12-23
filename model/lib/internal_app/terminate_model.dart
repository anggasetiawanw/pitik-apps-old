import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';
import 'operation_unit_model.dart';

@SetupModel
class TerminateModel {
  String? id;
  String? code;
  String? status;
  String? operationUnitId;
  String? imageLink;
  String? createdDate;
  String? createdBy;
  String? modifiedDate;
  String? modifiedBy;
  String? reviewerId;
  String? confirmedDate;
  String? reviewedDate;
  @IsChild()
  SalesPerson? reviewer;

  @IsChild()
  OperationUnitModel? operationUnit;

  @IsChild()
  Products? product;

  TerminateModel({
    this.id,
    this.code,
    this.status,
    this.operationUnitId,
    this.imageLink,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
    this.operationUnit,
    this.product,
    this.reviewerId,
    this.reviewer,
    this.confirmedDate,
    this.reviewedDate,
  });

  static TerminateModel toResponseModel(Map<String, dynamic> map) {
    return TerminateModel(
      id: map['id'],
      code: map['code'],
      status: map['status'],
      operationUnitId: map['operationUnitId'],
      imageLink: map['imageLink'],
      createdDate: map['createdDate'],
      createdBy: map['createdBy'],
      modifiedDate: map['modifiedDate'],
      modifiedBy: map['modifiedBy'],
      operationUnit: Mapper.child<OperationUnitModel>(map['operationUnit']),
      product: Mapper.child<Products>(map['product']),
      reviewerId: map['reviewerId'],
      reviewer: Mapper.child<SalesPerson>(map['reviewer']),
      confirmedDate: map['confirmedDate'],
      reviewedDate: map['reviewedDate'],
    );
  }
}
