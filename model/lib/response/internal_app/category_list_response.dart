import 'package:model/engine_library.dart';
import 'package:model/internal_app/category_model.dart';

@SetupModel
class CategoryListResponse {
    int? code;
    List<CategoryModel?> data;

    CategoryListResponse({this.code, required this.data});

    static CategoryListResponse toResponseModel(Map<String, dynamic> map) => CategoryListResponse(
        code: map['code'],
        data: Mapper.children<CategoryModel>(map['data']),
    );
}
