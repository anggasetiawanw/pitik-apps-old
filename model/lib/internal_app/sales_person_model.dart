/**
 * @author [Angga Setiawan Wahyudin]
 * @email [angga.setiawan@pitik.id]
 * @create date 2023-02-20 09:17:53
 * @modify date 2023-02-20 09:17:53
 * @desc [description]
 */

import 'dart:core';

import 'package:model/engine_library.dart';

@SetupModel
class SalesPerson {
    String? id;
    String? email;
    String? fullName;

    SalesPerson({this.id, this.email, this.fullName});

    static SalesPerson toResponseModel(Map<String, dynamic> map) {
        return SalesPerson(
            id: map['id'],
            email: map['email'],
            fullName: map['fullName'],
        );
    }
}
