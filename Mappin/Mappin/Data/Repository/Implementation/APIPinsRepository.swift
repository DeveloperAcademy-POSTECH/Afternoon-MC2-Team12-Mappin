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
    ) async throws -> Pin {
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
            temperature: weather.temperature
        )
        let target = APITarget.createPin(parameters: parameters)
        return try await provider.requestResponsable(target).entity
    }
    
    func readList(ids: [Int]) async throws -> [Pin] {
        let serializedIds = ids.map { String($0) }.joined(separator: ",")
        let parameters = PinsReadListAPITarget.Parameters(ids: serializedIds)
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
    
    func readLatest(category: PinsCategory?) async throws -> Pin {
        let parameters = PinsLatestAPITarget.Parameters(category: category?.rawValue)
        return try await provider.requestResponsable(APITarget.readLatestPin(parameters: parameters)).entity
    }
}
