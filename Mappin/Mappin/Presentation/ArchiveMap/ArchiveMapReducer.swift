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
        var category: Category = .mine
        var isListViewPresented: Bool = false
    }
    
    enum Action {
        case viewAppeared
        case selectCategory(Category)
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

extension ArchiveMapReducer {
    enum Category: CaseIterable {
        case mine
        case others
        
        var navigationTitle: String {
            switch self {
            case .mine:
                return "내 핀만"
            case .others:
                return "다른 사람들 핀만"
            }
        }
        
        var buttonTitle: String {
            navigationTitle + " 보기"
        }
    }
}
