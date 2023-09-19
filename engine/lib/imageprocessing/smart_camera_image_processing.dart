
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ui;
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'package:permission_handler/permission_handler.dart';

/**
 * @author DICKY <dicky.maulana@pitik.id>
 * @edited Robertus Mahardhi Kuncoro <robert.kuncoro@pitik.id> on 25 Sept 2023
 */

class SmartCameraImageProcessing {
    late String pathImage ;

    shareImage({required String url, String? cameraName, double? temperature, double? humidity, String? coop, String? floor, String? cameraPosition, String? timeTake, isDownload = false}) async {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
            await Permission.storage.request();
        }

        File fileImage = await _fileFromImageUrl(url);
        _createWatermark(picture: fileImage);
        _createAdditionalCamTech(
            picture: fileImage,
            cameraName: cameraName,
            temperature: temperature,
            humidity: humidity,
            coop: coop,
            floor: floor,
            cameraPosition: cameraPosition,
            timeTake: timeTake
        );

        if(isDownload){
            Get.snackbar(
                "Message", "Download complete",
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.green,
                duration: Duration(seconds: 5),
                backgroundColor: Colors.white,
            );
        }else{
            Share.shareFiles([pathImage!], text: 'Nama Kamera : ${cameraName} \n Kandang : ${coop} \n Lantai : ${floor} \n Jam Ambil Gambar : ${timeTake} \n Temperature : ${temperature} \n Kelembapan : ${humidity} \n');
        }

    }

    Future<File> _fileFromImageUrl(String url) async {
        final response = await http.get(Uri.parse(url));
        final documentDirectory = await _getDownloadPath();
        int dateTime = DateTime. now(). millisecondsSinceEpoch;
        final file = File('$documentDirectory/${dateTime}.jpg');
        pathImage = "$documentDirectory/${dateTime}.jpg";

        file.writeAsBytesSync(response.bodyBytes);
        return file;
    }

    Future<String?> _getDownloadPath() async {
        Directory? directory;
        try {
            if (Platform.isIOS) {
                directory = await getApplicationDocumentsDirectory();
            } else {
                directory = Directory('/storage/emulated/0/Download');
                if (!await directory.exists()) directory = await getExternalStorageDirectory();
            }
        } catch (err) {
            Get.snackbar(
                "Message", "Cannot get download folder path",
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.white,
                duration: Duration(seconds: 5),
                backgroundColor: Colors.red,
            );
        }

        return directory?.path;
    }

    _createWatermark({required File picture}) {
        ui.Image? originalImage = ui.decodeImage(picture.readAsBytesSync());
        originalImage = ui.copyResize(originalImage!, width: 1280, height: 720);

        ui.Image? watermark = ui.decodeImage(picture.readAsBytesSync());
        watermark = ui.copyResize(watermark!, width: 360, height: 360);
        picture.writeAsBytesSync(ui.encodeJpg(originalImage));
    }

    _createAdditionalCamTech({required File picture, String? cameraName, double? temperature, double? humidity, String? coop, String? floor, String? cameraPosition, String? timeTake}) async {
        ui.Image? originalImage = ui.decodeImage(picture.readAsBytesSync());

        // Create Container
        ui.fillRect(originalImage!, x1: 15, y1: originalImage.height - 245, x2: 500, y2: originalImage.height - 15, color: ui.ColorRgba8(244, 123, 32, 115), radius: 8);

        // Camera Name
        ui.drawString(originalImage, cameraName!, font: ui.arial48, x: 30, y: originalImage.height - 230);

        // Coop Name
        ui.drawString(originalImage, 'Kandang : ${coop == null ? 'N/A' : coop}', font: ui.arial24, x: 30, y: originalImage.height - 176);

        // Floor Name
        ui.drawString(originalImage, 'Lantai : ${floor == null ? 'N/A' : floor}', font: ui.arial24, x: 30, y: originalImage.height - 150);

        // Camera Position
        ui.drawString(originalImage, 'Posisi Kamera : ${cameraPosition == null ? 'N/A' : cameraPosition}', font: ui.arial24, x: 30, y: originalImage.height - 124);

        // Time Take
        ui.drawString(originalImage, 'Jam Ambil Gambar : ${timeTake == null ? 'N/A' : timeTake}', font: ui.arial24, x: 30, y: originalImage.height - 98);

        // Temperature
        ui.drawString(originalImage, 'Suhu : ${temperature == null ? 'N/A' : '$temperature °C'}', font: ui.arial24, x: 30, y: originalImage.height - 72);

        // Humidity
        ui.drawString(originalImage, 'Kelembaban : ${humidity == null ? 'N/A' : '$humidity %'}', font: ui.arial24, x: 30, y: originalImage.height - 46);

        picture.writeAsBytesSync(ui.encodeJpg(originalImage));
    }
}