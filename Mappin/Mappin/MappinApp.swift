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
            ContentView(
                store: Store(
                    initialState: PinMusicReducer.State(),
                    reducer: PinMusicReducer()._printChanges()
                )
            )
            .onAppear {
                _ = LocationManager.shared
            }
        }
    }
}
