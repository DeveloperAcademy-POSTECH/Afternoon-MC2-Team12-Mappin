//
//  PinMusicReducer.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import ComposableArchitecture

import CoreLocation
import MapKit
import SwiftUI

protocol PinMusic: ReducerProtocol {
    var addPinUseCase: AddPinUseCase { get }
    var getPinsUseCase: GetPinsUseCase { get }
}

struct PinMusicReducer: PinMusic {
    
    let addPinUseCase: AddPinUseCase
    let getPinsUseCase: GetPinsUseCase
    
    struct IdForDebounce: Hashable { }
    
    struct State: Equatable {
        
        var mapAction: MapView.Action = .none 
        var currentLocation: MKCoordinateRegion = MKCoordinateRegion()
        var pinsUsingMap: [Pin] = []
        var pinsUsingList: [Pin] = []
        var mapUserTrakingMode: MapUserTrackingMode = .follow
        
        var category: PinsCategory?
        var lastAction: UniqueAction<Action>?
    }
    
    enum Action: Equatable {
        case act(MapView.Action)
        case actAndChange(MapView.Action)
        case loadPins(centerLatitude: Double, centerLongitude: Double, latitudeDelta: Double, longitudeDelta: Double)
        case mapPins([Pin])
        case listPins([Pin])
        case addPin(music: Music, latitudeDelta: Double, longitudeDelta: Double)
        case setCategory(PinsCategory)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        state.lastAction = .init(action)
        switch action {
            
        case .act(let value):
            switch value {
            case .none:
                return .none
            case .createTemporaryPin(currentLocation: let currentLocation):
                return .none
            case .updatePins(_):
                return .none
            case .update(here: let here, latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
                return .run { action in
                    await action.send(.loadPins(
                        centerLatitude: here.0,
                        centerLongitude: here.1,
                        latitudeDelta: latitudeDelta,
                        longitudeDelta: longitudeDelta
                    ))
                }
            }
            
        case .actAndChange(let value):
            state.mapAction = value
            switch value {
            case .none:
                return .none
            case .createTemporaryPin(currentLocation: let currentLocation):
                return .none
            case .updatePins(_):
                return .none
            case .update(here: let here, latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
                return .run { action in
                    await action.send(.loadPins(
                        centerLatitude: here.0,
                        centerLongitude: here.1,
                        latitudeDelta: latitudeDelta,
                        longitudeDelta: longitudeDelta
                    ))
                }
            }
            
        case let .loadPins(centerLatitude, centerLongitude, latitudeDelta, longitudeDelta):
            return .merge(
                .task {
                    let mapPins: [Pin]
                    if centerLatitude != 404 && centerLongitude != 404 {
                        mapPins = try await getPinsUseCase.excuteUsingMap(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                    }
                    else {
                        mapPins = try await getPinsUseCase.excuteUsingMap(center: (centerLatitude, centerLongitude), latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                    }
                    return .mapPins(mapPins)
                },
                .task {
                    let listPins: [Pin]
                    if centerLatitude != 404 && centerLongitude != 404 {
                        listPins = try await getPinsUseCase.excuteUsingMap(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                    }
                    else {
                        listPins = try await getPinsUseCase.excuteUsingMap(center: (centerLatitude, centerLongitude), latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                    }
                    return .listPins(listPins)
                }
            )
            
        case .addPin(music: let music, latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
            return .task {
                try await addPinUseCase.excute(music: music)
                return .loadPins(
                    centerLatitude: 404,
                    centerLongitude: 404,
                    latitudeDelta: latitudeDelta,
                    longitudeDelta: longitudeDelta
                )
            }
            
        case .mapPins(let pins):
            print("@LOG mapPins")
            state.pinsUsingMap = pins
            state.mapAction = .updatePins(pins)
            return .none
            
        case .listPins(let pins):
            state.pinsUsingList = pins
            return .none
            
        case let .setCategory(category):
            state.category = category
            print("@LOG category pinmusic \(category)")
            return .none
        }
    }
}

extension PinMusicReducer {
    static func build() -> Self {
        PinMusicReducer(
            addPinUseCase: DefaultAddPinUseCase(
                pinsRepository: APIPinsRepository(),
                geoCodeRepository: RequestGeoCodeRepository(),
                locationRepository: RequestLocationRepository.manager,
                weatherRepository: RequestWeatherRepository(),
                deviceRepository: RequestDeviceRepository()
            ),
            getPinsUseCase: DefaultGetPinUseCase(
                locationRepository: RequestLocationRepository.manager,
                pinsRepository: APIPinsRepository(),
                pinClustersRepository: APIPinClustersRepository()
            )
        )
    }
}
