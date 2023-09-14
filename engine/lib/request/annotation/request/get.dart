// ignore_for_file: slash_for_doc_comments, constant_identifier_names

import 'package:engine/model/string_model.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class GET {
    static const String PATH_PARAMETER = "*PATH_PARAMETER*";
    final String value;
    final dynamic as;
    final dynamic error;

    const GET({this.value = "", this.as = StringModel, this.error = String});
}