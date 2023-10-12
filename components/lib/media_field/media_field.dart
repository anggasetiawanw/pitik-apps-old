// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages, constant_identifier_names

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../global_var.dart';
import 'media_field_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class MediaField extends StatelessWidget {

    static const int ALL = 1;
    static const int PHOTO = 2;
    static const int VIDEO = 3;
    static const int DOCUMENT = 4;

    MediaFieldController controller;
    String label;
    String hint;
    String alertText;
    bool multi;
    bool hideLabel = false;
    int type;
    bool showGalleryOptions;
    Function(File?) onMediaResult;

    MediaField({super.key, required this.controller, required this.onMediaResult, required this.label, required this.hint, required this.alertText, this.hideLabel = false, this.type = ALL, this.showGalleryOptions = true, this.multi =false,});

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
                style: const TextStyle(color: GlobalVar.black, fontSize: 14),
            ),
        );

        return Obx(() =>
            Padding(
                key: controller.formKey,
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                    children: <Widget>[
                        controller.hideLabel.isFalse ? label.isEmpty ? Container() : labelField : Container(),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Column(
                                children: <Widget>[
                                    GestureDetector(
                                        onTap: () => _showChooserInBottomSheet(context),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFFFF9ED),
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(color: controller.activeField.isTrue && controller.showTooltop.isFalse ? GlobalVar.primaryOrange : controller.activeField.isTrue && controller.showTooltop.isTrue ? GlobalVar.red : Colors.white, width: 2)
                                            ),
                                            child: Row(
                                                children: [
                                                    Padding(
                                                        padding: const EdgeInsets.only(right: 16, left: 8),
                                                        child: Icon(
                                                            type == ALL ? Icons.perm_media :
                                                            type == PHOTO ? Icons.photo_camera :
                                                            type == VIDEO ? Icons.videocam :
                                                            Icons.document_scanner, color: GlobalVar.primaryOrange,
                                                        ),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                            multi ? label : controller.fileName.value == "" ? label : controller.fileName.value,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.black, fontSize: 14)
                                                        )
                                                    )
                                                ],
                                            ),
                                        ),
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: controller.showTooltop.isTrue ? Container(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Row(
                                                children: [
                                                    Padding(
                                                        padding: const EdgeInsets.only(right: 8),
                                                        child: Image.asset('images/error_icon.png')
                                                    ),
                                                    Text(
                                                        alertText,
                                                        style: const TextStyle(color: GlobalVar.red, fontSize: 12),
                                                    )
                                                ],
                                            )
                                        ) : const SizedBox(),
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: controller.showInformasi.isTrue ? Container(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Row(
                                                children: [
                                                    Padding(
                                                        padding: const EdgeInsets.only(right: 8),
                                                        child: SvgPicture.asset("images/information_blue_icon.svg")
                                                    ),
                                                    Text(
                                                        controller.informasiText.value,
                                                        style: const TextStyle(color: GlobalVar.blue, fontSize: 12),
                                                    )
                                                ],
                                            )
                                        ) : const SizedBox(),
                                    )
                                ],
                            )
                        ),
                    ],
                ),
            )
        );
    }

    /// The function `_showChooserInBottomSheet` shows a modal bottom sheet with a
    /// column of tiles in a Flutter app.
    ///
    /// Args:
    ///   context (BuildContext): The context parameter is the BuildContext object
    /// that represents the current build context of the widget tree. It is used to
    /// access the theme, media query, and other properties of the current build
    /// context.
    ///
    /// Returns:
    ///   a `Padding` widget.
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

    /// The function `setTile` returns a list of widgets based on the type of
    /// content and whether to show gallery options.
    ///
    /// Args:
    ///   context (BuildContext): The `BuildContext` is an object that provides
    /// information about the current build context, such as the theme, media
    /// queries, and localization. It is typically used to access resources and
    /// widgets within the widget tree.
    ///
    /// Returns:
    ///   The method is returning a List of Widget objects.
    List<Widget> setTile(BuildContext context) {
        List<Widget> tileList = [];

        if (type == PHOTO) {
            tileList.add(_tilePhoto(context));
        } else if (type == VIDEO) {
            tileList.add(_tileVideo(context));
        } else if (type == DOCUMENT) {
            tileList.add(_tileDocument(context));
        } else {
            tileList.add(_tilePhoto(context));
            tileList.add(_tileVideo(context));
            tileList.add(_tileDocument(context));
        }

        if (showGalleryOptions) {
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

    /// The `_tileDocument` function creates a ListTile widget with an icon and
    /// text, and allows the user to pick a document file using the FilePicker
    /// plugin.
    ///
    /// Args:
    ///   context (BuildContext): The `BuildContext` is an object that provides
    /// access to various properties and methods related to the current build
    /// context. It is typically used to access the theme, media queries, and to
    /// navigate to other screens or widgets.
    ///
    /// Returns:
    ///   The `ListTile` widget is being returned.
    Widget _tileDocument(BuildContext context) {
        return ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Document'),
            onTap: () async {
                Navigator.pop(context);
                FilePickerResult? result = await FilePicker.platform.pickFiles();

                if (result != null) {
                    File fileResult = File(result.files.single.path!);
                    controller.setFileName(basename(fileResult.path));
                    controller.hideAlert();
                    return onMediaResult(fileResult);
                } else {
                    return onMediaResult(null);
                }
            },
        );
    }

    /// The `_tileVideo` function creates a ListTile widget that allows the user to
    /// record a video using the device's camera.
    ///
    /// Args:
    ///   context (BuildContext): The `BuildContext` object represents the location
    /// of a widget in the widget tree. It is used to access the properties and
    /// methods of the current widget and its ancestors.
    ///
    /// Returns:
    ///   The `Widget` being returned is a `ListTile` widget.
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
                    controller.hideAlert();
                    return onMediaResult(fileResult);
                }
            },
        );
    }

    /// The `_tilePhoto` function creates a ListTile widget with an icon and text,
    /// and when tapped, it opens the camera to take a photo and returns the result.
    ///
    /// Args:
    ///   context (BuildContext): The `BuildContext` is a parameter that represents
    /// the current build context of the widget tree. It is typically used to access
    /// the theme, localization, and other information related to the current build
    /// context. In this case, it is used to navigate back to the previous screen
    /// when the photo is taken.
    ///
    /// Returns:
    ///   The `Widget` being returned is a `ListTile` widget.
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
                    controller.hideAlert();
                    return onMediaResult(fileResult);
                }
            },
        );
    }

    /// The `_tileGalleryPhoto` function creates a ListTile widget that allows the
    /// user to select an image from the photo gallery and returns the selected
    /// image file.
    ///
    /// Args:
    ///   context (BuildContext): The `BuildContext` object represents the location
    /// in the widget tree where the `ListTile` is being built. It is used to access
    /// the current theme, localization, and other information related to the widget
    /// tree.
    ///
    /// Returns:
    ///   a ListTile widget.
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
                    controller.hideAlert();
                    return onMediaResult(fileResult);
                }
            },
        );
    }

    /// The `_tileGalleryVideo` function returns a ListTile widget that allows the
    /// user to pick a video from the gallery and returns the selected video file.
    ///
    /// Args:
    ///   context (BuildContext): The `BuildContext` object represents the location
    /// in the widget tree where the `ListTile` is being built. It is used to access
    /// the current theme, localization, and other information related to the widget
    /// tree.
    ///
    /// Returns:
    ///   a ListTile widget.
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
                    controller.hideAlert();
                    return onMediaResult(fileResult);
                }
            },
        );
    }
}