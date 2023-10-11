
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Building {

    String? buildingId;
    String? buildingName;
    String? roomId;
    String? roomCode;
    String? roomTypeName;

    Building({this.buildingId, this.buildingName, this.roomId, this.roomCode, this.roomTypeName});

    static Building toResponseModel(Map<String, dynamic> map) {
        return Building(
            buildingId: map['buildingId'],
            buildingName: map['buildingName'],
            roomId: map['roomId'],
            roomCode: map['roomCode'],
            roomTypeName: map['roomTypeName']
        );
    }
}