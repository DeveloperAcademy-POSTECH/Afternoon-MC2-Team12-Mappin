//
//  APITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

class APITarget: TargetType {
    typealias Method = Moya.Method
    typealias Task = Moya.Task
    
    static var currentUser: CurrentUser?
    
    let path: String
    let method: Method
    
    init(path: String,
         method: Method) {
        self.path = path
        self.method = method
    }
    
    var task: Task {
        if let parameters = parameters, let encoding = encoding {
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    var baseURL: URL {
        URL(string: "http://localhost:8000")!
    }
    
    var headers: [String : String]? {
        var headers = [String: String]()
        headers.updateValue("application/json", forKey: "Content-Type")
        if let csrfToken = csrfToken {
            headers.updateValue(csrfToken, forKey: "X-CSRFToken")
        }
        if let authToken = Self.currentUser?.authToken {
            headers.updateValue("Token \(authToken)", forKey: "Authorization")
        }
        return headers
    }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var description: String {
        """
        endpoint: \(method.rawValue) \(baseURL.absoluteString)\(path)
        parameters: \(parameters ?? [:])
        headers: \(headers ?? [:])
        """
    }
    
    private var parameters: [String: Any]? {
        (self as? any ParametersRequestable)?.parameters.dictionary
    }
    
    private var encoding: ParameterEncoding? {
        guard let _ = parameters else {
            return nil
        }
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    private var csrfToken: String? {
        HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "csrftoken" })?.value
    }
}
