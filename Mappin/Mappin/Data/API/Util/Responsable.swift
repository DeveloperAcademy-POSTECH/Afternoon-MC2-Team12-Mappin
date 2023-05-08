//
//  Responsable.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

protocol Responsable: APITarget {
    associatedtype Response: Decodable
}
