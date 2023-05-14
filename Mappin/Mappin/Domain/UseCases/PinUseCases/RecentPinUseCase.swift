//
//  RecentPinUseCase.swift
//  Mappin
//
//  Created by byo on 2023/05/14.
//

import Foundation

protocol RecentPinUseCase {
    func getRecentPin(category: PinsCategory?) async throws -> Pin
}

class MockRecentPinUseCase: RecentPinUseCase {
    func getRecentPin(category: PinsCategory?) async throws -> Pin {
        .empty
    }
}
