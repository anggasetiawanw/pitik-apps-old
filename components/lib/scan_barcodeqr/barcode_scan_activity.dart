
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'barcode_scan_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class ScanBarcodeActivity extends GetView<ScanBarcodeController> {
    // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
    Widget build(BuildContext context) {
        ScanBarcodeController controller = Get.put(ScanBarcodeController(context: context));
        Widget buildQrView(BuildContext context) {
            // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
            var scanArea = (MediaQuery.of(context).size.width < 200 ||
                MediaQuery.of(context).size.height < 200)
                ? 150.0
                : 300.0;
            // To ensure the Scanner view is properly sizes after rotation
            // we need to listen for Flutter SizeChanged notification and update controller
            return QRView(
                key: controller.qrKey,
                onQRViewCreated: controller.onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea),
                onPermissionSet: (ctrl, p) => controller.onPermissionSet(context, ctrl, p),
            );
        }


        return Scaffold(
            body: Column(
                children: <Widget>[
                    // appBar(),
                    Expanded(flex: 4, child: buildQrView(context)),
                    Expanded(
                        flex: 1,
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child:
                                Obx(() =>
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                            if (controller.result.value.code != "")
                                                Text(
                                                    ' ${describeEnum(controller.result.value.format)}   Data: ${controller.result.value.code}')
                                            else
                                                const Text(''),
                                            // SizedBox(height: 20,),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                    Container(
                                                        margin: const EdgeInsets.all(8),
                                                        child: ElevatedButton(
                                                            onPressed: () async {
                                                                await controller.qrviewController?.toggleFlash();
                                                                // setState(() {}
                                                                // );
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                                padding: EdgeInsets.all(0),
                                                                elevation: 0,
                                                                backgroundColor: Colors.transparent,
                                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                minimumSize: Size(0, 0)
                                                            ),
                                                            child: Container(
                                                                width: 36,
                                                                height: 36,
                                                                padding: EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    color: Color(0xFFFFF6ED),
                                                                    borderRadius: BorderRadius.circular(10)
                                                                ),
                                                              child: FutureBuilder(
                                                                  future: controller.qrviewController?.getFlashStatus(),
                                                                  builder: (context, snapshot) {
                                                                      print("FLASH STATUS ${controller.qrviewController?.getFlashStatus()}");
                                                                      if (snapshot.data != null) {
                                                                          return SvgPicture
                                                                              .asset(
                                                                              "images/flash_light_icon.svg");
                                                                      }else{
                                                                          return SvgPicture
                                                                              .asset(
                                                                              "images/flash_light_icon.svg");
                                                                      }

                                                                  },
                                                              ),
                                                            )),
                                                    ),
                                                    SizedBox(width: 18,),
                                                    Container(
                                                        margin: const EdgeInsets.all(8),
                                                        child: ElevatedButton(
                                                            onPressed: () async {
                                                                await controller.qrviewController?.flipCamera();
                                                                // setState(() {});
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                            padding: EdgeInsets.all(0),
                                                            elevation: 0,
                                                            backgroundColor: Colors.transparent,
                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            minimumSize: Size(0, 0)
                                                            ),
                                                            child: GestureDetector(
                                                                onTap:(){
                                                                    Navigator.pop(context);
                                                                },
                                                              child: Container(
                                                                  width: 36,
                                                                  height: 36,
                                                                  padding: EdgeInsets.all(10),
                                                                  decoration: BoxDecoration(
                                                                      color: Color(0xFFFFF6ED),
                                                                      borderRadius: BorderRadius.circular(10)
                                                                  ),
                                                                  child: SvgPicture.asset("images/close_icon.svg")
                                                                  // FutureBuilder(
                                                                  //     future: controller.qrviewController?.getCameraInfo(),
                                                                  //     builder: (context, snapshot) {
                                                                  //         if (snapshot.data != null) {
                                                                  //             return SvgPicture.asset("images/close_icon.svg");
                                                                  //         } else {
                                                                  //             return SvgPicture.asset("images/close_icon.svg");
                                                                  //         }
                                                                  //     },
                                                                  // ) ,
                                                              ),
                                                            ),



                                                        ),
                                                    )
                                                ],
                                            ),
                                            SizedBox(height: 20,),
                                            // Row(
                                            //     mainAxisAlignment: MainAxisAlignment.center,
                                            //     crossAxisAlignment: CrossAxisAlignment.center,
                                            //     children: <Widget>[
                                            //         Container(
                                            //             margin: const EdgeInsets.all(8),
                                            //             child: ElevatedButton(
                                            //                 onPressed: () async {
                                            //                     await controller.qrviewController?.pauseCamera();
                                            //                 },
                                            //                 child: const Text('pause',
                                            //                     style: TextStyle(fontSize: 20)),
                                            //             ),
                                            //         ),
                                            //         Container(
                                            //             margin: const EdgeInsets.all(8),
                                            //             child: ElevatedButton(
                                            //                 onPressed: () async {
                                            //                     await controller.qrviewController?.resumeCamera();
                                            //                 },
                                            //                 child: const Text('resume',
                                            //                     style: TextStyle(fontSize: 20)),
                                            //             ),
                                            //         )
                                            //     ],
                                            // ),
                                        ],
                                    ),)
                        ),
                    )
                ],
            ),
        );
    }

    // void _onQRViewCreated(QRViewController controller) {
    //     setState(() {
    //         this.controller = controller;
    //     });
    //     controller.scannedDataStream.listen((scanData) {
    //         setState(() {
    //             result = scanData;
    //         });
    //     });
    // }
    //
    // void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    //     if (!p) {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(content: Text('no Permission')),
    //         );
    //     }
    // }

}
