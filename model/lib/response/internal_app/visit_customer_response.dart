import 'package:model/engine_library.dart';
import 'package:model/internal_app/visit_customer_model.dart';

@SetupModel
class VisitCustomerResponse {
    int? code;
    VisitCustomer? data;

    VisitCustomerResponse({this.code, this.data});

    static VisitCustomerResponse toResponseModel(Map<String, dynamic> map) => VisitCustomerResponse(
        code: map['code'],
        data: Mapper.child<VisitCustomer>(map['data']),
    );
}
