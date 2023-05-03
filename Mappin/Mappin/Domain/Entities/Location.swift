//
//  Location.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

struct Location: Identifiable, Equatable {
    
    let id: String
    let latitude: Double // 위도
    let longitude: Double // 경도
    let administrativeArea: String // 포항시
    let locality: String // 죽도동
}
