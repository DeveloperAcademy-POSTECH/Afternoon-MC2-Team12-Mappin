//
//  DTO+PinCluster.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

extension DTO {
    struct PinCluster: Codable {
        let main_pin: DTO.Pin
        let pins_count: Int
        let latitude: Double
        let longitude: Double
    }
}

extension DTO.PinCluster {
    var entity: Pin {
        Pin(
            id: main_pin.id,
            count: pins_count,
            music: Music(
                id: main_pin.music.applemusic_id,
                title: main_pin.music.title,
                artist: main_pin.music.artist_name,
                artwork: URL(string: main_pin.music.artwork_url),
                appleMusicUrl: URL(string: main_pin.music.applemusic_url)
            ),
            weather: Weather(
                id: UUID().uuidString,
                temperature: main_pin.temperature,
                symbolName: main_pin.weather
            ),
            createdAt: main_pin.created_at,
            location: Location(
                id: UUID().uuidString,
                latitude: latitude,
                longitude: longitude,
                locality: main_pin.locality,
                subLocality: main_pin.sub_locality
            )
        )
    }
}
