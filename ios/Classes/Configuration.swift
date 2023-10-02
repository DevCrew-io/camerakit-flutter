import Foundation

final class Configuration {
    private init(appId: String = "", apiToken: String = "", groupIds: [String] = [], lensId: String = "", channelName: String = "camerakit_flutter") {
        self.appId = appId
        self.apiToken = apiToken
        self.groupIds = groupIds
        self.lensId = lensId
        self.channelName = channelName
    }
    
    public static let shared = Configuration()
    var appId: String
    var apiToken: String
    var groupIds: [String]
    var lensId: String
    var channelName: String
    
    func fromMap(_ arguments: [String: Any]) {
        self.appId = arguments["appId"] as? String ?? ""
        self.groupIds = arguments["groupIds"] as? [String] ?? []
        self.apiToken = arguments["token"] as? String ?? ""
        self.lensId = arguments["lensId"] as? String ?? ""
    }
}
