// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'camerakit_flutter_platform_interface.dart';

/// A web implementation of the CamerakitFlutterPlatform of the CamerakitFlutter plugin.
class CamerakitFlutterWeb extends CamerakitFlutterPlatform {
  /// Constructs a CamerakitFlutterWeb
  CamerakitFlutterWeb();

  static void registerWith(Registrar registrar) {
    CamerakitFlutterPlatform.instance = CamerakitFlutterWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> openCameraKit() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  setCameraKitCredentials(String appId, String GroupId, String token) {
    // TODO: implement setCameraKitCredentials
    return super.setCameraKitCredentials(appId, GroupId, token);
  }
}
