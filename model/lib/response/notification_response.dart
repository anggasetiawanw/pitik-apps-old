import 'package:model/engine_library.dart';
import 'package:model/notification.dart';

@SetupModel
class NotificationResponse {
    int? code;
    List<Notifications?> data;

    NotificationResponse({this.code, required this.data});

    static toResponseModel(Map<String, dynamic> map) {
        return (
            code: map['code'],
            data: Mapper.children<Notifications>(map['data'])
        );
    }
}