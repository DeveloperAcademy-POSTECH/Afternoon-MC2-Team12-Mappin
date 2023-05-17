//
//  Date+Format.swift
//  Mappin
//
//  Created by byo on 2023/05/15.
//

import Foundation

extension Date {
    private static let dateFormatter = DateFormatter()
    
    var dayAndTime: String {
        formatted(dateFormat: "h:mma · EEEE")
    }
    
    var yearAndMonth: String {
        formatted(dateFormat: "MMM d, yyyy")
    }
    
    var weekday: String {
        formatted(dateFormat: "EEEE")
    }
    
    var time: String {
        formatted(dateFormat: "h:mma")
    }
    
    var dialogFormat: String {
        formatted(dateFormat: "EEEE · MMM d, yyyy · h:mma")
    }
    
    private func formatted(dateFormat: String) -> String {
        Self.dateFormatter.dateFormat = dateFormat
        Self.dateFormatter.weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"].map { "\($0)요일" }
        return Self.dateFormatter.string(from: self)
    }
}
