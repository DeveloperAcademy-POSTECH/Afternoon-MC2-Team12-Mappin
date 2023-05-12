//
//  LaunchScreenView.swift
//  Mappin
//
//  Created by byo on 2023/05/08.
//

import SwiftUI
import ComposableArchitecture
import MusicKit

struct LaunchScreenView: View {
    let store: StoreOf<LaunchScreenReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            // TODO: add logo
            Text("Launch Screen")
                .onAppear {
                    viewStore.send(.viewAppeared)
                    Task {
                        Task {
                            _ = await MusicAuthorization.request()
                        }
                        print("---------------------------------")
                        let musicSearchUseCase = DefaultSearchMusicUseCase(musicRepository: RequestMusicRepository()) //SearchMusicUseCase = DefaultMockDIContainer.shared.container.resolver.resolve(SearchMusicUseCase.self)
                        let list = try await musicSearchUseCase.execute(searchTerm: "뿌리").map { $0.title }
                        print(list.count)
                    }
                }
                .fullScreenCover(isPresented: viewStore.binding(
                    get: \.isCompleted,
                    send: { .setCompleted($0) }
                )) {
                    PrimaryView()
                }
        }
    }
}

extension LaunchScreenView {
    static func build() -> Self {
        let currentUser: CurrentUser = DefaultCurrentUser.shared
        let authUseCase: AuthUseCase = APIAuthUseCase(currentUser: currentUser)
        let toastManager: ToastManagerProtocol = ToastManager.shared
        let reducer = LaunchScreenReducer(authUseCase: authUseCase, currentUser: currentUser, toastManager: toastManager)
        let store = Store(initialState: LaunchScreenReducer.State(), reducer: reducer)
        
        // TODO: 수정 필요
        APITarget.currentUser = currentUser
        
        return LaunchScreenView(store: store)
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView.build()
    }
}
