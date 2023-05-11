//
//  ArchiveMapReducer.swift
//  Mappin
//
//  Created by byo on 2023/05/11.
//

import Foundation
import ComposableArchitecture

struct ArchiveMapReducer: ReducerProtocol {
    struct State: Equatable {
        var category: PinsCategory = .mine
        var isListViewPresented: Bool = false
    }
    
    enum Action {
        case viewAppeared
        case selectCategory(PinsCategory)
        case setListViewPresented(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewAppeared:
            return .none
        case let .selectCategory(category):
            state.category = category
            return .none
        case let .setListViewPresented(presented):
            state.isListViewPresented = presented
            return .none
        }
    }
}
