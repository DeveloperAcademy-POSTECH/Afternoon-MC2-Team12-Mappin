//
//  SearchMusicReducer.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/05.
//

import Foundation

import ComposableArchitecture

struct MusicReducer: ReducerProtocol {
    
    let searchMusicUseCase: SearchMusicUseCase
    let musicChartUseCase: MusicChartUseCase
    
    struct State {
        var searchTerm: String = ""
        var music: [Music]
    }
    
    enum Action {
        case searchTermChanged(searchTerm: String)
        case requestMusicChart
        case applyMusic([Music])
        case resetMusic
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
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
            return .publisher {

            }
        case .resetMusic:
            state.music = []
            return .none
        }
    }
    
}
