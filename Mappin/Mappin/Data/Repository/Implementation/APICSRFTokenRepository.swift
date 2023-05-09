//
//  APICSRFTokenRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/08.
//

import Foundation

struct APICSRFTokenRepository: CSRFTokenRepository {
    private let provider = APIProvider()
    
    func getCSRFToken() async throws -> String {
        let target = APITarget.getCSRFToken
        return try await provider.requestResponsable(target)
    }
}
