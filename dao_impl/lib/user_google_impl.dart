/*
  @author DICKY <dicky.maulana@pitik.id>
 */


import 'package:dao_impl/library/engine_library.dart';
import 'package:model/user_google_model.dart';
@Dao("t_user")
class UserGoogleImpl extends DaoImpl<UserGoogle> {
    UserGoogleImpl() : super(UserGoogle());

    Future<UserGoogle?> get() async {
        return await queryForModel(UserGoogle(), "SELECT * FROM t_user", null);
    }

    @override
    List? select(persistance, String arguments, List<String> parameters) {
        throw UnimplementedError();
    }
}
