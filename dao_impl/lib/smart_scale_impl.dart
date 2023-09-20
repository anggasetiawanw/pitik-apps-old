// ignore_for_file: slash_for_doc_comments

import 'package:engine/dao/dao.dart';
import 'package:engine/dao/dao_impl.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@Dao("t_smart_scale")
class SmartScaleImpl extends DaoImpl<SmartScale> {
    SmartScaleImpl() : super(SmartScale());

    Future<SmartScale?> get() async {
        return await queryForModel(SmartScale(), "SELECT * FROM t_smart_scale", null);
    }

    Future<SmartScale?> getById(String id) async {
        return await queryForModel(SmartScale(), "SELECT * FROM t_smart_scale WHERE id = ?", [id]);
    }

    @override
    List? select(persistance, String arguments, List<String> parameters) {
        throw UnimplementedError();
    }
}