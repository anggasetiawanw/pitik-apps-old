import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';

@SetupModel
class StockModel {
  String? id;
  String? productCategoryId;
  String? productCategoryName;
  String? productItemId;
  String? name;
  int? totalQuantity;
  double? totalWeight;
  int? availableQuantity;
  double? availableWeight;
  int? reservedQuantity;
  double? reservedWeight;

  @IsChild()
  Products? category;

  @IsChildren()
  List<StockModel?>? productItems;

  StockModel(
      {this.id,
      this.category,
      this.availableQuantity,
      this.availableWeight,
      this.reservedQuantity,
      this.reservedWeight,
      this.totalQuantity,
      this.totalWeight,
      this.productCategoryId,
      this.name,
      this.productCategoryName,
      this.productItemId,
      this.productItems});

  static StockModel toResponseModel(Map<String, dynamic> map) {
    if (map['totalWeight'] is int) {
      map['totalWeight'] = map['totalWeight'].toDouble();
    }
    if (map['availableWeight'] is int) {
      map['availableWeight'] = map['availableWeight'].toDouble();
    }
    if (map['reservedWeight'] is int) {
      map['reservedWeight'] = map['reservedWeight'].toDouble();
    }
    return StockModel(
        id: map['id'],
        totalQuantity: map['totalQuantity'],
        totalWeight: map['totalWeight'],
        availableQuantity: map['availableQuantity'],
        availableWeight: map['availableWeight'],
        reservedQuantity: map['reservedQuantity'],
        reservedWeight: map['reservedWeight'],
        productCategoryId: map['productCategoryId'],
        category: Mapper.child<Products>(map['category']),
        productCategoryName: map['productCategoryName'],
        productItemId: map['productItemId'],
        productItems: Mapper.children<StockModel>(map['productItems']),
        name: map['name']);
  }
}
