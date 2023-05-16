//
//  Location.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

struct Location: Equatable {
    
    var latitude: Double // 위도
    var longitude: Double // 경도
    let locality: String // 포항시
    let subLocality: String // 죽도동
}

extension Location {
    static var empty = Location(latitude: 0.0, longitude: 0.0, locality: "", subLocality: "")
}
