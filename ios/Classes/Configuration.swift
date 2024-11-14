import Foundation

final class Configuration {
    public static let shared = Configuration()
    
    var channelName: String
    
    private init(apiToken: String = "", groupIds: [String] = [], lensId: String = "", channelName: String = "camerakit_flutter", isHideCloseButton: Bool = false) {
        self.channelName = channelName
    }
}
