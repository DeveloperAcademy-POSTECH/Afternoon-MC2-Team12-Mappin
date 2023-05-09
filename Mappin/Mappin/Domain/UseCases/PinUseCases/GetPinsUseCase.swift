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
    private let pinsRepository: PinsRepository
    
    init(locatationRepository: LocationRepository,
         pinsRepository: PinsRepository) {
        self.locatationRepository = locatationRepository
        self.pinsRepository = pinsRepository
    }
    
    func excuteUsingMap(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        let center: (Double, Double) = (locatationRepository.latitude, locatationRepository.longitude)
        return []
    }
    
    func excuteUsingList(latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        let center: (Double, Double) = (locatationRepository.latitude, locatationRepository.longitude)
        return []

    }
}

