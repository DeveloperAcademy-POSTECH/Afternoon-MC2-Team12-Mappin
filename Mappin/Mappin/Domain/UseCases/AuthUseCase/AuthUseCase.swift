//
//  AuthUseCase.swift
//  Mappin
//
//  Created by byo on 2023/05/06.
//

import Foundation

protocol AuthUseCase {
    func getAuthToken() async throws -> String
    func getCSRFToken() async throws -> String
}
