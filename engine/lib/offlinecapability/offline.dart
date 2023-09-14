
/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */


import '../dao/annotation/attribute.dart';
import '../dao/base_entity.dart';

@SetupEntity
class Offline extends BaseEntity {
    @Attribute(name: "idOffline", type: "INTEGER", length: 10, defaultValue: "", primaryKey: true, autoIncrements: true, notNull: true)
    int? idOffline;

    @Attribute(name: "expiredDate", type: "VARCHAR", length: 50, defaultValue: "", notNull: true)
    String? expiredDate;

    @Attribute(name: "flag", type: "INTEGER", length: 1, defaultValue: "0")
    int? flag;

    Offline({this.idOffline, this.expiredDate, this.flag});

    @override
    Offline toModelEntity(Map<String, dynamic> map) {
        return Offline(
            idOffline: map['idOffline'],
            expiredDate: map['expiredDate'],
            flag: map['flag']
        );
    }
}