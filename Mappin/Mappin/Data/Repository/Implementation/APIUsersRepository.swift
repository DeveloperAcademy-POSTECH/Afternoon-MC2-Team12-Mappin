//
//  APIUsersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation
import Moya

struct APIUsersRepository: UsersRepository {
    private typealias Parameters = API.Users.Parameters
    private let provider = MoyaProvider<API.Users>()
    private let decoder = APIJSONDecoder()
    
    func signup(username: String, password: String) async throws -> DTO.User {
        let parameters = Parameters(username: username, password: password)
        let result = await provider.request(.signup(parameters: parameters))
        let data = try result.get().data
        return try decoder.decode(DTO.User.self, from: data)
    }
    
    func login(username: String, password: String) async throws -> String {
        struct Response: Decodable {
            let token: String
        }
        let parameters = Parameters(username: username, password: password)
        let result = await provider.request(.login(parameters: parameters))
        let data = try result.get().data
        let response = try decoder.decode(Response.self, from: data)
        return response.token
    }
}
