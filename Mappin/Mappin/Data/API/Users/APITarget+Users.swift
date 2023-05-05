//
//  APITarget+Users.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

extension APITarget {
    private static let basePath = "/users"
    
    static func signupUser(parameters: UsersSignupAPITarget.Parameters) -> APITarget {
        UsersSignupAPITarget(
            path: basePath + "/signup",
            method: .post,
            parameters: parameters
        )
    }
    
    static func loginUser(parameters: UsersSignupAPITarget.Parameters) -> APITarget {
        UsersSignupAPITarget(
            path: basePath + "/login",
            method: .post,
            parameters: parameters
        )
    }
}
