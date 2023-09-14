import 'library/engine_library.dart';
import 'library/model_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@Dao("t_xapp")
class XAppIdImpl extends DaoImpl<XAppId> {
    XAppIdImpl() : super(XAppId());

    Future<XAppId?> get() async {
        return await queryForModel(XAppId(), "SELECT * FROM t_xapp", null);
    }

    Future<XAppId?> getById(String xId) async {
        return await queryForModel(XAppId(), "SELECT * FROM t_xapp WHERE appId = ?", [xId]);
    }

    @override
    List? select(persistance, String arguments, List<String> parameters) {
        throw UnimplementedError();
    }
}
