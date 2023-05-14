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
        case loadPins(category: PinsCategory?, centerLatitude: Double, centerLongitude: Double, latitudeDelta: Double, longitudeDelta: Double)
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
            case let .update(here, latitudeDelta, longitudeDelta):
                let category = state.category
                return .run { action in
                    await action.send(.loadPins(
                        category: category,
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
            case let .update(here, latitudeDelta, longitudeDelta):
                let category = state.category
                return .run { action in
                    await action.send(.loadPins(
                        category: category,
                        centerLatitude: here.0,
                        centerLongitude: here.1,
                        latitudeDelta: latitudeDelta,
                        longitudeDelta: longitudeDelta
                    ))
                }
            }
            
        case let .loadPins(category, centerLatitude, centerLongitude, latitudeDelta, longitudeDelta):
            return .merge(
                .task {
                    let mapPins: [Pin]
                    if centerLatitude != 404 && centerLongitude != 404 {
                        mapPins = try await getPinsUseCase.excuteUsingMap(
                            category: category,
                            latitudeDelta: latitudeDelta,
                            longitudeDelta: longitudeDelta
                        )
                    }
                    else {
                        mapPins = try await getPinsUseCase.excuteUsingMap(
                            category: category,
                            center: (centerLatitude, centerLongitude),
                            latitudeDelta: latitudeDelta,
                            longitudeDelta: longitudeDelta
                        )
                    }
                    return .mapPins(mapPins)
                },
                .task {
                    let listPins: [Pin]
                    if centerLatitude != 404 && centerLongitude != 404 {
                        listPins = try await getPinsUseCase.excuteUsingMap(
                            category: category,
                            latitudeDelta: latitudeDelta,
                            longitudeDelta: longitudeDelta
                        )
                    }
                    else {
                        listPins = try await getPinsUseCase.excuteUsingMap(
                            category: category,
                            center: (centerLatitude, centerLongitude),
                            latitudeDelta: latitudeDelta,
                            longitudeDelta: longitudeDelta
                        )
                    }
                    return .listPins(listPins)
                }
            )
            
        case let .addPin(music, latitudeDelta, longitudeDelta):
            let category = state.category
            return .task {
                try await addPinUseCase.excute(music: music)
                return .loadPins(
                    category: category,
                    centerLatitude: 404,
                    centerLongitude: 404,
                    latitudeDelta: latitudeDelta,
                    longitudeDelta: longitudeDelta
                )
            }
            
        case .mapPins(let pins):
            print("@LOG mapPins \(pins.map { $0.id })")
            state.pinsUsingMap = pins
            state.mapAction = .updatePins(pins)
            return .none
            
        case .listPins(let pins):
            state.pinsUsingList = pins
            return .none
            
        case let .setCategory(category):
            state.category = category
            return .none
        }
    }
}

extension PinMusicReducer {
    static func build() -> Self {
        PinMusicReducer(
            addPinUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(AddPinUseCase.self),
            getPinsUseCase: DefaultMockDIContainer.shared.container.resolver.resolve(GetPinsUseCase.self)
        )
    }
}
