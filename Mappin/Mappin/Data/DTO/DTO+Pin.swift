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

extension DTO.Pin {
    var entity: Pin {
        Pin(
            id: String(id),
            count: 0,
            userName: "",
            music: Music(
                id: music.applemusic_id,
                title: music.title,
                artist: music.artist_name,
                artwork: nil,
                appleMusicUrl: nil
            ),
            weather: Weather(
                id: UUID().uuidString,
                temperature: String(temperature),
                symbolName: weather
            ),
            createdAt: created_at,
            location: Location(
                id: UUID().uuidString,
                latitude: latitude,
                longitude: longitude,
                locality: administrative_area,
                subLocality: locality
            )
        )
    }
}
