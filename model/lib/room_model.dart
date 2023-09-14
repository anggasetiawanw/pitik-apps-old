import '../engine_library.dart';
import 'coop_model.dart';
import 'device_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class Room{

    String? id;
    String? name;
    String? status;
    int? level;
    String? roomCode;

    @IsChildren()
    List<Device?> devices;

    @IsChild()
    Coop? roomType;

    @IsChild()
    Coop? building;

    Room({this.id, this.name, this.status, this.level, this.devices= const[], this.roomCode,
    this.roomType, this.building});

    static Room toResponseModel(Map<String, dynamic> map) {
        return Room(
            id: map['id'],
            name: map['name'],
            status: map['status'],
            level: map['level'],
            roomCode: map['roomCode'],
            devices: Mapper.children<Device>(map['devices']),
            roomType: Mapper.child<Coop>(map['roomType']),
            building: Mapper.child<Coop>(map['building']),
        );
    }
}