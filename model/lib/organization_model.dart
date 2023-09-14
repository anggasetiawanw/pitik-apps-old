import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class Organization{

    String? id;
    String? name;
    String? image;

    Organization({this.id, this.name, this.image});

    static Organization toResponseModel(Map<String, dynamic> map) {
        return Organization(
            id: map['id'],
            name: map['name'],
            image: map['image'],
        );
    }
}