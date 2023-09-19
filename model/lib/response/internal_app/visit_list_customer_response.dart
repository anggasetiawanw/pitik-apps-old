import 'package:model/engine_library.dart';
import 'package:model/internal_app/visit_customer_model.dart';

@SetupModel
class ListVisitCustomerResponse {
    int? code;
    List<VisitCustomer?> data;

    ListVisitCustomerResponse({this.code, required this.data});

    static ListVisitCustomerResponse toResponseModel(Map<String, dynamic> map) => ListVisitCustomerResponse(
        code: map['code'],
        data: Mapper.children<VisitCustomer>(map['data']),
    );
}
