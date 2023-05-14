//
//  ArchiveMapReducer.swift
//  Mappin
//
//  Created by byo on 2023/05/11.
//

import Foundation
import ComposableArchitecture

class ArchiveMapReducer: ReducerProtocol {
    typealias MapReducer = PinMusicReducer
    typealias ListReducer = ArchiveMusicReducer
    
    struct State: Equatable {
        var category: PinsCategory = .mine
        var isListViewPresented: Bool = false
        
        var mapAction: MapReducer.Action?
        var listAction: ListReducer.Action?
    }
    
    enum Action: Equatable {
        case viewAppeared
        case selectCategory(PinsCategory)
        case setListViewPresented(Bool)
        
        case receiveMap(MapReducer.Action)
        case receiveList(ListReducer.Action)
        case sendMap(MapReducer.Action)
        case sendList(ListReducer.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewAppeared:
            return .none
            
        case let .selectCategory(category):
            state.category = category
            return .concatenate([
                .send(.sendMap(.setCategory(category))),
                .send(.sendList(.setCategory(category))),
            ])
            
        case let .setListViewPresented(presented):
            state.isListViewPresented = presented
            return .none
            
        case let .receiveMap(action):
            switch action {
            default:
                return .none
            }
            
        case let .receiveList(action):
            switch action {
            default:
                return .none
            }
            
        case let .sendMap(action):
            state.mapAction = action
            return .none
            
        case let .sendList(action):
            state.listAction = action
            return .none
        }
    }
}
