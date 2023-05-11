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
    private let csrfTokenRepository: CSRFTokenRepository
    
    init(currentUser: CurrentUser,
         usersRepository: UsersRepository = APIUsersRepository(),
         csrfTokenRepository: CSRFTokenRepository = APICSRFTokenRepository()) {
        self.currentUser = currentUser
        self.usersRepository = usersRepository
        self.csrfTokenRepository = csrfTokenRepository
    }
    
    func getCSRFToken() async throws -> String {
        try await csrfTokenRepository.getCSRFToken()
    }
    
    func getAuthToken() async throws -> String {
        do {
            return try await getAuthTokenFromLogin()
        } catch {
            try await usersRepository.signup(
                username: currentUser.username,
                password: currentUser.password
            )
            return try await getAuthTokenFromLogin()
        }
    }
    
    private func getAuthTokenFromLogin() async throws -> String {
        try await usersRepository.login(
            username: currentUser.username,
            password: currentUser.password
        )
    }
}
