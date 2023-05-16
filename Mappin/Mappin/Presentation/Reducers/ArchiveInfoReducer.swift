//
//  ArchiveInfoReducer.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/16.
//

import UIKit

import ComposableArchitecture

struct ArchiveInfoReducer: ReducerProtocol {
//    typealias MapReducer = PinMusicReducer
    
    let removePinUseCase: RemovePinUseCase
    
    struct State: Equatable {
        var id: Int = 0
        var pin: Pin?
        var isSomethingRemoved = false
    }
    
    enum Action {
        case removeArchive(Int)
        case openAppleMusic(URL)
        case pinRemoved
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        state.isSomethingRemoved = false
        switch action {
        case let .removeArchive(id):
            print("@Kozi \(id)")
            return .task {
                try await removePinUseCase.execute(id: id)
                return .pinRemoved
            }
        case .openAppleMusic(let url):
            openAppleMusic(url: url)
            return .none
        case .pinRemoved:
            state.isSomethingRemoved = true
            return .none
        }
    }
    
    func openAppleMusic(url: URL?) {
        guard let appleMusicUrl = url,
              UIApplication.shared.canOpenURL(appleMusicUrl)
        else {
            print("URL이 없는 음악이거나, URL을 열 수 없음.")
            return
        }
        UIApplication.shared.open(appleMusicUrl)
    }
}
