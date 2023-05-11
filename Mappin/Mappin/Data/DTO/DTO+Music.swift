//
//  DTO+Music.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

extension DTO {
    struct Music: Codable, Identifiable {
        let id: Int
        let applemusic_id: String
        let title: String
        let artist_name: String
        let artwork_url: String
        let applemusic_url: String
    }
}
