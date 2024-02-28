// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupEntity
@SetupModel
@Table("t_auth")
class Auth extends BaseEntity {
  @Attribute(name: "id", type: "VARCHAR", length: 100, defaultValue: "", notNull: true, primaryKey: true)
  String? id;

  @Attribute(name: "token", type: "VARCHAR", length: 255, defaultValue: "", notNull: true)
  String? token;

  @Attribute(name: "refreshToken", type: "VARCHAR", length: 20)
  String? refreshToken;

  @Attribute(name: "acceptTnc", type: "INTEGER", length: 10)
  int? acceptTnc;

  @Attribute(name: "action")
  String? action;

  Auth({this.id, this.token, this.refreshToken, this.acceptTnc = 0, this.action});

  @override
  Auth toModelEntity(Map<String, dynamic> map) {
    return Auth(id: map['id'], token: map['token'], refreshToken: map['refreshToken'], acceptTnc: map['acceptTnc'], action: map['action']);
  }

  static Auth toResponseModel(Map<String, dynamic> map) {
    return Auth(id: map['id'], token: map['token'], refreshToken: map['refreshToken'], acceptTnc: map['acceptTnc'], action: map['action']);
  }
}
