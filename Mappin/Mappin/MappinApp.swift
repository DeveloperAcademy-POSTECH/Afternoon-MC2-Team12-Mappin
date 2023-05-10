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
            PrimaryView()
            //MapView(action: .constant(.none), userTrackingMode: .follow)
//            ContentView(
//                store: Store(
//                    initialState: PinMusicReducer.State(),
//                    reducer: PinMusicReducergit ()._printChanges()
//                )
//            )
//            .onAppear {
//                _ = RequestLocationRepository.manager
//            }
        }
    }
}
