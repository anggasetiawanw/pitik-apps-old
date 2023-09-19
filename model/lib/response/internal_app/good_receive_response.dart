import 'package:model/engine_library.dart';
import 'package:model/internal_app/goods_received_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 07/06/23

@SetupModel
class GoodReceiveReponse{

  int code;
  GoodsReceived? data;

  GoodReceiveReponse({required this.code, required this.data});

  static GoodReceiveReponse toResponseModel(Map<String, dynamic> map) {
    return GoodReceiveReponse(
        code: map['code'],
        data: Mapper.child<GoodsReceived>(map['data'])
    );
  }
}