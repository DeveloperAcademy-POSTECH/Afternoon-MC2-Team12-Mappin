//
//  GeoCodeUseCase.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

protocol GeoCodeUseCase {
    
    @discardableResult
    func excute(
        latitude: Double,
        longitude: Double
    ) async throws -> Location
}

final class DefaultGeoCodeUseCase: GeoCodeUseCase {
    
    private let geoCodeRepository: GeoCodeRepository
 
    init(geoCodeRepository: GeoCodeRepository) {
        self.geoCodeRepository = geoCodeRepository
    }
    
    func excute(latitude: Double, longitude: Double) async throws -> Location {
        try await geoCodeRepository.requestGeoCode(latitude: latitude, longitude: longitude)
    }
    
}
