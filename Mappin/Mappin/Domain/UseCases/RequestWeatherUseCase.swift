//
//  RequestWeatherUscCase.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/03.
//

import Foundation

protocol RequestWeatherUseCase {
    func execute(latitude: Double,
                 longitude: Double) async throws -> Weather
}

final class DefaultRequestWeatherUseCase: RequestWeatherUseCase {
    
    private let weatherRepository: RequestWeatherRepositoryInterface
    
    init(weatherRepository: RequestWeatherRepositoryInterface) {
        self.weatherRepository = weatherRepository
    }
    
    func execute(latitude: Double,
                 longitude: Double) async throws -> Weather {
        return weatherRepository.requestWeather(latitude: latitude,
                                                longitude: longitude)
    }
    
}
