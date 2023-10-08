// ignore_for_file: slash_for_doc_comments

import 'package:shorebird_code_push/shorebird_code_push.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class UpdaterCodeMagic {

    final _shorebirdCodePush = ShorebirdCodePush();
    Future<void> checkForUpdate({required Function(bool) isAvailable}) async {
        final isUpdateAvailable = await _shorebirdCodePush.isNewPatchAvailableForDownload();
        if (isUpdateAvailable) {
            isAvailable(true);
        } else {
            isAvailable(false);
        }
    }
}