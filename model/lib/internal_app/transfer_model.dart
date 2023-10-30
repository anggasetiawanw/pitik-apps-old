import 'package:model/engine_library.dart';
import 'package:model/internal_app/goods_received_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/profile.dart';

import 'operation_unit_model.dart';

@SetupModel
class TransferModel {
  String? id;
  String? code;
  String? targetOperationUnitId;
  String? sourceOperationUnitId;
  String? status;
  String? driverId;

  @IsChild()
  OperationUnitModel? targetOperationUnit;

  @IsChild()
  OperationUnitModel? sourceOperationUnit;

  @IsChild()
  Profile? userCreator;

  @IsChild()
  Profile? userModifier;

  @IsChild()
  Profile? driver;

  @IsChildren()
  List<Products?>? products;

  @IsChild()
  GoodsReceived? goodsReceived;

  String? createdDate;
  String? createdBy;
  String? modifiedDate;
  String? modifiedBy;

  String? remarks;

  TransferModel({
    this.id,
    this.code,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
    this.createdDate,
    this.driverId,
    this.sourceOperationUnit,
    this.sourceOperationUnitId,
    this.status,
    this.targetOperationUnit,
    this.targetOperationUnitId,
    this.userCreator,
    this.userModifier,
    this.products,
    this.driver,
    this.goodsReceived,
    this.remarks,
  });

  static TransferModel toResponseModel(Map<String, dynamic> map) {
    return TransferModel(
      id: map['id'],
      code: map['code'],
      targetOperationUnitId: map['targetOperationUnitId'],
      sourceOperationUnitId: map['sourceOperationUnitId'],
      status: map['status'],
      driverId: map['driverId'],
      sourceOperationUnit: Mapper.child<OperationUnitModel>(map['sourceOperationUnit']),
      targetOperationUnit: Mapper.child<OperationUnitModel>(map['targetOperationUnit']),
      createdDate: map['createdDate'],
      createdBy: map['createdBy'],
      modifiedDate: map['modifiedDate'],
      modifiedBy: map['modifiedBy'],
      userCreator: Mapper.child<Profile>(map['userCreator']),
      userModifier: Mapper.child<Profile>(map['userModifier']),
      products: Mapper.children<Products>(map['products']),
      driver: Mapper.child<Profile>(map['driver']),
      goodsReceived: Mapper.child<GoodsReceived>(map['goodsReceived']),
      remarks: map['remarks'],
    );
  }
}
