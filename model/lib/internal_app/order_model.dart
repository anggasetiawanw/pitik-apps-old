
import 'package:model/engine_library.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';
import 'package:model/profile.dart';

import 'operation_unit_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 11/05/23

@SetupModel
class Order{
  String? id;
  String? customerId;
  String? status;
  String? returnStatus;
  String? operationUnitId;
  String? salespersonId;
  String? createdDate;
  String? modifiedDate;
  String? code;
  String? type;
  String? paymentMethod;
  String? reason;
  int? totalQuantity;
  double? totalWeight;
  double? totalPrice;
  int? paymentAmount;
  double? latitude;
  double? longitude;
  String? returnReason;
  String? grStatus;


  @IsChild()
  Customer? customer;
  @IsChild()
  OperationUnitModel? operationUnit;
  @IsChildren()
  List<Products?>? products;
  @IsChildren()
  List<Products?>? returnedProducts;
  @IsChild()
  SalesPerson? salesperson;
  @IsChild()
  SalesPerson? userModifier;
  @IsChild()
  Profile? driver;
  @IsChildren()
  List<Products?>? productNotes;


  Order({this.id, this.customerId, this.status, this.operationUnitId, this.operationUnit, this.salespersonId, this.createdDate, this.customer, this.products, this.salesperson, this.modifiedDate,
    this.userModifier, this.code, this.returnStatus, this.driver, this.type, this.productNotes, this.totalWeight, this.totalQuantity, this.totalPrice, this.paymentMethod, this.paymentAmount, this.latitude, this.longitude, this.returnedProducts, this.reason, this.returnReason, this.grStatus});

  static Order toResponseModel(Map<String, dynamic> map) {
    if(map['totalWeight'] is int){
        map['totalWeight'] = map['totalWeight'].toDouble();
    }
    if(map['totalPrice'] is int){
        map['totalPrice'] = map['totalPrice'].toDouble();
    }
    return Order(
      id: map['id'],
      customerId: map['customerId'],
      status: map['status'],
      operationUnitId: map['operationUnitId'],
      salespersonId: map['salespersonId'],
      createdDate: map['createdDate'],
      modifiedDate: map['modifiedDate'],
      customer: Mapper.child<Customer>(map['customer']),
      operationUnit: Mapper.child<OperationUnitModel>(map['operationUnit']),
      salesperson: Mapper.child<SalesPerson>(map['salesperson']),
      userModifier: Mapper.child<SalesPerson>(map['userModifier']),
      products: Mapper.children<Products>(map['products']),
      code: map['code'],
      returnStatus: map['returnStatus'],
      driver: Mapper.child<Profile>(map['driver']),
      type: map['type'],
      productNotes: Mapper.children<Products>(map['productNotes']),
      totalWeight: map['totalWeight'],
      totalQuantity: map['totalQuantity'],
      totalPrice: map['totalPrice'],
      paymentMethod: map['paymentMethod'],
      paymentAmount:map['paymentAmount'],
      latitude:map['latitude'],
      longitude: map['longitude'],
      returnedProducts: Mapper.children<Products>(map['returnedProducts']),
      reason: map['reason'],
      returnReason: map['returnReason'],
      grStatus: map['grStatus']
    );
  }
}