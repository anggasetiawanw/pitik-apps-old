// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ScanBarcodeController extends GetxController {
    BuildContext context;
    ScanBarcodeController({required this.context});
    var result = Barcode("",BarcodeFormat.unknown,[]).obs;
    QRViewController? qrviewController;
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    @override
    void dispose() {
        qrviewController?.dispose();
        super.dispose();
    }

    void onQRViewCreated(QRViewController controller) {
        qrviewController = controller;
        controller.scannedDataStream.listen((scanData) {
          qrviewController!.pauseCamera();
          result.value = scanData;
          Get.back(result: [
              {"backValue": result.value.code}
          ]);
        });
    }

    void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
        log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
        if (!p) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('no Permission')),
            );
        }
    }
}

class ScanBarcodeBindings extends Bindings {
    BuildContext context;
    ScanBarcodeBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => ScanBarcodeController(context: context));
    }
}
