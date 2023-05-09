//
//  LaunchScreenReducer.swift
//  Mappin
//
//  Created by byo on 2023/05/08.
//

import Foundation
import Combine
import ComposableArchitecture

struct LaunchScreenReducer: ReducerProtocol {
    let authUseCase: AuthUseCase
    let currentUser: CurrentUser
    
    struct State: Equatable {
        var isCompleted: Bool = false
    }
    
    enum Action: Equatable {
        case viewAppeared
        case setCompleted(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewAppeared:
            return .publisher {
                getLaunchingPublisher()
            }
        case let .setCompleted(isCompleted):
            state.isCompleted = isCompleted
            return .none
        }
    }
    
    private func getLaunchingPublisher() -> AnyPublisher<Action, Never> {
        Publishers
            .Merge(
                getTokenApplyingPublisher(),
                getDelayPublisher()
            )
            .receive(on: DispatchQueue.main)
            .map { Action.setCompleted(true) }
            .catch { _ -> Just<Action> in
                Just(.setCompleted(false))
            }
            .eraseToAnyPublisher()
    }
    
    private func getTokenApplyingPublisher() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            Task {
                do {
                    try await applyCSRFToken()
                    try await applyAuthToken()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getDelayPublisher() -> AnyPublisher<Void, Error> {
        Just(())
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
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
