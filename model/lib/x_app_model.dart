import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupEntity
@SetupModel
@Table("t_xapp")
class XAppId extends BaseEntity {
    @Attribute(name: "appId", type: "VARCHAR", length: 100, defaultValue: "", notNull: true,)
    String? appId;


    XAppId({this.appId});

    XAppId toModelEntity(Map<String, dynamic> map) {
        return XAppId(appId: map['appId']);
    }

    static XAppId toResponseModel(Map<String, dynamic> map) {
        return XAppId(appId: map['appId']);
    }
}