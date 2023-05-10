//
//  GetPinsRepository.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import Foundation

protocol GetPinsRepository {
    
    func GetPinsUsingMap(
        center: (latitude: Double, longitude: Double),
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin]
    
    func GetPinsUsingList(
        center: (latitude: Double, longitude: Double),
        latitudeDelta: Double,
        longitudeDelta: Double
    ) async throws -> [Pin]
}

struct TempImplementaitionOfGetPinsRepository: GetPinsRepository {
    func GetPinsUsingMap(center: (latitude: Double, longitude: Double), latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        return []
    }
    
    func GetPinsUsingList(center: (latitude: Double, longitude: Double), latitudeDelta: Double, longitudeDelta: Double) async throws -> [Pin] {
        return []
    }
    
    
}
