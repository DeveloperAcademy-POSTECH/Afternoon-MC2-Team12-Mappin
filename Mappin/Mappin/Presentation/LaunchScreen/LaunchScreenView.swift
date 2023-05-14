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
            ZStack {
                VStack {
                    Spacer()
                    Image("launchSubTitle")
                        .padding(.bottom, 20)
                    Image("launchTitle")
                        .padding(.bottom, 82)
                }
                Image("launchImage")
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
            .fullScreenCover(isPresented: viewStore.binding(
                get: \.isCompleted,
                send: { .setCompleted($0) }
            )) {
                PrimaryView(pinStore:
                                Store(
                                    initialState: PinMusicReducer.State(),
                                    reducer: PinMusicReducer(
                                        addPinUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(AddPinUseCase.self),
                                        getPinsUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(GetPinsUseCase.self)
                                    )._printChanges()
                                ),
                            musicStore:
                                Store(
                                    initialState: SearchMusicReducer.State(),
                                    reducer: SearchMusicReducer(
                                        searchMusicUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(SearchMusicUseCase.self),
                                        musicChartUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(MusicChartUseCase.self)
                                    )
                                )
                )
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
