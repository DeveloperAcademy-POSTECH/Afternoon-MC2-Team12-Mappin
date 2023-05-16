//
//  DTO+PinCluster.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

extension DTO {
    struct PinCluster: Codable {
        let main_pin: DTO.Pin
        let pin_ids: [Int]
        let pins_count: Int
        let latitude: Double
        let longitude: Double
    }
}

extension DTO.PinCluster {
    var entity: PinCluster {
        PinCluster(
            mainPin: main_pin.entity,
            pinIds: pin_ids,
            pinsCount: pins_count,
            location: Location(
                latitude: latitude,
                longitude: longitude,
                locality: main_pin.locality,
                subLocality: main_pin.sub_locality
            )
        )
    }
}
