
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Branch {

    String? id;
    String? name;

    Branch({this.id, this.name});

    static Branch toResponseModel(Map<String, dynamic> map) {
        return Branch(
            id: map['id'],
            name: map['name']
        );
    }
}