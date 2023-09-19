import 'package:model/engine_library.dart';
import 'package:model/internal_app/transfer_model.dart';

@SetupModel
class ListTransferResponse {
    int? code;
    List<TransferModel?> data;

    ListTransferResponse({this.code, required this.data});

    static ListTransferResponse toResponseModel(Map<String, dynamic> map) {
        return ListTransferResponse(
            code: map['code'],
            data: Mapper.children<TransferModel>(map['data'])
        );
    }
}