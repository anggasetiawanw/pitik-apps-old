import 'package:flutter/material.dart';
import 'package:global_variable/global_variable.dart';

import 'listener/custom_dialog_listener.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

String _title = 'Pesan';
String _message = 'Pesan';
String _titleButtonOk = 'Ok';
String _titleButtonNo = 'Batal';
bool _barrierDismissible = false;

// ignore: constant_identifier_names
enum Dialogs { YES_OPTION, YES_NO_OPTION, ONLY_ALERT }
Dialogs _dialogType = Dialogs.YES_OPTION;
bool _isShowing = false;
CustomDialogListener? _listener;

class CustomDialog {
    _MyDialog? _dialog;
    BuildContext? _buildContext, _context;
    int? _id = -111111;
    List<dynamic> packetList = [];

    CustomDialog(BuildContext context, Dialogs type) {
        _buildContext = context;
        _dialogType = type;
    }

    CustomDialog packet(List<dynamic> packetList) {
        this.packetList = packetList;
        return this;
    }

    CustomDialog id(int id) {
        _id = id;
        return this;
    }

    CustomDialog listener(CustomDialogListener listener) {
        _listener = listener;
        return this;
    }

    CustomDialog title(String title) {
        _title = title;
        return this;
    }

    CustomDialog message(String message) {
        _message = message;
        return this;
    }

    CustomDialog titleButtonOk(String text) {
        _titleButtonOk = text;
        return this;
    }

    CustomDialog titleButtonNo(String text) {
        _titleButtonNo = text;
        return this;
    }

    CustomDialog barrierDismiss(bool barrierDismissible) {
        _barrierDismissible = barrierDismissible;
        return this;
    }

    bool isShowing() {
      return _isShowing;
    }

    void hide() {
        _isShowing = false;
        Navigator.of(_context!).pop();
        debugPrint('CustomDialog dismissed');
    }

    void show() {
        _dialog = _MyDialog(
            id: _id!,
            dialog: this,
            packetList: packetList,
        );

        _isShowing = true;
        debugPrint('CustomDialog shown');

        showDialog<dynamic>(
            barrierDismissible: _barrierDismissible,
            context: _buildContext!,
            builder: (BuildContext context) {
                _context = context;
                return _dialog!;
            },
        );
    }
}

// ignore: must_be_immutable
class _MyDialog extends StatefulWidget {
    int id;
    CustomDialog dialog;
    List<dynamic> packetList;

    _MyDialog({Key? key, required this.id, required this.dialog, required this.packetList}) : super(key: key);

    // ignore: prefer_typing_uninitialized_variables
    var _dialog;
    update() {
        _dialog.changeState();
    }

    @override
    // ignore: must_be_immutable, no_logic_in_create_state
    State<StatefulWidget> createState() {
      _dialog = _MyDialogState(
          id: id,
          dialog: dialog,
          packetList: packetList
      );

      return _dialog;
    }
}

class _MyDialogState extends State<_MyDialog> {
    int id;
    CustomDialog dialog;
    List<dynamic> packetList;

    _MyDialogState({required this.id, required this.dialog, required this.packetList});

    changeState() {
        setState(() {});
    }

    @override
    void dispose() {
        super.dispose();
        _isShowing = false;
        debugPrint('CustomDialog dismissed by back button');
    }

    @override
    Widget build(BuildContext context) {
        if (_dialogType == Dialogs.YES_OPTION) {
            return AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                title: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue,),
                    const SizedBox(width: 16,),
                    Text(_title),
                  ],
                ),
                content: Text(_message),
                actions: <Widget>[
                    ElevatedButton (
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                        ),
                        child: const Text("Ok"),
                        onPressed: () {
                            dialog.hide();
                            _listener!.onDialogOk(context, id, packetList);
                      },
                    )
                ],
            );
        } else if (_dialogType == Dialogs.YES_NO_OPTION) {
            return AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                title:  Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue,),
                    const SizedBox(width: 16,),
                    Text(_title),
                  ],
                ),
                content: Text(_message),
                actions: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange 
                        ),
                        onPressed: () {
                            dialog.hide();
                            _listener!.onDialogOk(context, id, packetList);
                        },
                        child: Text(_titleButtonOk),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: AppColors.primaryOrange, width: 1)
                        ),
                        onPressed: () {
                            dialog.hide();
                            _listener!.onDialogCancel(context, id, packetList);
                        },
                        child: Text(_titleButtonNo, style:TextStyle(color: Color(0xFFF47B20))),
                    )
                ],
            );
        } else {
            return AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                title: Text(_title),
                content: Text(_message)
            );
        }
    }
}