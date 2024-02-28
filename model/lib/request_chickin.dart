import 'package:model/chick_type_model.dart';
import 'package:model/engine_library.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/procurement_model.dart';
import 'package:model/product_model.dart';

@SetupModel
class RequestChickin {
  String? id;
  String? poCode;
  String? erpCode;
  String? startDate;
  String? chickInDate;
  int? initialPopulation;
  int? bw;
  int? uniformity;
  int? additionalPopulation;
  String? truckArrival;
  String? truckLeaving;
  String? finishChickIn;
  String? recordStart;
  String? remarks;
  String? coopId;
  bool? hasFinishedDOCin;
  int? pulletInWeeks;

  @IsChild()
  Product? doc;

  @IsChildren()
  List<Product?>? pakan;

  @IsChildren()
  List<Product?>? ovk;

  @IsChild()
  Procurement? internalOvkTransferRequest;

  @IsChild()
  ChickType? chickType;

  @IsChildren()
  List<MediaUploadModel?>? suratJalanPhotos;

  @IsChildren()
  List<MediaUploadModel?>? docInFormPhotos;

  @IsChildren()
  List<MediaUploadModel?>? pulletInFormPhotos;

  @IsChildren()
  List<MediaUploadModel?>? photos;

  String? notes;
  bool? mergedLogistic;
  String? mergedCoopId;
  String? mergedLogisticCoopName;
  int? mergedLogisticFarmingCycleDays;

  RequestChickin(
      {this.id,
      this.additionalPopulation,
      this.bw,
      this.chickInDate,
      this.coopId,
      this.doc,
      this.docInFormPhotos,
      this.erpCode,
      this.finishChickIn,
      this.hasFinishedDOCin,
      this.initialPopulation,
      this.internalOvkTransferRequest,
      this.mergedCoopId,
      this.mergedLogistic,
      this.mergedLogisticCoopName,
      this.mergedLogisticFarmingCycleDays,
      this.notes,
      this.ovk,
      this.pakan,
      this.photos,
      this.poCode,
      this.recordStart,
      this.remarks,
      this.startDate,
      this.pulletInWeeks,
      this.chickType,
      this.suratJalanPhotos,
      this.pulletInFormPhotos,
      this.truckArrival,
      this.truckLeaving,
      this.uniformity});

  static RequestChickin toResponseModel(Map<String, dynamic> map) {
    return RequestChickin(
        id: map['id'],
        poCode: map['poCode'],
        erpCode: map['erpCode'],
        startDate: map['startDate'],
        chickInDate: map['chickInDate'],
        initialPopulation: map['initialPopulation'],
        bw: map['bw'],
        uniformity: map['uniformity'],
        additionalPopulation: map['additionalPopulation'],
        truckArrival: map['truckArrival'],
        truckLeaving: map['truckLeaving'],
        finishChickIn: map['finishChickIn'],
        recordStart: map['recordStart'],
        remarks: map['remarks'],
        coopId: map['coopId'],
        hasFinishedDOCin: map['hasFinishedDOCin'],
        doc: Mapper.child<Product>(map['doc']),
        pakan: Mapper.children<Product>(map['pakan']),
        ovk: Mapper.children<Product>(map['ovk']),
        internalOvkTransferRequest: Mapper.child<Procurement>(map['internalOvkTransferRequest']),
        suratJalanPhotos: Mapper.children<MediaUploadModel>(map['suratJalanPhotos']),
        docInFormPhotos: Mapper.children<MediaUploadModel>(map['docInFormPhotos']),
        pulletInFormPhotos: Mapper.children<MediaUploadModel>(map['pulletInFormPhotos']),
        photos: Mapper.children<MediaUploadModel>(map['photos']),
        notes: map['notes'],
        pulletInWeeks: map['pulletInWeeks'],
        chickType: Mapper.child<ChickType>(map['chickType']),
        mergedLogistic: map['mergedLogistic'],
        mergedCoopId: map['mergedCoopId'],
        mergedLogisticCoopName: map['mergedLogisticCoopName'],
        mergedLogisticFarmingCycleDays: map['mergedLogisticFarmingCycleDays']);
  }
}
