import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:practice_flutter_camera/views/camera_screen/camera_screen_controller.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({
    super.key,
    required this.cameras,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraScreenController _controller = CameraScreenController();

  @override
  void initState() {
    super.initState();
    _controller.initState(widget.cameras, setState);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카메라 연습'),
      ),
      body: FutureBuilder<void>(
        future: _controller.initializeControllerFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller.controller);
          }
          // Otherwise, display a loading indicator.
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _controller.switchCamera,
            icon: const Icon(Icons.switch_camera),
          ),
          ElevatedButton(
            onPressed: () async {
              await _controller.takePicture();
            },
            child: const Text("사진 찍기"),
          ),
        ],
      ),
    );
  }
}
