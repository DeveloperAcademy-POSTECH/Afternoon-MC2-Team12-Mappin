//
//  APIUsersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation
import Moya

struct APIUsersRepository: UsersRepository {
    private let provider = APIProvider()
    private let decoder = APIJSONDecoder()
    
    func signup(username: String, password: String) async throws -> DTO.User {
        let parameters = UsersSignupAPITarget.Parameters(username: username, password: password)
        let result = await provider.request(.signupUser(parameters: parameters))
        let data = try result.get().data
        return try decoder.decode(DTO.User.self, from: data)
    }
    
    func login(username: String, password: String) async throws -> String {
        struct Response: Decodable {
            let token: String
        }
        let parameters = UsersLoginAPITarget.Parameters(username: username, password: password)
        let result = await provider.request(.loginUser(parameters: parameters))
        let data = try result.get().data
        let response = try decoder.decode(Response.self, from: data)
        return response.token
    }
}
