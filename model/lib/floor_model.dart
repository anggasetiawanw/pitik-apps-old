// ignore_for_file: slash_for_doc_comments

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class Floor{

    String? id;
    String? buildingName;
    String? floorName;
    String? status;

    Floor({this.id, this.buildingName, this.floorName, this.status});

    static Floor toResponseModel(Map<String, dynamic> map) {
        return Floor(
            id: map['id'],
            buildingName: map['buildingName'],
            floorName: map['floorName'],
            status: map['status'],
        );
    }
}