import 'package:model/engine_library.dart';
import 'package:model/internal_app/transfer_model.dart';

@SetupModel
class TransferResponse {
    int? code;
    TransferModel? data;

    TransferResponse({this.code, required this.data});

    static TransferResponse toResponseModel(Map<String, dynamic> map) {
        return TransferResponse(
            code: map['code'],
            data: Mapper.child<TransferModel>(map['data'])
        );
    }
}