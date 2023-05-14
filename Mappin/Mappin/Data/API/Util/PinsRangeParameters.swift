//
//  PinsRangeParameters.swift
//  Mappin
//
//  Created by byo on 2023/05/09.
//

import Foundation

struct PinsRangeParameters: Encodable {
    let category: String?
    let center_latitude: Double
    let center_longitude: Double
    let horizontal_radius: Double
    let vertical_radius: Double
}
