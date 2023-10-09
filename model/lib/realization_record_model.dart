
import 'package:model/scale_value_model.dart';
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class RealizationRecord {

    String? weighingNumber;
    double? tonnage;
    int? quantity;
    int? page;
    double? averageWeight;
    String? image;

    @IsChildren()
    List<ScaleValue?> details;

    RealizationRecord({this.weighingNumber, this.tonnage, this.quantity, this.page, this.averageWeight, this.image, this.details = const []});

    static RealizationRecord toResponseModel(Map<String, dynamic> map) {
        return RealizationRecord(
            weighingNumber: map['weighingNumber'],
            tonnage: map['tonnage'] != null ? map['tonnage'].toDouble() : map['tonnage'],
            quantity: map['quantity'],
            page: map['page'],
            averageWeight: map['averageWeight'] != null ? map['averageWeight'].toDouble() : map['averageWeight'],
            image: map['image'],
            details: Mapper.children<ScaleValue>(map['details'])
        );
    }
}