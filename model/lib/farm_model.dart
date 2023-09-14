import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class Farm{

    String? id;
    String? name;
    String? status;

    Farm({this.id, this.name, this.status});

    static Farm toResponseModel(Map<String, dynamic> map) {
        return Farm(
            id: map['id'],
            name: map['name'],
            status: map['status'],
        );
    }
}