import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _callbackResponse = '';

  static const cameraKitGroupId =
      '853d69ca-aa0c-4c94-9049-9ccaeccc21eb'; //TODO fill group id here
  static const cameraKitApiTokenStaging =
      'eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNjU5NTA4NDI1LCJzdWIiOiI5MTI0MjA0ZC1kNGQxLTQ1MmItODE3NS0wOWRhNWRhNWQ5ZTR-U1RBR0lOR35iZWU4M2ViNy01MDhjLTQwYjItYjc1NS1hMTVlODY0ZTU4ODYifQ.P_cEb6YD-0gKEzSG7LzklIW73gOKC_f_yJ8cF-SkXro'; //TODO fill api token here
  static const cameraKitAppId = '9124204d-d4d1-452b-8175-09da5da5d9e4';

  late final _cameraKitFlutterEventsImpl = CameraKitFlutterEventsImpl();

  @override
  void initState() {
    super.initState();
    _cameraKitFlutterEventsImpl.setTwoCheckoutCredentials(
        cameraKitAppId, cameraKitGroupId, cameraKitApiTokenStaging);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initCameraKit() async {
    String callbackResponse;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      callbackResponse = await _cameraKitFlutterEventsImpl.openCameraKit() ??
          'Unknown platform version';
    } on PlatformException {
      callbackResponse = 'Failed to open camerakit';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _callbackResponse = callbackResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ElevatedButton(onPressed: (){
            initCameraKit();
          }, child: const Text("Open CameraKit")),
        ),
      ),
    );
  }
}
