// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupEntity
@SetupModel
@Table("t_xapp")
class XAppId extends BaseEntity {
    @Attribute(name: "appId", type: "VARCHAR", length: 100, defaultValue: "", notNull: true)
    String? appId;

    XAppId({this.appId});

    @override
    XAppId toModelEntity(Map<String, dynamic> map) {
        return XAppId(appId: map['appId']);
    }

    static XAppId toResponseModel(Map<String, dynamic> map) {
        return XAppId(appId: map['appId']);
    }
}