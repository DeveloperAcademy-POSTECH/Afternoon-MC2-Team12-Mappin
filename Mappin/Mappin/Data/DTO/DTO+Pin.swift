//
//  DTO+Pin.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

extension DTO {
    struct Pin: Codable, Identifiable {
        let id: Int
        let music: DTO.Music
        let user_id: Int
        let latitude: Float
        let longitude: Float
        let created_at: Date
    }
}
