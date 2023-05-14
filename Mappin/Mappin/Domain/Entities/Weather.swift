//
//  Weather.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/03.
//

import Foundation

struct Weather: Equatable, Identifiable {
    let id: String
    let temperature: Int
    let symbolName: String
}
