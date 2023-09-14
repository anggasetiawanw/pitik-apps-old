// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class Password{

    String? oldPassword;
    String? newPassword;
    String? confirmationPassword;

    Password({this.oldPassword, this.newPassword, this.confirmationPassword});

    static Password toResponseModel(Map<String, dynamic> map) {
        return Password(
            oldPassword: map['oldPassword'],
            newPassword: map['newPassword'],
            confirmationPassword: map['confirmationPassword'],
        );
    }
}