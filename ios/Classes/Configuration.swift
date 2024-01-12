import Foundation

final class Configuration {
    public static let shared = Configuration()
    
    var apiToken: String
    var channelName: String
    
    private init(apiToken: String = "", groupIds: [String] = [], lensId: String = "", channelName: String = "camerakit_flutter", isHideCloseButton: Bool = false) {
        self.apiToken = apiToken
        self.channelName = channelName
    }
    
    func fromMap(_ arguments: [String: Any]) {
        self.apiToken = arguments["token"] as? String ?? ""
    }
}
