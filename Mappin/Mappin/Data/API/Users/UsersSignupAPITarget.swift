//
//  UsersSignupAPITarget.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

final class UsersSignupAPITarget: APITarget, ParametersRequestable, Responsable {
    typealias Parameters = AuthenticationParameters
    typealias Response = DTO.User
    
    let parameters: Parameters
    
    init(path: String,
         method: Method,
         parameters: Parameters) {
        self.parameters = parameters
        super.init(path: path, method: method)
    }
}
