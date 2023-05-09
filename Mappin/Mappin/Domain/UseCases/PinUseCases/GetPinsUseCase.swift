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
    
    private let locatationRepository: LocationRepository
    private let getPinsRepository: GetPinsRepository
    
    init(locatationRepository: LocationRepository, getPinsRepository: GetPinsRepository) {
        self.locatationRepository = locatationRepository
        self.getPinsRepository = getPinsRepository
    }
    
    func excuteUsingMap(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        let center: (Double, Double) = (locatationRepository.latitude, locatationRepository.longitude)
        
        return try await getPinsRepository.GetPinsUsingMap(center: center, latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    func excuteUsingList(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        let center: (Double, Double) = (locatationRepository.latitude, locatationRepository.longitude)
        
        return try await getPinsRepository.GetPinsUsingList(center: center, latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)

    }
}

