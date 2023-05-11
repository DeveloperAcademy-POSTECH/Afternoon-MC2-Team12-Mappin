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
    
    struct State: Equatable {
        
        var mapAction: MapView.Action = .none
        var currentLocation: MKCoordinateRegion = MKCoordinateRegion()
        var pinsUsingMap: [Pin] = []
        var pinsUsingList: [Pin] = []
        var mapUserTrakingMode: MapUserTrackingMode = .follow
    }
    
    enum Action {
        
        case changeAction
        case loadPins(latitudeDelta: Double, longitudeDelta: Double)
        case mapPins([Pin])
        case listPins([Pin])
        case addPin(music: Music, latitudeDelta: Double, longitudeDelta: Double)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
        switch action {
        case .changeAction:
            switch state.mapAction {
            case .none:
                return .none
            case .createTemporaryPin(currentLocation: let currentLocation):
                return .none
            case .updatePins(_):
                return .none
            case .move(here: let here):
                //Action.send
                return .none
            }
        
        case .loadPins(latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
            return .merge(
                .task {
                    
                    let mapPins = try await getPinsUseCase.excuteUsingMap(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                    return .mapPins(mapPins)
                },
                .task {
                    
                    let listPins = try await getPinsUseCase.excuteUsingList(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                    return .listPins(listPins)
                }
            )
            
        case .addPin(music: let music, latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
            return .task {
                try await addPinUseCase.excute(music: music)
                return .loadPins(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            }
            
        case .mapPins(let pins):
            state.pinsUsingMap = pins
            state.mapAction = .updatePins(pins)
            return .none
            
        case .listPins(let pins):
            state.pinsUsingList = pins
            return .none
        default:
            return .none
        }
    }
}
