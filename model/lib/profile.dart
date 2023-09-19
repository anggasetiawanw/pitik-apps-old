import 'package:model/engine_library.dart';
import 'package:model/internal_app/module_model.dart';
import 'package:model/internal_app/role_model.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

@SetupEntity
@SetupModel
@Table("m_profile")
class Profile extends BaseEntity {
    @Attribute(name: "id", primaryKey: true, notNull: true)
    String? id;

    String? cmsId;
    @Attribute(name: "name", length: 100)
    String? name;

    @Attribute(name: "email", length: 100)
    String? email;

    @Attribute(name: "phoneNumber", length: 16)
    String? phoneNumber;

    @Attribute(name: "waNumber", length: 16)
    String? waNumber;

    @Attribute(name: "role", length: 50)
    String? role;

    @Attribute(name: "organizationId", length: 50)
    String? organizationId;

    @Attribute(name: "organizationName", length: 100)
    String? organizationName;

    @Attribute(name: "createdDate", length: 100)
    String? createdDate;
    @Attribute(name: "userCode", length: 50)
    String? userCode;

    @Attribute(name: "userName", length: 50)
    String? userName;

    @Attribute(name: "fullName", length: 100)
    String? fullName;

    @Attribute(name: "userType", length: 20)
    String? userType;

    @Attribute(name: "status", type: "INTEGER", length: 2, defaultValue: "0")
    int? status;

    @Attribute(name: "refOwnerId", length: 100)
    String? refOwnerId;
    
    @IsChildren()
    List<RoleModel?>? roles;

    @IsChild()
    ModuleModel? modules;

    Profile({this.id, this.userCode, this.userName, this.fullName, this.email, this.phoneNumber, this.userType, this.status = 1, this.refOwnerId, this.createdDate, this.cmsId, this.roles, this.modules, this.name, this.waNumber, this.role, this.organizationId, this.organizationName});

    @override
    Profile toModelEntity(Map<String, dynamic> map) {
        return Profile(
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
            name: map['name'],
            waNumber: map['waNumber'],
            role: map['role'],
            organizationId: map['organizationId'],
            organizationName: map['organizationName'],
        );
    }

    static Profile toResponseModel(Map<String, dynamic> map) {
        return Profile(
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
        );
    }
}