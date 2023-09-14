import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class ScanBarcodeController extends GetxController {
    BuildContext context;
    ScanBarcodeController({required this.context});
    var result = Barcode("",BarcodeFormat.unknown,[]).obs;
    QRViewController? qrviewController;
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    // In order to get hot reload to work we need to pause the camera if the platform
    // is android, or resume the camera if the platform is iOS.
    // @override
    // void reassemble() {
    //     super.reassemble();
    //     if (Platform.isAndroid) {
    //         controller!.pauseCamera();
    //     }
    //     controller!.resumeCamera();
    // }


    @override
    void dispose() {
        qrviewController?.dispose();
        super.dispose();
    }

    void onQRViewCreated(QRViewController controller) {
        this.qrviewController = controller;
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
