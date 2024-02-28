/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-20 09:17:53
/// @modify date 2023-02-20 09:17:53
/// @desc [description]

import 'dart:core';

import 'package:model/branch.dart';
import 'package:model/engine_library.dart';
import 'package:model/internal_app/module_model.dart';
import 'package:model/internal_app/role_model.dart';

@SetupModel
class SalesPerson {
  String? id;
  String? cmsId;
  String? name;
  String? email;
  String? phoneNumber;
  String? role;
  String? organizationId;
  String? organizationName;
  String? createdDate;
  String? userCode;
  String? userName;
  String? fullName;
  String? userType;
  String? waNumber;
  int? status;
  String? refOwnerId;

  @IsChildren()
  List<RoleModel?>? roles;

  @IsChild()
  ModuleModel? modules;

  @IsChild()
  Branch? branch;

  String? farmingCycleId;
  String? ownerId;
  String? password;

  SalesPerson(
      {this.id,
      this.userCode,
      this.userName,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.userType,
      this.status = 1,
      this.refOwnerId,
      this.createdDate,
      this.cmsId,
      this.roles,
      this.modules,
      this.name,
      this.waNumber,
      this.role,
      this.organizationId,
      this.organizationName,
      this.branch,
      this.farmingCycleId,
      this.ownerId,
      this.password});

  static SalesPerson toResponseModel(Map<String, dynamic> map) {
    return SalesPerson(
      id: map['id'],
      userCode: map['userCode'],
      userName: map['userName'],
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      userType: map['userType'],
      // status: map['status'],
      refOwnerId: map['refOwnerId'],
      createdDate: map['createdDate'],
      cmsId: map['cmsId'],
      roles: Mapper.children<RoleModel>(map['roles']),
      modules: Mapper.child<ModuleModel>(map['modules']),
      name: map['name'],
      waNumber: map['waNumber'],
      role: map['role'],
      organizationId: map['organizationId'],
      organizationName: map['organizationName'],
      branch: Mapper.child<Branch>(map['branch']),
      farmingCycleId: map['farmingCycleId'],
      ownerId: map['ownerId'],
      password: map['password'],
    );
  }
}
