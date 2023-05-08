//
//  UsersRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

protocol UsersRepository {
    func signup(username: String, password: String) async throws
    func login(username: String, password: String) async throws -> String
}
