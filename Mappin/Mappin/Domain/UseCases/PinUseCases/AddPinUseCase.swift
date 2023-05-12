//
//  PinUseCase.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

protocol AddPinUseCase {

    func excute(
        music: Music
    ) async throws
    
}

final class DefaultAddPinUseCase: AddPinUseCase {
    
    private let pinsRepository: PinsRepository
    private let locationRepository: LocationRepository
    private let geoCodeRepository: GeoCodeRepository
    private let weatherRepository: RequestWeatherRepositoryInterface
    private let deviceRepository: DeviceRepository
    
    init(pinsRepository: PinsRepository,
         geoCodeRepository: GeoCodeRepository,
         locationRepository: LocationRepository,
         weatherRepository: RequestWeatherRepositoryInterface,
         deviceRepository: DeviceRepository) {
        
        self.pinsRepository = pinsRepository
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
        self.deviceRepository = deviceRepository
        self.geoCodeRepository = geoCodeRepository
    }
    
    func excute(music: Music) async throws {
        let latitude = locationRepository.latitude
        print("@KIO 1")
        let longtitude = locationRepository.longitude
        print("@KIO 2")
        let geoCodeResult = try await geoCodeRepository.requestGeoCode(latitude: latitude, longitude: longtitude)
        print("@KIO 3")
        let weather = try await weatherRepository.requestWeather(latitude: latitude, longitude: longtitude)
        print("@KIO 4")
        let location = Location(id: UUID().uuidString,
                                latitude: latitude,
                                longitude: longtitude,
                                locality: geoCodeResult.locality,
                                subLocality: geoCodeResult.subLocality)
        
        try await pinsRepository.create(
            music: music,
            location: location,
            weather: weather
        )
    }
}



