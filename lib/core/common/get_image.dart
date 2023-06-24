import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techni_quick/core/constant.dart';

class GetImageFromCameraAndGellary extends StatelessWidget {
  final Function(File) onPickImage;
  final bool isVideo;

  GetImageFromCameraAndGellary(
      {Key? key, required this.onPickImage, this.isVideo = false})
      : super(key: key);

  final ImagePicker _picker = ImagePicker();

  Future getImagefromcamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      maxHeight: 4000,
      maxWidth: 3000,
    );
    if (pickedFile != null) {
      onPickImage(File(pickedFile.path));
    } else {}
  }

  Future getImagefromgallary() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      // imageQuality: 50,
    );

    // setState(() {
    if (pickedFile != null) {
      onPickImage(File(pickedFile.path));
    } else {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.photo, size: 25, color: darkerColor),
          title: Text(
            // ignore: deprecated_member_use
            tr('gallery'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () {
            getImagefromgallary();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt_outlined,
              size: 25, color: darkerColor),
          title: Text(
            // ignore: deprecated_member_use
            tr('camera'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            getImagefromcamera();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
