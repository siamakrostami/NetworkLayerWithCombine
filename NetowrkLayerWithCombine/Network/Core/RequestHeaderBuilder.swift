import Foundation
import UIKit

enum ConnectionHeaders: String{
    case
    keepAlive = "keep-alive",
    close = "close"
    var name: String{
        return "connection"
    }
}

enum AcceptHeaders: String{
    case
    all = "*/*",
    applicationJson = "application/json",
    applicationJsonUTF8 = "application/json; charset=utf-8",
    text = "text/plain",
    combinedAll = "application/json, text/plain, */*"
    var name: String {
        return "accept"
    }
}

enum ContentTypeHeaders: String{
    case
    applicationJson = "application/json",
    applicationJsonUTF8 = "application/json; charset=utf-8",
    urlEncoded = "application/x-www-form-urlencoded",
    formData = "multipart/form-data"
    var name: String {
        return "content-type"
    }
}

enum AcceptEncodingHeaders: String{
    case
    gzip = "gzip",
    compress = "compress",
    deflate = "deflate",
    br = "br",
    identity = "identity",
    all = "*"
    var name: String {
        return "accept-encoding"
    }
}

enum AcceptlanguageHeaders: String{
    case
    en = "en",
    fa = "fa",
    all = "*"
    var name: String {
        return "accept-language"
    }
}

enum AuthorizationHeaders: String{
    case
    Basic = "Basic",
    Bearer = "Bearer"
    var name: String {
        return "authorization"
    }
}

// MARK: - RequestHeaderBuilder

class RequestHeaderBuilder {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared = RequestHeaderBuilder()

    @discardableResult
    func addContentTypeHeader(type: ContentTypeHeaders) -> RequestHeaderBuilder {
        self.headers.updateValue(type.rawValue, forKey: type.name)
        return self
    }

    @discardableResult
    func addConnectionHeader(type: ConnectionHeaders) -> RequestHeaderBuilder {
        self.headers.updateValue(type.rawValue, forKey: type.name)
        return self
    }

    @discardableResult
    func addAcceptHeaders(type: AcceptHeaders) -> RequestHeaderBuilder {
        self.headers.updateValue(type.rawValue, forKey: type.name)
        return self
    }

    @discardableResult
    func addAcceptLanguageHeaders(type: AcceptlanguageHeaders) -> RequestHeaderBuilder {
        self.headers.updateValue(type.rawValue, forKey: type.name)
        return self
    }

    @discardableResult
    func addAcceptEncodingHeaders(type: AcceptEncodingHeaders) -> RequestHeaderBuilder {
        self.headers.updateValue(type.rawValue, forKey: type.name)
        return self
    }

    @discardableResult
    func addAuthorizationHeader(type: AuthorizationHeaders) -> RequestHeaderBuilder {
        let token = ""
        self.headers.updateValue("\(type.rawValue) \(token)", forKey: type.name)
        return self
    }

    @discardableResult
    func addCustomHeaders(headers: [String: String]) -> RequestHeaderBuilder {
        for (key, value) in headers {
            self.headers.updateValue(value, forKey: key)
        }
        return self
    }

    @discardableResult
    func addCustomHeader(name: String, value: String) -> RequestHeaderBuilder {
        self.headers.updateValue(value, forKey: name)
        return self
    }

    func build() -> [String: String] {
        return self.headers
    }

    // MARK: Private

    private var headers: [String: String] = .init()
}
