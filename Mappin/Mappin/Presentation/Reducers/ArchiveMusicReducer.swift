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
        var archiveMusic: PinCluster = PinCluster.empty
        var archiveIsEmpty = false
        
        var category: PinsCategory?
        var lastAction: UniqueAction<Action>?
    }
    
    enum Action: Equatable {
        case applyArchive(PinCluster)
        case pinTapped(PinCluster)
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
            
            let pinID = state.archiveMusic.pinIds.remove(at: index)
            return .task {
                try await removePinUseCase.execute(id: pinID)
                return .pinRemoved(pinID)
            }
            
        case let .setCategory(category):
            state.category = category
            return .none
            
        default:
            return .none
        }
    }
    
}

struct TempArchive: Identifiable, Equatable {
    var id: Int
    var music: Music
    var date: String = "Apr 11, 2023 ・ 6:03PM ・ 화요일"
}

//TempArchive(id: 1, music: Music(id: UUID().uuidString, title: "messi1", artist: "ronaldo", artwork: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/cf/79/94/cf7994ea-4fe5-9d8f-72a2-9725fc4b2c3a/19UMGIM16534.rgb.jpg/200x200bb.jpg"), appleMusicUrl: nil)),
//                     TempArchive(id: 2, music: Music(id: UUID().uuidString, title: "messi2", artist: "ronaldo", artwork: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/cf/79/94/cf7994ea-4fe5-9d8f-72a2-9725fc4b2c3a/19UMGIM16534.rgb.jpg/200x200bb.jpg"), appleMusicUrl: nil)),
//                                     TempArchive(id: 3, music: Music(id: UUID().uuidString, title: "messi3", artist: "ronaldo", artwork: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/cf/79/94/cf7994ea-4fe5-9d8f-72a2-9725fc4b2c3a/19UMGIM16534.rgb.jpg/200x200bb.jpg"), appleMusicUrl: nil)),
//                                     TempArchive(id: 4, music: Music(id: UUID().uuidString, title: "messi4", artist: "ronaldo", artwork: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/cf/79/94/cf7994ea-4fe5-9d8f-72a2-9725fc4b2c3a/19UMGIM16534.rgb.jpg/200x200bb.jpg"), appleMusicUrl: nil)),
//                                     TempArchive(id: 5, music: Music(id: UUID().uuidString, title: "messi5", artist: "ronaldo", artwork: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/cf/79/94/cf7994ea-4fe5-9d8f-72a2-9725fc4b2c3a/19UMGIM16534.rgb.jpg/200x200bb.jpg"), appleMusicUrl: nil))])

extension ArchiveMusicReducer {
    static func build() -> Self {
        ArchiveMusicReducer(
            removePinUseCase: DefaultRemovePinUseCase(pinsRepository: APIPinsRepository())
        )
    }
}
