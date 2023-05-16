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
        let locality: String
        let sub_locality: String
        let weather: String
        let temperature: Int
        let created_at: Date
    }
}

extension DTO.Pin {
    var entity: Pin {
        Pin(
            id: id,
            count: 0,
            music: Music(
                id: music.applemusic_id,
                title: music.title,
                artist: music.artist_name,
                artwork: URL(string: music.artwork_url),
                appleMusicUrl: URL(string: music.applemusic_url)
            ),
            weather: Weather(
                temperature: temperature,
                symbolName: weather
            ),
            createdAt: created_at,
            location: Location(
                latitude: latitude,
                longitude: longitude,
                locality: locality,
                subLocality: sub_locality
            )
        )
    }
}
