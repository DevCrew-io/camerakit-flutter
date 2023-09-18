
import 'camerakit_flutter_platform_interface.dart';

class CamerakitFlutter {
  Future<String?> getPlatformVersion() {
    return CamerakitFlutterPlatform.instance.getPlatformVersion();
  }
}
