//
//  RequestWeatherRepository.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/03.
//

import Foundation

protocol RequestWeatherRepository {
    func requestWeather(latitude: Double, longitude: Double) -> Weather
}
