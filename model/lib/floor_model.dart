/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 13/07/23
 */

class Floor{

    String? id;
    String? buildingName;
    String? floorName;
    String? status;

    Floor({this.id, this.buildingName, this.floorName,this.status});

    static Floor toResponseModel(Map<String, dynamic> map) {
        return Floor(
            id: map['id'],
            buildingName: map['buildingName'],
            floorName: map['floorName'],
            status: map['status'],
        );
    }
}