//
//  ArchiveMusicReducer.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/11.
//

import Foundation

import ComposableArchitecture

struct ArchiveMusicReducer: ReducerProtocol {
    
    struct State: Equatable {
        var archiveMusic: [Music] = []
    }
    
    enum Action {
        
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
    }
}
