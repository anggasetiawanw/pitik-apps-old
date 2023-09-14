import 'package:flutter/cupertino.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
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