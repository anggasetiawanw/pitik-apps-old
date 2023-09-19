import 'package:model/engine_library.dart';
import 'package:model/internal_app/customer_model.dart';

@SetupModel
class CustomerResponse {
    int? code;
    Customer? data;

    CustomerResponse({this.code, this.data});

    static CustomerResponse toResponseModel(Map<String, dynamic> map) => CustomerResponse(
        code: map['code'],
        data: Mapper.child<Customer>(map['data']),
    );
}
