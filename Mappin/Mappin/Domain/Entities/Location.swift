//
//  Location.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

struct Location: Identifiable, Equatable {
    
    let id: String
    var latitude: Double // 위도
    var longitude: Double // 경도
    let locality: String // 포항시
    let subLocality: String // 죽도동
}
