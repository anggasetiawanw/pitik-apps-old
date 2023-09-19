import 'package:model/engine_library.dart';
import 'package:model/internal_app/customer_model.dart';

@SetupModel
class ListCustomerResponse {
    int? code;
    List<Customer?> data;

    ListCustomerResponse({this.code, required this.data});

    static ListCustomerResponse toResponseModel(Map<String, dynamic> map) => ListCustomerResponse(
        code: map['code'],
        data: Mapper.children<Customer>(map['data']),
    );
}
