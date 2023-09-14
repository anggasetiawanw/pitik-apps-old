// ignore_for_file: slash_for_doc_comments

import 'library/engine_library.dart';
import 'library/model_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@Dao("m_profile")
class ProfileImpl extends DaoImpl<Profile> {

    ProfileImpl() : super(Profile());
    Future<Profile?> get() async {
        return await queryForModel(Profile(), "SELECT * FROM m_profile LIMIT 1", null);
    }

    @override
    List? select(persistance, String arguments, List<String> parameters) {
        throw UnimplementedError();
    }
}