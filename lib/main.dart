import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:practice_flutter_camera/views/camera_screen/camera_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  runApp(MainScreen(cameras: cameras));
}

class MainScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MainScreen({
    super.key,
    required this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(
        cameras: cameras,
      ),
    );
  }
}
