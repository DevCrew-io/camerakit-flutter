import Flutter
import UIKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

public class CamerakitFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "camerakit_flutter", binaryMessenger: registrar.messenger())
        let instance = CamerakitFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case InputMethods.SET_CAMERA_KIT_CREDENTIALS:
            if let arguments = call.arguments as? [String : String] {
                Configuration.shared.appId = arguments["appId"] ?? ""
                Configuration.shared.groupId = arguments["groupId"] ?? ""
                Configuration.shared.apiToken = arguments["token"] ?? ""
                Configuration.shared.lensId = arguments["lensId"] ?? ""
            }
        case InputMethods.OPEN_CAMERA_KIT:
            
            let cameraController = CameraController(sessionConfig: SessionConfig(apiToken: Configuration.shared.apiToken))
            cameraController.groupIDs = [Configuration.shared.groupId]
            let cameraViewController = FlutterCameraViewController(cameraController: cameraController)
            cameraViewController.modalPresentationStyle = .fullScreen
            cameraViewController.onDismiss = {
                guard let lastPath = cameraViewController.url?.path,
                      let mimeType = cameraViewController.mimeType
                else {
                    print("Something went wrong received invalid url")
                    return
                }

                result([
                    "path": lastPath,
                    "type": mimeType
                ])
            }
            
            let rootViewController = (UIApplication.shared.keyWindow?.rootViewController as! FlutterViewController)
            rootViewController.present(cameraViewController, animated: false)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
