// ignore_for_file: slash_for_doc_comments

import 'package:flutter/cupertino.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class DaoInterface {
    Future<int?> save(dynamic object) async {
        debugPrint('save execute to table');
        return null;
    }

    List<dynamic>? select(dynamic persistance, String arguments, List<String> parameters) {
        debugPrint('select execute to table');
        return null;
    }

    Future<int?> delete(String? arguments, List<String> parameters) async{
        debugPrint('delete execute to table');
        return null;
     
    }
}