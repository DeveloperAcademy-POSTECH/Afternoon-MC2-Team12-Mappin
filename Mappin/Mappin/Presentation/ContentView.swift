//
//  ContentView.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import SwiftUI
import ComposableArchitecture
import MapKit

struct ContentView: View {
    
    let store: StoreOf<PinMusicReducer>
    
    @ObservedObject var viewStore: ViewStoreOf<PinMusicReducer>

    init(store: StoreOf<PinMusicReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }

    
    var body: some View {
        Map(coordinateRegion: self.viewStore.binding(get: \.currentLocation,
                                                     send: PinMusicReducer.Action.updateCurrentLocation),
            interactionModes: [],
            showsUserLocation: true,
            userTrackingMode: self.viewStore.binding(get: \.mapUserTrakingMode, send: PinMusicReducer.Action.changeTrakingMode(.follow)))
    }
}

