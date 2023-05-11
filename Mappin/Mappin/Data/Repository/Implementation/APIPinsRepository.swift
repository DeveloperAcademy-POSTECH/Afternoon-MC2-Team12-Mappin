//
//  APIPinsRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation
import Moya

struct APIPinsRepository: PinsRepository {
    private let provider = APIProvider()
    
    func create(
        music: Music,
        location: Location,
        weather: Weather
    ) async throws {
        let parameters = PinsCreateAPITarget.Parameters(
            music: .init(
                applemusic_id: music.id,
                title: music.title,
                artist_name: music.artist,
                artwork_url: music.artwork?.absoluteString ?? "",
                applemusic_url: music.appleMusicUrl?.absoluteString ?? ""
            ),
            latitude: location.latitude.decimalRounded(6),
            longitude: location.longitude.decimalRounded(6),
            locality: location.locality,
            sub_locality: location.subLocality,
            weather: weather.symbolName,
            temperature: Int(weather.temperature) ?? 0
        )
        let target = APITarget.createPin(parameters: parameters)
        try await provider.justRequest(target)
    }
    
    func readList(
        centerLatitude: Double,
        centerLongitude: Double,
        horizontalRadius: Double,
        verticalRadius: Double
    ) async throws -> [Pin] {
        let parameters = PinsReadListAPITarget.Parameters(
            center_latitude: centerLatitude,
            center_longitude: centerLongitude,
            horizontal_radius: horizontalRadius,
            vertical_radius: verticalRadius
        )
        let target = APITarget.readPins(parameters: parameters)
        let dtos = try await provider.requestResponsable(target)
        return dtos.map { $0.entity }
    }
    
    func readDetail(id: Int) async throws -> Pin {
        try await provider.requestResponsable(APITarget.readPin(id: id)).entity
    }
    
    func delete(id: Int) async throws {
        try await provider.justRequest(.deletePin(id: id))
    }
}
