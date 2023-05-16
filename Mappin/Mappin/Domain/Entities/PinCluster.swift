//
//  PinCluster.swift
//  Mappin
//
//  Created by byo on 2023/05/16.
//

import Foundation

struct PinCluster: Equatable, Identifiable {
    let mainPin: Pin
    let pinIds: [Int]
    let pinsCount: Int
    let location: Location
    
    var id: Int {
        mainPin.id
    }
}
