//
//  GetPinsUseCase.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import Foundation

protocol GetPinsUseCase {
    func excuteUsingMap(
        category: PinsCategory?,
        center: (Double, Double),
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin]
    
    func excuteUsingMap(
        category: PinsCategory?,
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin]
    
    func excuteUsingList(
        category: PinsCategory?,
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin]
    
    func excuteUsingList(
        category: PinsCategory?,
        center: (Double, Double),
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin]
    
    func getLatestPin(category: PinsCategory?) async throws -> Pin
}

final class DefaultGetPinUseCase: GetPinsUseCase {
    
    private let locationRepository: LocationRepository
    private let pinsRepository: PinsRepository
    private let pinClustersRepository: PinClustersRepository
    
    init(locationRepository: LocationRepository,
         pinsRepository: PinsRepository,
         pinClustersRepository: PinClustersRepository) {
        self.locationRepository = locationRepository
        self.pinsRepository = pinsRepository
        self.pinClustersRepository = pinClustersRepository
    }
    
    func excuteUsingMap(
        category: PinsCategory?,
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin] {
        let center: (Double, Double) = (locationRepository.latitude, locationRepository.longitude)
        return try await pinClustersRepository.readList(
            category: category,
            centerLatitude: center.0,
            centerLongitude: center.1,
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
    }
    
    func excuteUsingList(
        category: PinsCategory?,
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin] {
        let center: (Double, Double) = (locationRepository.latitude, locationRepository.longitude)
        return try await pinsRepository.readList(
            category: category,
            centerLatitude: center.0,
            centerLongitude: center.1,
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
    }
    
    func excuteUsingMap(
        category: PinsCategory?,
        center: (Double, Double),
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin] {
        print("@KIO here haha")
        return try await pinClustersRepository.readList(
            category: category,
            centerLatitude: center.0,
            centerLongitude: center.1,
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
    }
    
    func excuteUsingList(
        category: PinsCategory?,
        center: (Double, Double),
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin] {
        return try await pinsRepository.readList(
            category: category,
            centerLatitude: center.0,
            centerLongitude: center.1,
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
    }
    
    func getLatestPin(category: PinsCategory?) async throws -> Pin {
        try await pinsRepository.readLatest(category: category)
    }
}

