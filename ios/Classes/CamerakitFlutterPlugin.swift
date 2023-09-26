import Flutter
import UIKit
import SCSDKCameraKit
import SCSDKCameraKitReferenceUI

public class CamerakitFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: Configuration.shared.channelName, binaryMessenger: registrar.messenger())
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
            cameraViewController.onDismiss = { [weak self] in
                guard let lastPath = cameraViewController.url?.path,
                      let mimeType = cameraViewController.mimeType
                else {
                    print("Something went wrong, Received invalid url")
                    return
                }

                self?.getChannel()?.invokeMethod(OutputMethods.CAMERA_KIT_RESULTS, arguments: [
                    "path" : lastPath,
                    "type" : mimeType
                ])
            }
            
            let rootViewController = (UIApplication.shared.keyWindow?.rootViewController as! FlutterViewController)
            rootViewController.present(cameraViewController, animated: false)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func getChannel() -> FlutterMethodChannel? {
        guard let contoller = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController else {
            return nil
        }
        
        return FlutterMethodChannel(name: Configuration.shared.channelName, binaryMessenger: contoller.binaryMessenger)
    }
}
