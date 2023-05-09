//
//  LocationRepository.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import Foundation

protocol LocationRepository {
    var latitude: Double { get }
    var longitude: Double { get }
}
