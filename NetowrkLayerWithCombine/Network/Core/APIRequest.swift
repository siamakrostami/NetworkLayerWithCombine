
import Alamofire
import Combine
import Foundation
import Swime

// MARK: - APIRequestProtocols

protocol APIRequestProtocols {
    func request<T: Codable>(_ endpoint: URLRequestConvertible) -> AnyPublisher<T, AFError>
    func uploadRequest<T: Codable>(_ endpoint: URLRequestConvertible, file: Data?, fileName: String?, progressCompletion: @escaping (Double) -> Void) -> AnyPublisher<T, AFError>
}

// MARK: - APIRequest

class APIRequest {
    // MARK: Lifecycle

    init() {
        let config = URLSessionConfiguration.af.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        self.sessionManager = Session(configuration: config, interceptor: Interceptor(adapter: NetworkAdapter(), retrier: NetworkRetrier(limit: 2, delay: 30)))
    }
    
    deinit{
        debugPrint("APIRequest deinited")
    }

    // MARK: Private

    private var sessionManager: Session
    private let queue = DispatchQueue(label: "network-queue", qos: .userInitiated, attributes: .concurrent)
}

// MARK: APIRequestProtocols

extension APIRequest: APIRequestProtocols {
    func uploadRequest<T>(_ endpoint: URLRequestConvertible, file: Data?, fileName: String?, progressCompletion: @escaping (Double) -> Void) -> AnyPublisher<T, AFError> where T: Decodable, T: Encodable {
        do {
            let urlRequest = try endpoint.asURLRequest()
            let request = sessionManager.upload(multipartFormData: { multiPart in
                guard let file = file else {
                    return
                }
                guard let type = Swime.mimeType(data: file) else {
                    return
                }
                multiPart.append(file, withName: fileName ?? "file", mimeType: type.mime)
            }, with: urlRequest)
            return request
                .validate()
                .uploadProgress(closure: { progress in
                    progressCompletion(progress.fractionCompleted)
                })
                .publishDecodable(type: T.self)
                .value()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()

        } catch {
            return Fail(error: AFError.createURLRequestFailed(error: error)).eraseToAnyPublisher()
        }
    }

    func request<T>(_ endpoint: URLRequestConvertible) -> AnyPublisher<T, AFError> where T: Decodable, T: Encodable {
        do {
            let urlRequest = try endpoint.asURLRequest()
            let request = sessionManager.request(urlRequest, interceptor: Interceptor(adapter: NetworkAdapter(), retrier: NetworkRetrier(limit: 2, delay: 30)))
            return request
                .validate()
                .publishDecodable(type: T.self)
                .value()
                .subscribe(on: queue)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: AFError.createURLRequestFailed(error: error)).eraseToAnyPublisher()
        }
    }
}
