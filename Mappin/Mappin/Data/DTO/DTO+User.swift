//
//  DTO+User.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

extension DTO {
    struct User: Codable, Identifiable {
        let id: Int
        let username: String
        let is_staff: Bool
        let is_active: Bool
        let last_login: Date?
        let date_joined: Date
    }
}
