//
//  RequestWeatherRepository.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/04.
//

import Foundation

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
        do {
            let responseWeather = try await weatherService.weather(for: location)
            let temperature = String(describing: responseWeather.currentWeather.temperature)
            return Weather(id: UUID().uuidString,
                           temperature: temperature.getTemperature(),
                           symbolName: responseWeather.currentWeather.symbolName)
        }
        catch {
            print("@Error \(error)")
            return Weather(id: "", temperature: "3", symbolName: "2")
        }

    }

}
