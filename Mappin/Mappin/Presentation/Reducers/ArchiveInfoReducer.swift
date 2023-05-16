//
//  ArchiveInfoReducer.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/16.
//

import UIKit

import ComposableArchitecture

struct ArchiveInfoReducer: ReducerProtocol {
    
    struct State: Equatable {
        let id: Int
    }
    
    enum Action {
        case removeArchive
        case openAppleMusic
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .removeArchive:
            return .none
        case .openAppleMusic:
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
