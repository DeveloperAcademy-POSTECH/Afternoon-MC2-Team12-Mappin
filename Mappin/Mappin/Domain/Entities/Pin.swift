//
//  Pin.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import Foundation

struct Pin: Equatable, Identifiable {
    
    let id: String
    let count: Int
    let userName: String? // if sing pin, this property is always 1, this pin was Clustered pin
    let song: MockEntity? // Song?
    let weather: MockEntity? // Weather?
    let createdAt: Date?
    let location: Location?
    
}

