
import Alamofire
import Combine
import Foundation

// MARK: - RegistrationServicesProtocols

protocol RegistrationServicesProtocols {
    func registerUser(username: String, password: String) -> AnyPublisher<RegisterDomainModel, AFError>
}

// MARK: - RegistrationServices

class RegistrationServices {
    // MARK: Lifecycle

    init(apiRequest: APIRequest) {
        self.apiRequest = apiRequest
    }

    deinit {
        debugPrint("service deinited")
    }

    // MARK: Private

    private var apiRequest: APIRequest
}

// MARK: RegistrationServicesProtocols

extension RegistrationServices: RegistrationServicesProtocols {
    func registerUser(username: String, password: String) -> AnyPublisher<RegisterDomainModel, Alamofire.AFError> {
        self.apiRequest.request(RegistrationRouter.registerUser(username: username, password: password))
    }
}

extension RegistrationServices {
    enum RegistrationRouter: NetworkRouter {
        case registerUser(username: String, password: String)

        // MARK: Internal

        var baseURLString: String {
            return "your base url EX: https://yourdomain.com/api/v1"
        }

        var path: String {
            return "your path EX: authentication/register"
        }

        var headers: [String: String]? {
            return RequestHeaderBuilder.shared
                .addAcceptEncodingHeaders(type: .gzip)
                .addAcceptHeaders(type: .applicationJson)
                .addConnectionHeader(type: .keepAlive)
                .addAuthorizationHeader(type: .Bearer)
                .addContentTypeHeader(type: .applicationJsonUTF8)
                .build()
        }

        var method: RequestMethod? {
            return .post
        }

        var encoding: ParameterEncoding? {
            return JSONEncoding.default
        }

        var params: [String: Any]? {
            var dictionary = [String: Any]()
            switch self {
            case .registerUser(let username, let password):
                dictionary.updateValue(username, forKey: "username")
                dictionary.updateValue(password, forKey: "password")
            }
            return dictionary
        }
    }
}
