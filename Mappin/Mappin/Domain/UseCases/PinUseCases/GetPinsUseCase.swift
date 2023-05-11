//
//  GetPinsUseCase.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import Foundation

protocol GetPinsUseCase {
    
    func excuteUsingMap(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin]
    func excuteUsingList(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin]
}

final class DefaultGetPinUseCase: GetPinsUseCase {
    
    private let locationRepository: LocationRepository
    private let pinsRepository: PinsRepository
    
    init(locationRepository: LocationRepository,
         pinsRepository: PinsRepository) {
        self.locationRepository = locationRepository
        self.pinsRepository = pinsRepository
    }
    
    func excuteUsingMap(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        let center: (Double, Double) = (locationRepository.latitude, locationRepository.longitude)
        return try await pinsRepository.readList(
            centerLatitude: center.0,
            centerLongitude: center.1,
            horizontalRadius: latitudeDelta,
            verticalRadius: longitudeDelta
        )
    }
    
    func excuteUsingList(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        let center: (Double, Double) = (locationRepository.latitude, locationRepository.longitude)
        return try await pinsRepository.readList(
            centerLatitude: center.0,
            centerLongitude: center.1,
            horizontalRadius: latitudeDelta,
            verticalRadius: longitudeDelta
        )
    }
}

