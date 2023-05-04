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
    
    @ObservedObject var viewStore: ViewStore<PinMusicReducer.State, PinMusicReducer.Action>
    
    var body: some View {
        Map(coordinateRegion: self.viewStore.binding(get: \.currentLocation,
                                                     send: PinMusicReducer.Action.updateCurrentLocation),
            interactionModes: [],
            showsUserLocation: true,
            userTrackingMode: self.viewStore.binding(get: \.mapUserTrakingMode, send: PinMusicReducer.Action.changeTrakingMode(.follow)))
    }
}

