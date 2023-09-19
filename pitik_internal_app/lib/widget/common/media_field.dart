// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, constant_identifier_names

import 'dart:io';

import 'package:components/media_field/media_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

class MediaField extends StatelessWidget {

    static const int ALL = 1;
    static const int PHOTO = 2;
    static const int VIDEO = 3;

    MediaFieldController controller;
    String label;
    String hint;
    String alertText;
    bool hideLabel = false;
    int type;
    bool showGallerOptions;
    Function(File?) onMediaResult;

    MediaField({super.key, required this.controller, required this.onMediaResult, required this.label, required this.hint, required this.alertText, this.hideLabel = false, this.type = ALL, this.showGallerOptions = true});

    MediaFieldController getController() {
        return Get.find<MediaFieldController>(tag: controller.tag);
    }

    @override
    Widget build(BuildContext context) {
        final labelField = SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
                label,
                textAlign: TextAlign.left,
                style: const TextStyle(color: AppColors.black, fontSize: 14),
            ),
        );

        return Obx(() =>
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                    children: <Widget>[
                        controller.hideLabel.isFalse ? label.isEmpty? Container() : labelField : Container(),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Column(
                                children: <Widget>[
                                    GestureDetector(
                                        onTap: () => _showChooserInBottomSheet(context),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: AppColors.primaryLight,
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(color: controller.activeField.isTrue && controller.showTooltop.isFalse ? AppColors.primaryOrange : controller.activeField.isTrue && controller.showTooltop.isTrue ? AppColors.red : Colors.white, width: 2)
                                            ),
                                            child: Row(
                                                children: [
                                                    Padding(
                                                        padding: const EdgeInsets.only(right: 16, left: 8),
                                                        child: SvgPicture.asset("images/icon_camera.svg")
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                            controller.fileName.value == "" ? hint : controller.fileName.value,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(color: controller.activeField.isTrue ? AppColors.primaryOrange : AppColors.black, fontSize: 14)
                                                        )
                                                    )
                                                ],
                                            ),
                                        ),
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: controller.showTooltop.isTrue
                                            ? Container(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Row(
                                                children: [
                                                    Padding(
                                                        padding: const EdgeInsets.only(right: 8),
                                                        child: SvgPicture.asset("images/error_icon.svg")
                                                    ),
                                                    Text(
                                                        alertText,
                                                        style: const TextStyle(color: AppColors.red, fontSize: 12),
                                                    )
                                                ],
                                            )
                                        ) : Container(),
                                    )
                                ],
                            )
                        ),
                    ],
                ),
            )
        );
    }

    void _showChooserInBottomSheet(BuildContext context) {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
            builder: (context) {
                return Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: setTile(context),
                    ),
                );
            }
        );
    }

    List<Widget> setTile(BuildContext context) {
        List<Widget> tileList = [];

        if (type == PHOTO) {
            tileList.add(_tilePhoto(context));
        } else if (type == VIDEO) {
            tileList.add(_tileVideo(context));
        } else {
            tileList.add(_tilePhoto(context));
            tileList.add(_tileVideo(context));
        }

        if (showGallerOptions) {
            if (type == PHOTO) {
                tileList.add(_tileGalleryPhoto(context));
            } else if (type == VIDEO) {
                tileList.add(_tileGalleryVideo(context));
            } else {
                tileList.add(_tileGalleryPhoto(context));
                tileList.add(_tileGalleryVideo(context));
            }
        }

        return tileList;
    }

    Widget _tileVideo(BuildContext context) {
        return ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('Record Video'),
            onTap: () async {
                Navigator.pop(context);
                XFile? result = await ImagePicker().pickVideo(source: ImageSource.camera);

                if (result == null) {
                    return onMediaResult(null);
                } else {
                    File fileResult = File(result.path);
                    controller.setFileName(basename(fileResult.path));
                    return onMediaResult(fileResult);
                }
            },
        );
    }

    Widget _tilePhoto(BuildContext context) {
        return ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Take Photo'),
            onTap: () async {
                Navigator.pop(context);
                XFile? result = await ImagePicker().pickImage(source: ImageSource.camera);

                if (result == null) {
                    return onMediaResult(null);
                } else {
                    File fileResult = File(result.path);
                    controller.setFileName(basename(fileResult.path));
                    return onMediaResult(fileResult);
                }
            },
        );
    }

    Widget _tileGalleryPhoto(BuildContext context) {
        return ListTile(
            leading: const Icon(Icons.browse_gallery),
            title: const Text('Photo Gallery'),
            onTap: () async {
                Navigator.pop(context);
                XFile? result = await ImagePicker().pickImage(source: ImageSource.gallery);

                if (result == null) {
                    return onMediaResult(null);
                } else {
                    File fileResult = File(result.path);
                    controller.setFileName(basename(fileResult.path));
                    return onMediaResult(fileResult);
                }
            },
        );
    }

    Widget _tileGalleryVideo(BuildContext context) {
        return ListTile(
            leading: const Icon(Icons.browse_gallery),
            title: const Text('Video Gallery'),
            onTap: () async {
                Navigator.pop(context);
                XFile? result = await ImagePicker().pickVideo(source: ImageSource.gallery);

                if (result == null) {
                    return onMediaResult(null);
                } else {
                    File fileResult = File(result.path);
                    controller.setFileName(basename(fileResult.path));
                    return onMediaResult(fileResult);
                }
            },
        );
    }
}