//
//  APITarget+Interface.swift
//  Mappin
//
//  Created by byo on 2023/05/05.
//

import Foundation

protocol ParametersRequestable: APITarget {
    associatedtype Parameters: Encodable
    var parameters: Parameters { get }
}
