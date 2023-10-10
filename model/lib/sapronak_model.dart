
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Sapronak {

    String? date;
    String? productCode;
    String? productName;
    String? subcategoryName;
    int? quantity;

    Sapronak({this.date, this.productCode, this.productName, this.subcategoryName, this.quantity});

    static Sapronak toResponseModel(Map<String, dynamic> map) {
        return Sapronak(
            date: map['date'],
            productCode: map['productCode'],
            productName: map['productName'],
            subcategoryName: map['subcategoryName'],
            quantity: map['quantity']
        );
    }
}