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
    
    let lensesConfig = LensesConfig(cacheConfig: CacheConfig(lensContentMaxSize: 150 * 1024 * 1024))
    var cameraKitSession: CameraKitProtocol?
    
    var groupLenses = [String]()
    var lensesDictionary = [String : [Lens]]()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case InputMethods.SET_CAMERA_KIT_CREDENTIALS:
            if let arguments = call.arguments as? [String : Any] {
                Configuration.shared.fromMap(arguments)
            }
            
            /// Create CameraKit session for later use e.g fetching lenses with list of group id
            guard !Configuration.shared.apiToken.isEmpty && Configuration.shared.apiToken != "your-api-token" else {
                print("CameraKit: Invalid Api Token")
                return
            }
            cameraKitSession = Session(sessionConfig: SessionConfig(apiToken: Configuration.shared.apiToken), lensesConfig: lensesConfig, errorHandler: nil)
            
        case InputMethods.GET_GROUP_LENSES:
            guard let arguments = call.arguments as? [String] else { return }
            
            groupLenses = arguments
            lensesDictionary.removeAll()
            for id in groupLenses {
                cameraKitSession?.lenses.repository.addObserver(self, groupID: id)
            }
            
        case InputMethods.OPEN_CAMERA_KIT:
            let cameraController = CameraController(sessionConfig: SessionConfig(apiToken: Configuration.shared.apiToken))
            cameraController.groupIDs = Configuration.shared.groupIds
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

extension CamerakitFlutterPlugin: LensRepositoryGroupObserver {
    public func repository(_ repository: LensRepository, didUpdateLenses lenses: [Lens], forGroupID groupID: String) {
        lensesDictionary[groupID] = lenses
        
        guard groupLenses.count == lensesDictionary.count else { return }
        
        var allLenses = [Lens]()
        for lenses in lensesDictionary.values {
            allLenses.append(contentsOf: lenses)
        }
        let resultDict: [[String : Any]] = allLenses.map { lens in
            return [
                "id" : lens.id,
                "name" : lens.name ?? "",
                "facePreference" : lens.facingPreference == .front ? "FRONT" : lens.facingPreference == .back ? "BACK" : "NONE",
                "groupId" : lens.groupId,
                "snapcodes" : [],
                "vendorData" : lens.vendorData,
                "previews" : [lens.preview.imageUrl?.absoluteString ?? ""],
                "thumbnail" : [lens.iconUrl?.absoluteString ?? ""]
            ] as [String : Any]
        }

        let jsonString = resultDict.toJSONString()
        getChannel()?.invokeMethod(OutputMethods.RECEIVED_LENSES, arguments: jsonString)
    }
    
    public func repository(_ repository: LensRepository, didFailToUpdateLensesForGroupID groupID: String, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
}
