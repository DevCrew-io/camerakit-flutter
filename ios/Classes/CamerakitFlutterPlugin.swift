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
    
    private static func currentRootViewController() -> UIViewController? {
        // Prefer the key window from any active foreground scene
        let activeScenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { [.foregroundActive, .foregroundInactive].contains($0.activationState) }
        
        for scene in activeScenes {
            if let keyWindow = scene.windows.first(where: { $0.isKeyWindow }) {
                return keyWindow.rootViewController
            }
            if let window = scene.windows.first {
                return window.rootViewController
            }
        }
        
        // Fallback: check any scene/window if none are active
        for case let scene as UIWindowScene in UIApplication.shared.connectedScenes {
            if let keyWindow = scene.windows.first(where: { $0.isKeyWindow }) {
                return keyWindow.rootViewController
            }
            if let window = scene.windows.first {
                return window.rootViewController
            }
        }
        
        return nil
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case InputMethods.GET_GROUP_LENSES:
            guard let arguments = call.arguments as? [String : Any]
            else { return }
            
            groupLenses = arguments["groupIds"] as? [String] ?? []
            print(groupLenses)
            lensesDictionary.removeAll()
            cameraKitSession = Session(lensesConfig: lensesConfig, errorHandler: nil)
            for id in groupLenses {
                cameraKitSession?.lenses.repository.addObserver(self, groupID: id)
            }
            
        case InputMethods.OPEN_SINGLE_LENS:
            guard let arguments = call.arguments as? [String : Any],
                  let lensId = arguments["lensId"] as? String,
                  let groupId = arguments["groupId"] as? String,
                  let isHideCloseButton = arguments["isHideCloseButton"] as? Bool
            else { return }
            
            
            let cameraPosition = arguments["cameraPosition"] as? String
            openCameraKit(
                groupIds: [groupId],
                lensId: lensId,
                isHideCloseButton: isHideCloseButton,
                cameraPosition: cameraPosition
            )
            
        case InputMethods.OPEN_CAMERA_KIT:
            guard let arguments = call.arguments as? [String : Any],
                  let groupIds = arguments["groupIds"] as? [String],
                  let isHideCloseButton = arguments["isHideCloseButton"] as? Bool
            else { return }
            
            let cameraPosition = arguments["cameraPosition"] as? String
            openCameraKit(
                groupIds: groupIds,
                isHideCloseButton: isHideCloseButton,
                cameraPosition: cameraPosition
            )
            
        default:
            result(FlutterMethodNotImplemented)
        }
        
    }
    
    private func openCameraKit(groupIds: [String], lensId: String = "", isHideCloseButton: Bool = false, cameraPosition: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            var cameraController: CameraController? = CameraController()
            cameraController?.groupIDs = groupIds
            
            guard let cameraControllerUnwrapped = cameraController else { return }
            var cameraViewController: FlutterCameraViewController? = FlutterCameraViewController(cameraController: cameraControllerUnwrapped)
            cameraViewController?.lensId = lensId
            cameraViewController?.isHideCloseButton = isHideCloseButton
            
            if let position = cameraPosition {
                cameraViewController?.cameraPosition = position == "back" ? .back : .front
            }
            
            cameraViewController?.modalPresentationStyle = .fullScreen
            cameraViewController?.onDismiss = { [weak self] in
                guard let lastPath = cameraViewController?.url?.path,
                      let mimeType = cameraViewController?.mimeType else {
                    cameraController = nil
                    cameraViewController = nil
                    print("Something went wrong, Received invalid url")
                    return
                }
                
                cameraController = nil
                cameraViewController = nil
                self?.getChannel()?.invokeMethod(OutputMethods.CAMERA_KIT_RESULTS, arguments: [
                    "path": lastPath,
                    "type": mimeType
                ])
            }
            
            guard let rootViewController = Self.currentRootViewController() as? FlutterViewController,
                  let cameraVC = cameraViewController else { return }
            rootViewController.present(cameraVC, animated: false)
        }
    }
    
    private func getChannel() -> FlutterMethodChannel? {
        var channel: FlutterMethodChannel?
        let work = {
            if let controller = Self.currentRootViewController() as? FlutterViewController {
                channel = FlutterMethodChannel(name: Configuration.shared.channelName, binaryMessenger: controller.binaryMessenger)
            }
        }
        
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync { work() }
        }
        return channel
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
        cameraKitSession = nil
        getChannel()?.invokeMethod(OutputMethods.RECEIVED_LENSES, arguments: jsonString)
    }
    
    public func repository(_ repository: LensRepository, didFailToUpdateLensesForGroupID groupID: String, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
}

