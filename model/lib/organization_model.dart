// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class Organization {
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
