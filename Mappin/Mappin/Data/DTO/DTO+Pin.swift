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
        let latitude: Double
        let longitude: Double
        let administrative_area: String
        let locality: String
        let weather: String
        let temperature: Int
        let created_at: Date
    }
}
