//
//  PinUseCase.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

protocol AddPinUseCase {

    func excute(
        song: Music
    ) async throws
    
}

final class DefaultAddPinUseCase: AddPinUseCase {
    
    private let addPinRepository: AddPinRepository
    private let locationRepository: LocationRepository
    private let geoCodeRepository: GeoCodeRepository
    private let weatherRepository: RequestWeatherRepositoryInterface
    private let deviceRepository: DeviceRepository
    
    init(addPinRepository: AddPinRepository, geoCodeRepository: GeoCodeRepository) {
        self.addPinRepository = addPinRepository
    }
    
    func excute(song: Music) async throws {
        
        let deviceId = deviceRepository.deviceId
        let latitude = locationRepository.latitude
        let longitude = locationRepository.longitude
        let geocodeResult = try await geoCodeRepository.requestGeoCode(latitude: latitude, longitude: longitude)
        let weather = try await weatherRepository.requestWeather(latitude: latitude, longitude: longitude)
        
        
        
        
        return try await addPinRepository.requestAddPin(newPin: parameterValue)
    }
}



