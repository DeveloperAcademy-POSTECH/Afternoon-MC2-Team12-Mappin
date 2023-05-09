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
    
    func create(pin: DTO.Pin) async throws {
        try await provider.justRequest(.createPin(parameters: pin))
    }
    
    func readList(centerLatitude: Float, centerLongitude: Float, horizontalRadius: Float, verticalRadius: Float) async throws -> [DTO.Pin] {
        let parameters = PinClustersListAPITarget.Parameters(
            center_latitude: centerLatitude,
            center_longitude: centerLongitude,
            horizontal_radius: horizontalRadius,
            vertical_radius: verticalRadius
        )
        let target = APITarget.readPins(parameters: parameters)
        return try await provider.requestResponsable(target)
    }
    
    func readDetail(id: Int) async throws -> DTO.Pin {
        try await provider.requestResponsable(APITarget.readPin(id: id))
    }
    
    func update(pin: DTO.Pin) async throws {
j        try await provider.justRequest(.updatePin(parameters: pin))
    }
    
    func delete(id: Int) async throws {
        try await provider.justRequest(.deletePin(id: id))
    }
}
