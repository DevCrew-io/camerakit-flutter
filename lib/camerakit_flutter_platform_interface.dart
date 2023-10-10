import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/services.dart';
import 'camerakit_flutter_method_channel.dart';
import 'configuration_camerakit.dart';
import 'lens_model.dart';

abstract class CamerakitFlutterPlatform extends PlatformInterface {
  /// Constructs a CamerakitFlutterPlatform.
  CamerakitFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static CamerakitFlutterPlatform _instance = MethodChannelCamerakitFlutter();

  /// The default instance of [CamerakitFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelCamerakitFlutter].
  static CamerakitFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CamerakitFlutterPlatform] when
  /// they register themselves.
  static set instance(CamerakitFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  MethodChannel getMethodChannel() {
    throw UnimplementedError('getMethodChannel() has not been implemented.');
  }

  Future<String?> openCameraKit() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  setCameraKitCredentials(Configuration configuration) {
    throw UnimplementedError(
        'setTwoCheckCredentials() has not been implemented.');
  }

  Future<List<LensModel>> getGroupLenses() {
    throw UnimplementedError('getGroupLenses has not been implemented.');
  }
}
