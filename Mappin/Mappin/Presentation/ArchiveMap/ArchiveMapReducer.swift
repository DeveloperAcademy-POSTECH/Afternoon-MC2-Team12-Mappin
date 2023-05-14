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
    
    private static let emptyListHeight: CGFloat = 200
    private static let maxListHeight: CGFloat = 540
    
    struct State: Equatable {
        var category: PinsCategory?
        var isListViewPresented: Bool = false
        var estimatedListHeight: CGFloat = emptyListHeight
        
        var mapAction: MapReducer.Action?
        var listAction: ListReducer.Action?
    }
    
    enum Action: Equatable {
        case selectCategory(PinsCategory)
        case setListViewPresented(Bool)
        case setEstimatedListHeight(CGFloat)
        
        case receiveMap(MapReducer.Action)
        case receiveList(ListReducer.Action)
        case sendMap(MapReducer.Action)
        case sendList(ListReducer.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .selectCategory(category):
            state.category = category
            return .concatenate([
                .send(.sendMap(.setCategory(category))),
                .send(.sendList(.setCategory(category)))
            ])
            
        case let .setListViewPresented(presented):
            state.isListViewPresented = presented
            return .none
            
        case let .setEstimatedListHeight(height):
            state.estimatedListHeight = height
            return .none
            
        case let .receiveMap(action):
            switch action {
            case let .listPins(pins):
                return .send(.sendList(.applyArchive(pins)))
            default:
                return .none
            }
            
        case let .receiveList(action):
            switch action {
            case let .applyArchive(pins):
                let height = Self.getEstimatedListHeight(pins.count)
                print("@BYO height \(height)")
                return .send(.setEstimatedListHeight(height))
            case let .archiveCellTapped(id):
                return .send(.sendMap(.focusPin(id: id)))
            case .pinRemoved:
                return .send(.sendMap(.refreshPins))
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
    
    private static func getEstimatedListHeight(_ count: Int) -> CGFloat {
        guard count > 0 else {
            return emptyListHeight
        }
        return min(CGFloat(100 + count * 110), maxListHeight)
    }
}
