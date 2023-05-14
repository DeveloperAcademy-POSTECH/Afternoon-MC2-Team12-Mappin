//
//  UniqueAction.swift
//  Mappin
//
//  Created by byo on 2023/05/14.
//

import Foundation

struct UniqueAction<Action: Equatable>: Identifiable, Equatable {
    let id: UUID
    let wrapped: Action
    
    init(_ wrapped: Action) {
        self.id = UUID()
        self.wrapped = wrapped
    }
}
