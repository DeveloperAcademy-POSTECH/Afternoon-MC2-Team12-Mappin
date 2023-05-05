//
//  UsersLoginAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

final class UsersLoginAPITarget: APITarget, ParametersRequestable, Responsable {
    typealias Parameters = AuthenticationParameters
    
    struct Response: Decodable {
        let token: String
    }
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
