//
//  RequestWeatherRepository.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/04.
//

import SwiftUI

import WeatherKit
import CoreLocation

final class RequestWeatherRepository: RequestWeatherRepositoryInterface {
    
    let weatherService = WeatherService()
    
    func requestWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> Weather {
        let location = CLLocation(latitude: latitude,
                                  longitude: longitude)
        
        let responseWeather = try await weatherService.weather(for: location)
        let temperature = String(describing: responseWeather.currentWeather.temperature)
            .split(separator: ".")
            .compactMap { Int($0) }
            .first!
        return Weather(id: UUID().uuidString,
                       temperature: String(describing: temperature),
                       symbolName: responseWeather.currentWeather.symbolName)
    }
    
}
