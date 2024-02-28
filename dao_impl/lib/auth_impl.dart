// ignore_for_file: slash_for_doc_comments

import 'library/engine_library.dart';
import 'library/model_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@Dao("t_auth")
class AuthImpl extends DaoImpl<Auth> {
  AuthImpl() : super(Auth());

  Future<Auth?> get() async {
    return await queryForModel(Auth(), "SELECT * FROM t_auth", null);
  }

  @override
  List? select(persistance, String arguments, List<String> parameters) {
    throw UnimplementedError();
  }
}
