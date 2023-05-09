//
//  PinsRangeParameters.swift
//  Mappin
//
//  Created by byo on 2023/05/09.
//

import Foundation

struct PinsRangeParameters: Encodable {
    let center_latitude: Float
    let center_longitude: Float
    let horizontal_radius: Float
    let vertical_radius: Float
}
