//
//  camerakit_flutter.dart
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

import 'dart:convert';
import 'package:camerakit_flutter/lens_model.dart';
import 'camerakit_flutter_platform_interface.dart';
import 'package:flutter/services.dart';
import 'configuration_camerakit.dart';

/// CameraKitFlutterImpl is a class responsible for handling method calls and events from the CameraKit platform.

class CameraKitFlutterImpl {
  final CameraKitFlutterEvents cameraKitFlutterEvents;

  /// Constructor for CameraKitFlutterImpl.
  /// [cameraKitFlutterEvents] is an object that defines event handlers for CameraKit.

  CameraKitFlutterImpl({required this.cameraKitFlutterEvents}) {
    // Obtain the method channel from the CameraKit platform.
    CamerakitFlutterPlatform.instance
        .getMethodChannel()
        .setMethodCallHandler((MethodCall call) async {
      // Handle method calls based on their method name.
      switch (call.method) {
        case 'cameraKitResults':
          // When 'cameraKitResults' method is called, trigger the corresponding event with the provided arguments.
          cameraKitFlutterEvents.onCameraKitResult(call.arguments);
          break;
        case 'receivedLenses':
          // When 'receiveLenses' method is called, decode the JSON arguments and map them to Lens objects.
          final List<dynamic> list = json.decode(call.arguments);
          final List<Lens> lensList =
              list.map((item) => Lens.fromJson(item)).toList();
          // Trigger the 'receiveLenses' event with the list of Lens objects.
          cameraKitFlutterEvents.receivedLenses(lensList);
          break;
      }
    });
  }

  /// Asynchronously opens the CameraKit.
  Future<String?> openCameraKit() {
    return CamerakitFlutterPlatform.instance.openCameraKit();
  }

  /// Method to set Snap CameraKit credentials.
  setCredentials(Configuration configuration) {
    CamerakitFlutterPlatform.instance.setCameraKitCredentials(configuration);
  }

  /// Asynchronously retrieves group lenses from the CameraKit.
  Future<void> getGroupLenses(List<String> groupIds) {
    return CamerakitFlutterPlatform.instance.getGroupLenses(groupIds);
  }
}

/// Abstract class defining event callbacks related to CameraKit.

abstract class CameraKitFlutterEvents {
  /// Callback for when a CameraKit result is received.
  void onCameraKitResult(Map<dynamic, dynamic> result);

  /// Callback for receiving a list of lenses.
  void receivedLenses(List<Lens> lensList);
}