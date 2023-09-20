/*
  @author DICKY <dicky.maulana@pitik.id>
 */

import 'package:flutter/material.dart';

class CustomDialogListener {

    Function(BuildContext context, int id, List<dynamic> packet) onDialogOk;
    Function(BuildContext context, int id, List<dynamic> packet) onDialogCancel;

    CustomDialogListener({required this.onDialogOk, required this.onDialogCancel});
}