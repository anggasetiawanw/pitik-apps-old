// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class Farm {
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
