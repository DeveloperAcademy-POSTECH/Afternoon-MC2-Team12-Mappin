//
//  CSRFTokenRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/08.
//

import Foundation

protocol CSRFTokenRepository {
    func getCSRFToken() async throws -> String
}
