//
//  SearchMusicReducer.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/05.
//

import UIKit

import ComposableArchitecture
import Combine

struct MusicReducer: ReducerProtocol {
    
    let searchMusicUseCase = DefaultSearchMusicUseCase(musicRepository: RequestMusicRepository())
    let musicChartUseCase = DefaultMusicChartUseCase(musicRepository: RequestMusicRepository())
//    let searchMusicUseCase: SearchMusicUseCase
//    let musicChartUseCase: MusicChartUseCase
    
    struct State: Equatable {
        var searchTerm: String = ""
        var music: [Music] = []
    }
    
    enum Action {
        case resetSearchTerm
        case searchTermChanged(searchTerm: String)
        case requestMusicChart
        case applyMusic([Music])
        case resetMusic
        case openAppleMusic(url: URL?)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .resetSearchTerm:
            state.searchTerm = ""
            return .none
        case .searchTermChanged(let searchTerm):
            state.searchTerm = searchTerm
            return .task {
                return .applyMusic(try await searchMusicUseCase.execute(searchTerm: searchTerm))
            } catch: { error in
                print(error)
                return .resetMusic
            }
        case .requestMusicChart:
            return .task {
                return .applyMusic(try await musicChartUseCase.execute())
            } catch: { error in
                print(error)
                return .resetMusic
            }
        case .applyMusic(let music):
            state.music = music
            return .none
        case .resetMusic:
            state.music = []
            return .none
        case .openAppleMusic(let url):
            openAppleMusic(url: url)
            return .none
        }
    }
    
}

extension MusicReducer {
    /// 유저가 애플 뮤직에서 음악을 재생할 수 있도록 이동합니다.
    /// return: void
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
