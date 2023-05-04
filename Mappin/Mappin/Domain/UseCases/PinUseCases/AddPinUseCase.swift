//
//  PinUseCase.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

protocol AddPinUseCase {
    
    @discardableResult
    func excute(
        deviceId: UUID,
        song: MockEntity,
        weather: MockEntity,
        location: Location,
        currentDate: Date
    ) async throws -> Pin
    
}

final class DefaultAddPinUseCase: AddPinUseCase {
    
    private let addPinRepository: AddPinRepository
    
    init(addPinRepository: AddPinRepository, geoCodeRepository: GeoCodeRepository) {
        self.addPinRepository = addPinRepository
    }
    
    func excute(deviceId: UUID,
                song: MockEntity,
                weather: MockEntity,
                location: Location,
                currentDate: Date) async throws -> Pin {
        
        
        let parameterValue: Pin = Pin(id: UUID().uuidString,
                                      count: 1,
                                      userName: deviceId.uuidString,
                                      song: song,
                                      weather: weather,
                                      createdAt: currentDate,
                                      location: location)
        
        return try await addPinRepository.requestAddPin(query: parameterValue)
    }
}



