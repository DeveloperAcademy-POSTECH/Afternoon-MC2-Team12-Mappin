//
//  MappinApp.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import SwiftUI
import ComposableArchitecture
import MapKit


@main
struct MappinApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
//                LaunchScreenView.build()
//                ToastView.build()
                SearchMusicView(store: Store(initialState: SearchMusicReducer.State(), reducer: SearchMusicReducer()))
            }
        }
    }
}
