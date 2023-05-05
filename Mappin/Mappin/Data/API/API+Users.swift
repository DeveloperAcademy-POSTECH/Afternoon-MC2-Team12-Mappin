//
//  API+Users.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation
import Moya

extension API {
    enum Users: TargetType {
        struct Parameters: Encodable {
            let username: String
            let password: String
        }
        
        case signup(parameters: Parameters)
        case login(parameters: Parameters)
        
        var path: String {
            let basePath = "/users"
            switch self {
            case .signup:
                return basePath + "/signup"
            case .login:
                return basePath + "/login"
            }
        }
        
        var method: Method {
            .post
        }
        
        var task: Task {
            switch self {
            case let .signup(parameters), let .login(parameters):
                guard let parameters = parameters.dictionary else {
                    return .requestPlain
                }
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            }
        }
    }
}
