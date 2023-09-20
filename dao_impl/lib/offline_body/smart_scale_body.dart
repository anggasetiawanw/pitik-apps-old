// ignore_for_file: slash_for_doc_comments

import 'package:engine/request/transport/interface/service_body.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/auth_model.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

import '../auth_impl.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class SmartScaleBody implements ServiceBody<SmartScale> {

    @override
    Future<List> body(SmartScale object, List<dynamic> extras) async {
        Auth? auth = await AuthImpl().get();
        if (auth != null) {
            return [auth.token, auth.id, Mapper.asJsonString(object), object.id != null ? ListApi.pathSmartScaleForDetailAndUpdate(object.id!) : null];
        } else {
            return [];
        }
    }

    @override
    String getServiceName(SmartScale object) {
        return object.id != null && object.id != '' ? ListApi.updateSmartScale : ListApi.saveSmartScale;
    }
}