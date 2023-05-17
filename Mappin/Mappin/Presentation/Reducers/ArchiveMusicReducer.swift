//
//  ArchiveMusicReducer.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/11.
//

import Foundation

import ComposableArchitecture

struct ArchiveMusicReducer: ReducerProtocol {
    
    let removePinUseCase: RemovePinUseCase
    
    struct State: Equatable  {
        var archiveMusic: [Pin] = []
        var archiveIsEmpty = false
        
        var category: PinsCategory?
        var lastAction: UniqueAction<Action>?
    }
    
    enum Action: Equatable {
        case applyArchive([Pin])
        case pinTapped(Pin)
        case removeArchive(indexSet: IndexSet)
        case pinRemoved(Int)
        case setCategory(PinsCategory)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        state.lastAction = .init(action)
        
        switch action {
        case .applyArchive(let archiveMusic):
            // 서버에서 받아온 Pin 정보 저장
            state.archiveMusic = archiveMusic
            return .none
            
        case let .removeArchive(indexSet):
            guard let index = indexSet.first else {
                return .none
            }
            
            let pin = state.archiveMusic.remove(at: index)
            return .task {
                try await removePinUseCase.execute(id: pin.id)
                return .pinRemoved(pin.id)
            }
            
        case let .setCategory(category):
            state.category = category
            return .none
            
        default:
            return .none
        }
    }
    
}


extension ArchiveMusicReducer {
    static func build() -> Self {
        ArchiveMusicReducer(
            removePinUseCase: DefaultRemovePinUseCase(pinsRepository: APIPinsRepository())
        )
    }
}
