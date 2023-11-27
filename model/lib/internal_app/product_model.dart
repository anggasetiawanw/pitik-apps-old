import 'package:model/engine_library.dart';

import 'category_model.dart';

/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-20 09:20:09
/// @modify date 2023-02-20 09:20:09
/// @desc [AKA SKU]

@SetupModel
class Products {
  String? id;
  String? name;
  int? dailyQuantity;
  double? price;
  String? uom;
  double? value;
  String? categoryId;
  int? quantity;
  double? weight;
  String? productItemId;
  String? productCategoryId;
  String? quantityUOM;
  String? weightUOM;
  int? numberOfCuts;
  int? returnQuantity;
  double? returnWeight;
  double? minValue;
  double? maxValue;
  double? totalWeight;
  int? totalQuantity;
  String? cutType;
  int? previousQuantity;
  double? previousWeight;

  int? lossPrecentage;
  @IsChild()
  CategoryModel? category;

  @IsChild()
  CategoryModel? productCategory;

  @IsChild()
  Products? productItem;

  @IsChildren()
  List<Products?>? productItems;

  Products({
    this.id,
    this.name,
    this.dailyQuantity,
    this.price,
    this.category,
    this.categoryId,
    this.uom,
    this.value,
    this.quantity,
    this.weight,
    this.productItemId,
    this.productCategoryId,
    this.lossPrecentage,
    this.numberOfCuts,
    this.productItem,
    this.returnQuantity,
    this.returnWeight,
    this.maxValue,
    this.minValue,
    this.productCategory,
    this.productItems,
    this.quantityUOM,
    this.weightUOM,
    this.totalQuantity,
    this.totalWeight,
    this.cutType,
    this.previousQuantity,
    this.previousWeight
  });

  static Products toResponseModel(Map<String, dynamic> map) {
    if (map['value'] is int) {
      map['value'] = map['value'].toDouble();
    }

    if (map['totalWeight'] is int) {
      map['totalWeight'] = map['totalWeight'].toDouble();
    }
    if (map['weight'] is int) {
      map['weight'] = map['weight'].toDouble();
    }
    if (map['returnWeight'] is int) {
      map['returnWeight'] = map['returnWeight'].toDouble();
    }
    if (map['price'] is int) {
      map['price'] = map['price'].toDouble();
    }
    if (map['maxValue'] is int) {
      map['maxValue'] = map['maxValue'].toDouble();
    }
    if (map['minValue'] is int) {
      map['minValue'] = map['minValue'].toDouble();
    }
    if (map['totalQuantity'] is double){
        map['totalQuantity'] = map['totalQuantity'].toInt();
    }
    if (map['previousWeight'] is int){
        map['previousWeight'] = map['previousWeight'].toDouble();
    }
    return Products(
      id: map['id'],
      name: map['name'],
      dailyQuantity: map['dailyQuantity'],
      price: map['price'],
      category: Mapper.child<CategoryModel>(map['category']),
      productCategory: Mapper.child<CategoryModel>(map['productCategory']),
      productItem: Mapper.child<Products>(map['productItem']),
      uom: map['uom'],
      value: map['value'],
      categoryId: map['categoryId'],
      quantity: map['quantity'],
      weight: map['weight'],
      productItemId: map['productItemId'],
      productCategoryId: map['productCategoryId'],
      numberOfCuts: map['numberOfCuts'],
      lossPrecentage: map['lossPrecentage'],
      returnQuantity: map['returnQuantity'],
      returnWeight: map['returnWeight'],
      minValue: map['minValue'],
      maxValue: map['maxValue'],
      productItems: Mapper.children<Products>(map['productItems']),
      weightUOM: map['weightUOM'],
      quantityUOM: map['quantityUOM'],
      totalQuantity: map['totalQuantity'],
      totalWeight: map['totalWeight'],
      cutType: map['cutType'],
        previousQuantity: map['previousQuantity'],
    );
  }
}
