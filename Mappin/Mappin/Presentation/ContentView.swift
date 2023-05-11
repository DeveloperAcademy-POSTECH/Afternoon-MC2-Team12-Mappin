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
    @State var temp: Double = 100
    
    init(store: StoreOf<PinMusicReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }

    
    var body: some View {
//        MapView(action: viewStore.binding(get: \.mapAction, send: .), userTrackingMode: .follow)
//            .ignoresSafeArea()
//            .opacity(Double(action.yame))
    }
}


extension UUID: Identifiable {
    public var id: String { self.uuidString }
}
