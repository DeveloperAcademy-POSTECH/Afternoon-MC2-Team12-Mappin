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
    @State var action: MapView.Action = .none
    
    init(store: StoreOf<PinMusicReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }

    
    var body: some View {
        MapView(action: .constant(.none), store: viewStore, userTrackingMode: .follow)
            .ignoresSafeArea()
            .opacity(Double(action.yame))
            
    }
    
}

extension ContentView {
    static func build() -> Self {
        let pinsRepository = APIPinsRepository()
        let locationRepository = RequestLocationRepository.manager
        return ContentView(store: Store(
            initialState: PinMusicReducer.State(),
            reducer: PinMusicReducer(
                addPinUseCase: DefaultAddPinUseCase(
                    pinsRepository: pinsRepository,
                    geoCodeRepository: RequestGeoCodeRepository(),
                    locationRepository: locationRepository,
                    weatherRepository: RequestWeatherRepository(),
                    deviceRepository: RequestDeviceRepository()
                ),
                getPinsUseCase: DefaultGetPinUseCase(
                    locationRepository: locationRepository,
                    pinsRepository: pinsRepository,
                    pinClustersRepository: DefaultMockDIContainer.shared.container.resolver.resolve(PinClustersRepository.self)
                )
            )
        ))
    }
}

extension UUID: Identifiable {
    public var id: String { self.uuidString }
}
