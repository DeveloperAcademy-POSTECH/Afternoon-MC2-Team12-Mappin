//
//  PinCluster.swift
//  Mappin
//
//  Created by byo on 2023/05/16.
//

import Foundation

struct PinCluster: Equatable, Identifiable {
    var mainPin: Pin
    var pinIds: [Int]
    var pinsCount: Int
    var location: Location
    
    var id: Int {
        mainPin.id
    }
}

extension PinCluster {
    static var empty = PinCluster(mainPin: Pin.empty, pinIds: [], pinsCount: 0, location: Location.empty)
}
