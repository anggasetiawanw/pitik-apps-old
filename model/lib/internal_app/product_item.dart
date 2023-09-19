import 'package:model/engine_library.dart';

@SetupModel
class ProductItem {
    String? id;
    String? name;

    ProductItem({this.id, this.name});

    static ProductItem toResponseModel(Map<String, dynamic> map) {
        return ProductItem(
            id: map['id'],
        name: map['name'],
        );
    }
}