//
//  AddPinRepository.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

protocol AddPinRepository {
    
    @discardableResult
    func requestAddPin(
        deviceId: String,
        music: Music,
        location: Location,
        weather: Weather
    ) async throws
}

struct TempAddPinRepository: AddPinRepository {
    
    func requestAddPin(deviceId: String, music: Music, location: Location, weather: Weather) async throws {
        
    }
}
