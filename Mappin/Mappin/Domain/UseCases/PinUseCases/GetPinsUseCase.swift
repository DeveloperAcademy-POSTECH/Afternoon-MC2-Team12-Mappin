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
    
    func excuteUsingList(ids: [Int]) async throws -> [Pin]
    
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
        // TODO: BYO API
        return try await pinClustersRepository.readList(
            category: category,
            centerLatitude: center.0,
            centerLongitude: center.1,
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        ).map { $0.mainPin }
    }
    
    func excuteUsingMap(
        category: PinsCategory?,
        center: (Double, Double),
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin] {
        // TODO: BYO API
        try await pinClustersRepository.readList(
            category: category,
            centerLatitude: center.0,
            centerLongitude: center.1,
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        ).map { $0.mainPin }
    }
    
    func excuteUsingList(ids: [Int]) async throws -> [Pin] {
        try await pinsRepository.readList(ids: ids)
    }
    
    func getLatestPin(category: PinsCategory?) async throws -> Pin {
        try await pinsRepository.readLatest(category: category)
    }
}

