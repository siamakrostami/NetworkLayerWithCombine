
import Foundation

class AuthenticationRepository {
    // MARK: Lifecycle

    deinit {
        debugPrint("repository deinited")
    }

    init(apiRrequest: APIRequest) {
        self.apiRrequest = apiRrequest
    }

    // MARK: Internal

    lazy var registrationService: RegistrationServices? = .init(apiRequest: self.apiRrequest)

    // MARK: Private

    private var apiRrequest: APIRequest
}
