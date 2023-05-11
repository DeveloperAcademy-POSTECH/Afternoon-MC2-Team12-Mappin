//
//  Pin.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation
import CoreLocation

struct Pin: Equatable, Identifiable {
    
    static let empty = Pin(id: "", count:  1, userName: "", music: Music(id: "", title: "", artist: "", artwork: nil, appleMusicUrl: nil), weather: Weather(id: "", temperature: "", symbolName: ""), createdAt: Date(), location: Location(id: "", latitude: 0, longitude: 0, locality: "", subLocality: ""))
    
    
    let id: String
    let count: Int
    let userName: String // if sing pin, this property is always 1, this pin was Clustered pin
    let music: Music // Song?
    let weather: Weather // Weather?
    let createdAt: Date
    var location: Location
}

