
import Foundation

class NetworkManager {
    // MARK: Lifecycle

    private init() {}

    deinit {
        debugPrint("NetworkManager deinited")
    }

    // MARK: Internal

    class var shared: NetworkManager {
        guard let sharedInstance else {
            let instance = NetworkManager()
            sharedInstance = instance
            return sharedInstance ?? .init()
        }
        return sharedInstance
    }

    lazy var authenticationRepository: AuthenticationRepository? = .init(apiRrequest: self.apiRequest)

    class func destroy() {
        sharedInstance = nil
    }

    // MARK: Private

    private static var sharedInstance: NetworkManager?

    private lazy var apiRequest: APIRequest = .init()
}
