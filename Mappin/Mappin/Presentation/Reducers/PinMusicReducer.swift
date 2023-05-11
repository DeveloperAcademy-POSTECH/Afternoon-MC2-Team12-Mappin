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


struct PinMusicReducer: ReducerProtocol {
    
    let addPinUseCase: AddPinUseCase
    let getPinsUseCase: GetPinsUseCase
    
    struct State: Equatable {
        
        var currentLocation: MKCoordinateRegion = MKCoordinateRegion()
        var showingPins: [Pin] = []
        var mapUserTrakingMode: MapUserTrackingMode = .follow
    }
    
    enum Action {
        
        case loadPinsUsingMap(latitudeDelta: Double, longitudeDelta: Double)
        case loadPinsUsingList(latitudeDelta: Double, longitudeDelta: Double)
        case mapPins([Pin])
        case addPin(music: Music)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loadPinsUsingMap(latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
            return .task {
                let pins = try await getPinsUseCase.excuteUsingMap(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                return .mapPins(pins)
            }
        case .loadPinsUsingList(latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
            return .task {
                let pins = try await getPinsUseCase.excuteUsingList(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                return .mapPins(pins)
            }
        case .addPin(music: let music):
            return .task {
                try await addPinUseCase.excute(music: music)
                return .mapPins([])
            }
            
        case .mapPins(let pins):
            state.showingPins = pins
            return .none
        default:
            return .none
        }
    }
}

