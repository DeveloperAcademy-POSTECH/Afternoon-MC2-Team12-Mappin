//
//  APIJSONDecoder.swift
//  Mappin
//
//  Created by byo on 2023/05/04.
//

import Foundation

final class APIJSONDecoder: JSONDecoder {
    private static let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    override init() {
        super.init()
        dateDecodingStrategy = .formatted(Self.dateFormatter)
    }
}
