
import Alamofire
import Foundation

// MARK: - RequestMethod

enum RequestMethod: String {
    case get
    case post
    case put
    case patch
    case trace
    case delete
}

// MARK: - NetworkRouter

protocol NetworkRouter: URLRequestConvertible {
    var baseURLString: String { get }
    var method: RequestMethod? { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var queryParams: [String: Any]? { get }
    var encoding: ParameterEncoding? { get }
    var isURLEncoded: Bool { get }
    var isQueryString: Bool { get }
    func asURLRequest() throws -> URLRequest
}

// MARK: - Network Router Protocols impl

extension NetworkRouter {
    //    typealias ResultRouter<T: Codable> = Result<T, Error>
    
    var isURLEncoded: Bool {
        return false
    }
    
    var baseURLString: String {
        return ""
    }
    
    // Add Rout method here
    var method: RequestMethod? {
        return .none
    }
    
    // Set APIs'Rout for each case
    var path: String {
        return ""
    }
    
    // Set header here
    var headers: [String: String]? {
        return [:]
    }
    
    // Set encoding for each APIs
    var encoding: ParameterEncoding? {
        return JSONEncoding.default
    }
    
    // Return each case parameters
    var params: [String: Any]? {
        return [:]
    }
    
    var queryParams: [String: Any]? {
        return [:]
    }
    
    var isQueryString: Bool {
        return false
    }

    var multipartFormData: MultipartFormData? {
        return nil
    }
    
    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURLString.appending(path))
        var urlRequest = URLRequest(url: url ?? URL(string: "google.com")!)
        urlRequest.httpMethod = method?.rawValue.uppercased()
        urlRequest.allHTTPHeaderFields = headers
        
        switch method {
        case .get:
            if isQueryString {
                urlRequest = try URLEncoding(destination: .queryString, arrayEncoding: .noBrackets).encode(urlRequest, with: queryParams)
                if params != nil, !params!.isEmpty {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params ?? [:], options: .prettyPrinted)
                }
            } else {
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: params)
            }
        case .patch,
             .put:
            if isQueryString {
                urlRequest = try URLEncoding(destination: .queryString, arrayEncoding: .noBrackets).encode(urlRequest, with: queryParams)
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params ?? [:], options: .prettyPrinted)
            } else {
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            }
            
        default:
            if isURLEncoded {
                if let encoding = encoding {
                    urlRequest = try encoding.encode(urlRequest, with: params)
                }
            } else {
                if isQueryString {
                    urlRequest = try URLEncoding(destination: .queryString, arrayEncoding: .noBrackets).encode(urlRequest, with: queryParams)
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params ?? [:], options: .prettyPrinted)
                } else {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params ?? [:], options: .prettyPrinted)
                }
            }
        }
        
        return urlRequest
    }
}
