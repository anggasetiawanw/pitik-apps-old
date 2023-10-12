
import 'engine_library.dart';
import 'internal_app/media_upload_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Product {

    String? id;
    String? feedStockSummaryId;
    String? ovkStockSummaryId;
    String? categoryCode;
    String? categoryName;
    String? subcategoryCode;
    String? subcategoryName;
    String? productCode;
    String? productName;
    double? quantity;
    String? purchaseUom;
    String? uom;
    String? statusText;
    String? coopSourceName;
    int? status;
    int? remaining;
    String? deliveryDate;
    String? coopTargetName;
    String? poProductId;
    String? notes;
    String? logisticOption;
    String? farmingCycleId;
    double? remainingQuantity;
    bool? isReturned;

    @IsChildren()
    List<MediaUploadModel?> photos;

    Product({this.id, this.feedStockSummaryId, this.ovkStockSummaryId, this.categoryCode, this.categoryName, this.subcategoryName, this.subcategoryCode, this.productName, this.productCode, this.quantity,
             this.purchaseUom, this.uom, this.statusText, this.coopSourceName, this.status, this.remaining, this.deliveryDate, this.coopTargetName, this.poProductId, this.notes, this.logisticOption,
             this.farmingCycleId, this.remainingQuantity, this.isReturned, this.photos = const []});

    static Product toResponseModel(Map<String, dynamic> map) {
        return Product(
            id: map['id'],
            feedStockSummaryId: map['feedStockSummaryId'],
            ovkStockSummaryId: map['ovkStockSummaryId'],
            categoryCode: map['categoryCode'],
            categoryName: map['categoryName'],
            subcategoryName: map['subcategoryName'],
            subcategoryCode: map['subcategoryCode'],
            productName: map['productName'],
            productCode: map['productCode'],
            quantity: map['quantity'] is int ? map['quantity'].toDouble() : map['quantity'],
            purchaseUom: map['purchaseUom'],
            uom: map['uom'],
            statusText: map['statusText'],
            coopSourceName: map['coopSourceName'],
            status: map['status'],
            remaining: map['remaining'],
            deliveryDate: map['deliveryDate'],
            coopTargetName: map['coopTargetName'],
            poProductId: map['poProductId'],
            notes: map['notes'],
            logisticOption: map['logisticOption'],
            farmingCycleId: map['farmingCycleId'],
            remainingQuantity: map['remainingQuantity'] is int ? map['remainingQuantity'].toDouble() : map['remainingQuantity'],
            isReturned: map['isReturned'],
            photos: Mapper.children<MediaUploadModel>(map['photos'])
        );
    }
}