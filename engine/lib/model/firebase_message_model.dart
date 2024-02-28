// ignore_for_file: slash_for_doc_comments

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class FirebaseMessageModel {
  late final String target;
  late final String route;

  FirebaseMessageModel({required this.target, required this.route});

  FirebaseMessageModel.fromJson(Map<String, dynamic> json) {
    target = json['target'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['target'] = target;
    data['route'] = route;
    return data;
  }
}
