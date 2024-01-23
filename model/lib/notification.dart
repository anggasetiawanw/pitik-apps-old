import 'package:model/engine_library.dart';

@SetupModel
@SetupEntity
@Table("t_notification")
class Notifications extends BaseEntity {
    @Attribute(name: "phoneNumber", length: 20)
    String? phoneNumber;

    @Attribute(name: "id", length: 100, primaryKey: true, notNull: true)
    String? id;

    @Attribute(name: "userId", length: 100)
    String? userId;

    @Attribute(name: "subjectId")
    String? subjectId;

    @Attribute(name: "notificationType")
    String? notificationType;

    @Attribute(name: "headline")
    String? headline;

    @Attribute(name: "subHeadline")
    String? subHeadline;

    @Attribute(name: "icon")
    String? icon;

    @Attribute(name: "iconPath")
    String? iconPath;

    @Attribute(name: "isRead", type: "INTEGER", length: 1)
    bool? isRead;

    @Attribute(name: "createdDate", length: 25)
    String? createdDate;

    @Attribute(name: "modifiedDate", length: 25)
    String? modifiedDate;

    @Attribute(name: "target")
    String? target;

    @Attribute(name: "peripheralId")
    String? peripheralId;

    @Attribute(name: "additionalParameters")
    Map<String, dynamic>? additionalParameters;

    Notifications({this.id, this.userId, this.subjectId, this.notificationType, this.headline, this.subHeadline, this.icon, this.iconPath, this.isRead = false, this.createdDate, this.modifiedDate, this.target, this.peripheralId, this.additionalParameters});
    
    @override
    Notifications toModelEntity(Map<String, dynamic> map) {
        return Notifications(
        id: map['id'],
        userId: map['userId'],
        subjectId: map['subjectId'],
        notificationType: map['notificationType'],
        headline: map['headline'],
        subHeadline: map['subHeadline'],
        icon: map['icon'],
        iconPath: map['iconPath'],
        isRead: map['isRead'] == 1,
        createdDate: map['createdDate'],
        modifiedDate: map['modifiedDate'],
        target: map['target'],
        peripheralId: map['peripheralId'],
        additionalParameters: map['additionalParameters'],
        );
    }

    static Notifications toResponseModel(Map<String, dynamic> map) {
        return Notifications(
        id: map['id'],
        userId: map['userId'],
        subjectId: map['subjectId'],
        notificationType: map['notificationType'],
        headline: map['headline'],
        subHeadline: map['subHeadline'],
        icon: map['icon'],
        iconPath: map['iconPath'],
        isRead: map['isRead'],
        createdDate: map['createdDate'],
        modifiedDate: map['modifiedDate'],
        target: map['target'],
        peripheralId: map['peripheralId'],
        additionalParameters: map['additionalParameters'],
        );
    }
}
