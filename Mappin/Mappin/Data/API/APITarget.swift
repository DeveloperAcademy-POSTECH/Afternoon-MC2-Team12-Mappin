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
    
    let path: String
    let method: Method
    
    init(path: String, method: Method) {
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
        // TODO: environment
        return URL(string: "http://test.eba-abpsggka.ap-northeast-2.elasticbeanstalk.com")!
    }
    
    var headers: [String : String]? {
        var headers = [String: String]()
        headers.updateValue("application/json", forKey: "Content-Type")
        return headers
    }
    
    var validationType: ValidationType {
        .successCodes
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
}
