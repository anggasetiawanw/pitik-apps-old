import 'package:model/engine_library.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/mortality_reason_model.dart';
import 'package:model/product_model.dart';

@SetupModel
class Report {
  String? taskTicketId;
  String? title;
  String? deskripsi;
  String? status;
  String? date;
  double? averageWeight;
  int? mortality;
  int? culling;
  double? feedQuantity;
  String? feedTypeCode;
  String? feedAdditionalInfo;
  String? mortalityImage;
  String? recordingImage;
  String? summary;
  String? remarks;
  bool? isAbnormal;
  String? revisionStatus;
  double? eggDisposal;

  @IsChildren()
  List<MediaUploadModel?>? images;

  @IsChildren()
  List<Product?>? feedConsumptions;

  @IsChildren()
  List<Product?>? ovkConsumptions;

  @IsChildren()
  List<MortalityReason?> mortalityList;

  @IsChildren()
  List<Products?> harvestedEgg;

  Report(
      {this.taskTicketId,
      this.title,
      this.deskripsi,
      this.status,
      this.date,
      this.averageWeight,
      this.mortality,
      this.culling,
      this.feedQuantity,
      this.feedTypeCode,
      this.images,
      this.feedAdditionalInfo,
      this.mortalityImage,
      this.recordingImage,
      this.summary,
      this.remarks,
      this.isAbnormal,
      this.revisionStatus,
      this.eggDisposal,
      this.feedConsumptions,
      this.ovkConsumptions,
      this.mortalityList = const [],
      this.harvestedEgg = const []});

  static Report toResponseModel(Map<String, dynamic> map) {
    if (map["averageWeight"] is int) {
      map["averageWeight"] = map["averageWeight"].toDouble();
    }
    if (map["feedQuantity"] is int) {
      map["feedQuantity"] = map["feedQuantity"].toDouble();
    }

    return Report(
      taskTicketId: map['taskTicketId'],
      title: map['title'],
      deskripsi: map['deskripsi'],
      status: map['status'],
      date: map['date'],
      averageWeight: map['averageWeight'],
      mortality: map['mortality'],
      culling: map['culling'],
      feedQuantity: map['feedQuantity'],
      feedTypeCode: map['feedTypeCode'],
      images: Mapper.children<MediaUploadModel>(map['images']),
      feedAdditionalInfo: map['feedAdditionalInfo'],
      mortalityImage: map['mortalityImage'],
      recordingImage: map['recordingImage'],
      summary: map['summary'],
      remarks: map['remarks'],
      isAbnormal: map['isAbnormal'],
      revisionStatus: map['revisionStatus'],
      eggDisposal: map['eggDisposal'] != null ? map['eggDisposal'].toDouble() : map['eggDisposal'],
      feedConsumptions: Mapper.children<Product>(map['feedConsumptions']),
      ovkConsumptions: Mapper.children<Product>(map['ovkConsumptions']),
      mortalityList: Mapper.children<MortalityReason>(map['mortalityList']),
      harvestedEgg: Mapper.children<Products>(map['harvestedEgg']),
    );
  }
}
