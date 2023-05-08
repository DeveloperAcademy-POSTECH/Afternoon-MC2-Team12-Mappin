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
        let pins_count: Int
        let latitude: Float
        let longitude: Float
    }
}
