//
//  BinaryFloatingPoint+.swift
//  Mappin
//
//  Created by byo on 2023/05/09.
//

import Foundation

extension BinaryFloatingPoint {
    func decimalRounded(_ decimalPoint: Int) -> Self {
        let factor = Self(pow(Double(10), Double(decimalPoint)))
        return (self * factor).rounded() / factor
    }
}
