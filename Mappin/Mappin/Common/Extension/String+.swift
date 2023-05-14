//
//  String+.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/08.
//

import Foundation

extension String {
    func resizeArtwork(size: Int) -> String {
        let size = String(format: "%.0fx%.0f", size, size)
        return replacingOccurrences(of: "99x99", with: size)
    }
    
    func getTemperature() -> Int {
        self
            .split(separator: ".")
            .compactMap{ Int($0) }
            .first!
    }
}
