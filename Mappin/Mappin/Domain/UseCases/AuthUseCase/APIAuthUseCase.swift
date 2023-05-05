//
//  APIAuthUseCase.swift
//  Mappin
//
//  Created by byo on 2023/05/06.
//

import Foundation

struct APIAuthUseCase: AuthUseCase {
    private let currentUser: CurrentUser
    private let usersRepository: UsersRepository
    
    init(currentUser: CurrentUser,
         usersRepository: UsersRepository = APIUsersRepository()) {
        self.currentUser = currentUser
        self.usersRepository = usersRepository
    }
    
    func getAuthToken() async throws -> String {
        if currentUser.authToken == nil {
            await usersRepository.signup(
                username: currentUser.username,
                password: currentUser.password
            )
        }
        let token = try await usersRepository.login(
            username: currentUser.username,
            password: currentUser.password
        )
        return token
    }
}
