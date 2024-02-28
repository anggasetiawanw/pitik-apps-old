import 'package:model/engine_library.dart';

/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-03-21 13:22:34
/// @modify date 2023-03-21 13:22:34
/// @desc [description]

@SetupModel
class OrderIssueCategories {
  String? id;
  String? title;

  OrderIssueCategories({this.id, this.title});
  static OrderIssueCategories toResponseModel(Map<String, dynamic> map) => OrderIssueCategories(
        id: map["id"],
        title: map["title"],
      );
}
