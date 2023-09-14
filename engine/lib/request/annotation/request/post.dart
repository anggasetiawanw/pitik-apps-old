import '../../../model/string_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.id>
 *@create date 31/07/23
 */

class POST {
    static const String PATH_PARAMETER = "*PATH_PARAMETER*";
    final String value;
    final dynamic as;
    final dynamic error;

    const POST({this.value = "", this.as = StringModel, this.error = String});
}