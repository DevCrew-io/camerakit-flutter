import Foundation

final class Configuration {
    public static let shared = Configuration()
    
    var apiToken: String
    var groupIds: [String]
    var lensId: String
    var channelName: String
    var isHideCloseButton: Bool
    
    private init(apiToken: String = "", groupIds: [String] = [], lensId: String = "", channelName: String = "camerakit_flutter", isHideCloseButton: Bool = false) {
        self.apiToken = apiToken
        self.groupIds = groupIds
        self.lensId = lensId
        self.channelName = channelName
        self.isHideCloseButton = isHideCloseButton
    }
    
    func fromMap(_ arguments: [String: Any]) {
        self.groupIds = arguments["groupIds"] as? [String] ?? []
        self.apiToken = arguments["token"] as? String ?? ""
        self.lensId = arguments["lensId"] as? String ?? ""
        self.isHideCloseButton = arguments["isHideCloseButton"] as? Bool ?? false
    }
}
