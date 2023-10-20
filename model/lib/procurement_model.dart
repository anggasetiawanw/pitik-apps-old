
import 'engine_library.dart';
import 'good_receipt_model.dart';
import 'internal_app/media_upload_model.dart';
import 'product_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Procurement {

    String? id;
    String? poCode;
    String? purchaseRequestErpCode;
    String? type;
    String? deliveryDate;
    int? status;
    String? statusText;
    String? farmingCycleId;
    String? requestSchedule;
    String? erpCode;
    String? arrivalDate;
    String? description;
    bool? isFulfilled;
    String? notes;
    String? coopTargetName;
    String? coopSourceName;
    String? branchSourceName;
    String? branchTargetName;

    // For Order OVK/Feed
    String? coopId;
    String? coopSourceId;
    String? coopTargetId;
    String? branchSourceId;
    String? branchTargetId;
    String? subcategoryCode;
    String? subcategoryName;
    String? productName;
    double? quantity;
    String? datePlanned;
    String? internalOvkTransferRequestId;

    String? logisticOption;
    String? route;
    bool? mergedLogistic;
    String? mergedCoopId;
    String? mergedLogisticCoopName;
    int? mergedLogisticFarmingCycleDays;
    bool? isTransferRequest;

    @IsChildren()
    List<Product?> details;

    @IsChildren()
    List<GoodReceipt?> goodsReceipts;

    @IsChildren()
    List<MediaUploadModel?> photos;

    @IsChildren()
    List<Procurement?> internalOvkTransferRequest;

    Procurement({this.id, this.poCode, this.purchaseRequestErpCode, this.type, this.deliveryDate, this.status, this.statusText, this.farmingCycleId, this.requestSchedule, this.erpCode, this.arrivalDate,
                 this.description, this.isFulfilled, this.notes, this.coopTargetName, this.coopSourceName, this.branchSourceName, this.branchTargetName, this.coopId, this.coopSourceId, this.coopTargetId,
                 this.branchSourceId, this.branchTargetId, this.subcategoryCode, this.subcategoryName, this.productName, this.quantity, this.datePlanned, this.internalOvkTransferRequestId, this.logisticOption,
                 this.route, this.mergedLogistic, this.mergedCoopId, this.mergedLogisticCoopName, this.mergedLogisticFarmingCycleDays, this.isTransferRequest, this.details = const [],
                 this.goodsReceipts = const [], this.photos = const [], this.internalOvkTransferRequest = const []});

    static Procurement toResponseModel(Map<String, dynamic> map) {
        return Procurement(
            id: map['id'],
            poCode: map['poCode'],
            purchaseRequestErpCode: map['purchaseRequestErpCode'],
            type: map['type'],
            deliveryDate: map['deliveryDate'],
            status: map['status'],
            statusText: map['statusText'],
            farmingCycleId: map['farmingCycleId'],
            requestSchedule: map['requestSchedule'],
            erpCode: map['erpCode'],
            arrivalDate: map['arrivalDate'],
            description: map['description'],
            isFulfilled: map['isFulfilled'],
            notes: map['notes'],
            coopId: map['coopId'],
            coopTargetName: map['coopTargetName'],
            coopSourceName: map['coopSourceName'],
            branchSourceName: map['branchSourceName'],
            branchTargetName: map['branchTargetName'],
            coopSourceId: map['coopSourceId'],
            coopTargetId: map['coopTargetId'],
            branchSourceId: map['branchSourceId'],
            branchTargetId: map['branchTargetId'],
            subcategoryCode: map['subcategoryCode'],
            subcategoryName: map['subcategoryName'],
            productName: map['productName'],
            quantity: map['quantity'] != null ? map['quantity'].toDouble() : map['quantity'],
            datePlanned: map['datePlanned'],
            internalOvkTransferRequestId: map['internalOvkTransferRequestId'],
            logisticOption: map['logisticOption'],
            route: map['route'],
            mergedLogistic: map['mergedLogistic'],
            mergedCoopId: map['mergedCoopId'],
            mergedLogisticCoopName: map['mergedLogisticCoopName'],
            mergedLogisticFarmingCycleDays: map['mergedLogisticFarmingCycleDays'],
            isTransferRequest: map['isTransferRequest'],
            details: Mapper.children<Product>(map['details']),
            goodsReceipts: Mapper.children<GoodReceipt>(map['goodsReceipts']),
            photos: Mapper.children<MediaUploadModel>(map['photos']),
            internalOvkTransferRequest: Mapper.children<Procurement>(map['internalOvkTransferRequest'])
        );
    }
}