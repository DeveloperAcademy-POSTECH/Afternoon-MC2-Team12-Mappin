//
//  LaunchScreenView.swift
//  Mappin
//
//  Created by byo on 2023/05/08.
//

import SwiftUI
import ComposableArchitecture

struct LaunchScreenView: View {
    let store: StoreOf<LaunchScreenReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Launch Screen")
                .onAppear {
                    viewStore.send(.viewAppeared)
                }
        }
    }
}

extension LaunchScreenView {
    static func build() -> Self {
        let currentUser: CurrentUser = MockCurrentUser()
        let authUseCase: AuthUseCase = APIAuthUseCase(currentUser: currentUser)
        let reducer = LaunchScreenReducer(authUseCase: authUseCase, currentUser: currentUser)
        let store = Store(initialState: LaunchScreenReducer.State(), reducer: reducer)
        return LaunchScreenView(store: store)
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView.build()
    }
}
