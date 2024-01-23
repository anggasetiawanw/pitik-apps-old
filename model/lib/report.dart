import 'package:model/engine_library.dart';
import 'package:model/internal_app/media_upload_model.dart';
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

  @IsChildren()
  List<MediaUploadModel?>? images;

  @IsChildren()
  List<Product?>? feedConsumptions;

  @IsChildren()
  List<Product?>? ovkConsumptions;

  Report({
    this.taskTicketId,
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
    this.feedConsumptions,
    this.ovkConsumptions,
  });

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
      feedConsumptions: Mapper.children<Product>(map['feedConsumptions']),
      ovkConsumptions: Mapper.children<Product>(map['ovkConsumptions']),
    );
  }
}
