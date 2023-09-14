import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
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