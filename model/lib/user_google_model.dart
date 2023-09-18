import 'package:model/engine_library.dart';

@SetupEntity
@SetupModel
@Table("t_user")
class UserGoogle extends BaseEntity {
    @Attribute(name: "accessToken", type: "VARCHAR", length: 100, defaultValue: "", notNull: true, primaryKey: true)
    String? accessToken;

    @Attribute(name: "email", type: "VARCHAR", length: 255, defaultValue: "", notNull: true)
    String? email;

    UserGoogle({this.accessToken, this.email});

    UserGoogle toModelEntity(Map<String, dynamic> map) {
        return UserGoogle(email: map['email'], accessToken: map['accessToken']);
    }

    static UserGoogle toResponseModel(Map<String, dynamic> map) {
        return UserGoogle(email: map['email'], accessToken: map['accessToken']);
    }
}
