//
//  PinsRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

protocol PinsRepository {
    func create(
        music: Music,
        location: Location,
        weather: Weather
    ) async throws
    
    func readList(
        centerLatitude: Double,
        centerLongitude: Double,
        horizontalRadius: Double,
        verticalRadius: Double
    ) async throws -> [Pin]
    
    func readDetail(id: Int) async throws -> Pin
    func update(pin: DTO.Pin) async throws
    func delete(id: Int) async throws
}
