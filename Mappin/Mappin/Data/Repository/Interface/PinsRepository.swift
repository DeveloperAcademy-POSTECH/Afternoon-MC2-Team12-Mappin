//
//  PinsRepository.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

protocol PinsRepository {
    func create(
        applemusicId: String,
        title: String,
        artistName: String,
        latitude: Float,
        longitude: Float,
        administrativeArea: String,
        locality: String,
        weather: String,
        temperture: Int
    ) async throws
    
    func readList(
        centerLatitude: Float,
        centerLongitude: Float,
        horizontalRadius: Float,
        verticalRadius: Float
    ) async throws -> [DTO.Pin]
    
    func readDetail(id: Int) async throws -> DTO.Pin
    func update(pin: DTO.Pin) async throws
    func delete(id: Int) async throws
}
