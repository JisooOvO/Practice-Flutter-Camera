import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:practice_flutter_camera/models/image_saver.dart';

class CameraScreenController {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;
  late final void Function(Function()) setState;

  int _currentCameraIndex = 0;

  CameraController get controller => _controller;
  Future<void> get initializeControllerFuture => _initializeControllerFuture;

  //--------------------------------------------------------------------------------

  void initState(
    List<CameraDescription> cameras,
    void Function(Function()) setState,
  ) {
    this.setState = setState;

    _cameras = cameras;

    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  //--------------------------------------------------------------------------------

  void dispose() {
    _controller.dispose();
  }

  //--------------------------------------------------------------------------------

  // 카메라 전환 함수
  void switchCamera() async {
    setState(() {
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    });

    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.medium,
    );

    await _controller.initialize();

    setState(() {});
  }

  //--------------------------------------------------------------------------------

  // 사진 찍기 함수
  Future<void> takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      ImageSaver.saveImageToGallery(image.path);
    } catch (e) {
      log(e.toString());
    }
  }
}
