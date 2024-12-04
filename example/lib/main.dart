import 'package:camerakit_flutter_example/media_result_screen.dart';
import 'package:camerakit_flutter_example/lens_list_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'constants.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
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
  late List<Lens> lensList = [];
  late final _cameraKitFlutterImpl =
      CameraKitFlutterImpl(cameraKitFlutterEvents: this);
  bool isLensListPressed = false;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initCameraKit() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      await _cameraKitFlutterImpl.openCameraKit(
          groupIds: Constants.groupIdList, isHideCloseButton: false);
    } on PlatformException {
      if (kDebugMode) {
        print("Failed to open camera kit");
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  getGroupLenses() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      _cameraKitFlutterImpl.getGroupLenses(groupIds: Constants.groupIdList);
    } on PlatformException {
      if (kDebugMode) {
        print("Failed to open camera kit");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Kit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  isLensListPressed = true;
                  setState(() {});
                  getGroupLenses();
                },
                child: const Text("Show Lens List")),
            ElevatedButton(
                onPressed: () {
                  initCameraKit();
                },
                child: const Text("Open CameraKit")),
            isLensListPressed ? const CircularProgressIndicator() : Container()
          ],
        ),
      ),
    );
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
      _filePath = result["path"] as String;
      _fileType = result["type"] as String;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MediaResultWidget(
                filePath: _filePath,
                fileType: _fileType,
              )));
    });
  }

  @override
  void receivedLenses(List<Lens> lensList) async {
    isLensListPressed = false;
    setState(() {});
    final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LensListView(lensList: lensList)))
        as Map<String, dynamic>?;
    final lensId = result?['lensId'] as String?;
    final groupId = result?['groupId'] as String?;

    if ((lensId?.isNotEmpty ?? false) && (groupId?.isNotEmpty ?? false)) {
      _cameraKitFlutterImpl.openCameraKitWithSingleLens(
          lensId: lensId!, groupId: groupId!, isHideCloseButton: false);
    }
  }
}
