import 'dart:io';

import 'package:camerakit_flutter/configuration_camerakit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:video_player/video_player.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements CameraKitFlutterEvents {
  /// There will be interface that we will implement on [_MyAppState] class in the future,
  /// right now we have no method to show override any function
  late String _filePath = '';
  late String _fileType = '';
  late VideoPlayerController _controller;
  late final _cameraKitFlutterImpl =
      CameraKitFlutterImpl(cameraKitFlutterEvents: this);

  @override
  void initState() {
    super.initState();
    final config = Configuration(
      Constants.cameraKitAppId,
      [Constants.cameraKitGroupId, Constants.cameraKitGroupId2],
      Constants.cameraKitApiTokenStaging,
      Constants.cameraKitLensId,
    );
    _cameraKitFlutterImpl.setCredentials(config);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initCameraKit() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      await _cameraKitFlutterImpl.openCameraKit();
    } on PlatformException {
      if (kDebugMode) {
        print("Failed to open camera kit");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                initCameraKit();
              },
              child: const Icon(Icons.camera),
            ),
            _filePath.isNotEmpty && _fileType == "video"
                ? FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  )
                : Container()
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             /* SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
              ),*/
              _filePath.isNotEmpty
                  ? _fileType == 'video'
                      ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                      : _fileType == 'image'
                          ? Image.file(File(_filePath))
                          : const Text("UnKnown File to show")
                  : const Text("No Image/Video to Preview")
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
      _filePath = result["path"] as String;
      _fileType = result["type"] as String;

      _controller = VideoPlayerController.file(File(_filePath))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    });

    if (kDebugMode) {
      print('Result received in flutter=>>>>>>>>>>>>>>>>>>>>>>>> $result');
    }
  }
}
