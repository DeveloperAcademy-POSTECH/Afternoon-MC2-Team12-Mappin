//
//  APIError.swift
//  Mappin
//
//  Created by byo on 2023/05/06.
//

import Foundation

struct APIError: Error, Decodable {
    let detail: String
}

extension APIError {
    static let unknown = APIError(detail: "unknown error")
}
