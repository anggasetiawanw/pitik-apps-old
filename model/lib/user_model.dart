// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class User{

    String? username;
    String? password;

    User({this.username, this.password});

    static User toResponseModel(Map<String, dynamic> map) {
        return User(
            username: map['username'],
            password: map['password'],
        );
    }
}