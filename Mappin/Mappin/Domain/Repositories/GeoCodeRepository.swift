//
//  GeoCodeRepository.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

protocol GeoCodeRepository {
    
    @discardableResult
    func requestGeoCode (
        latitude: Double,
        longitude: Double
    ) async throws -> Location
}
