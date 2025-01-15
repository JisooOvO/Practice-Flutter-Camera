import 'dart:developer';

import 'package:flutter/services.dart';

class ImageSaver {
  static const platform = MethodChannel('com.example.gallery/saveImage');

  static Future<void> saveImageToGallery(String imagePath) async {
    try {
      final result = await platform.invokeMethod(
        'saveImage',
        {
          'imagePath': imagePath,
        },
      );
      log(result);
    } on PlatformException catch (e) {
      log("Failed to save image: '${e.message}'.");
    }
  }
}
