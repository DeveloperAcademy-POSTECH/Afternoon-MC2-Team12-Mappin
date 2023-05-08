//
//  LaunchScreenReducer.swift
//  Mappin
//
//  Created by byo on 2023/05/08.
//

import Foundation
import ComposableArchitecture

struct LaunchScreenReducer: ReducerProtocol {
    let authUseCase: AuthUseCase
    let currentUser: CurrentUser
    
    struct State: Equatable {
        var isLoading: Bool = true
    }
    
    enum Action {
        case viewAppeared
        case setLoading(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewAppeared:
            return .task {
                try await applyCSRFToken()
                try await applyAuthToken()
                return .setLoading(false)
            }
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return .none
        }
    }
    
    private func applyCSRFToken() async throws {
        let token = try await authUseCase.getCSRFToken()
        currentUser.csrfToken = token
    }
    
    private func applyAuthToken() async throws {
        let token = try await authUseCase.getAuthToken()
        currentUser.authToken = token
    }
}
