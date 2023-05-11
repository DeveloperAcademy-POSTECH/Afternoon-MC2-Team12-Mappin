//
//  GetPinsUseCase.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import Foundation

protocol GetPinsUseCase {
    
    func excuteUsingMap(center: (Double, Double), latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin]
    func excuteUsingMap(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin]
    func excuteUsingList(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin]
    func excuteUsingList(center: (Double, Double), latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin]
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
    
    func excuteUsingMap(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        let center: (Double, Double) = (locationRepository.latitude, locationRepository.longitude)
        return try await pinClustersRepository.readList(
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
    
    func excuteUsingMap(center: (Double, Double), latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        return try await pinsRepository.readList(
            centerLatitude: center.0,
            centerLongitude: center.1,
            horizontalRadius: latitudeDelta,
            verticalRadius: longitudeDelta
        )
    }
    
    func excuteUsingList(center: (Double, Double), latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        return try await pinsRepository.readList(
            centerLatitude: center.0,
            centerLongitude: center.1,
            horizontalRadius: latitudeDelta,
            verticalRadius: longitudeDelta
        )
    }
}

