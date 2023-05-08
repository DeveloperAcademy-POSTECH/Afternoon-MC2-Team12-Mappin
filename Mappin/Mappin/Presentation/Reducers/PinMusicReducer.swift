//
//  PinMusicReducer.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import ComposableArchitecture

import CoreLocation
import MapKit
@preconcurrency import SwiftUI


struct PinMusicReducer: ReducerProtocol {
   
    struct State: Equatable {
        
        var currentLocation: MKCoordinateRegion = MKCoordinateRegion()
        var showingPins: [Pin] = []
        var mapUserTrakingMode: MapUserTrackingMode = .follow
    }
    
    enum Action {
        case loadPins(centerPoint: CLLocationCoordinate2D)
        case updateCurrentLocation
        case changeTrakingMode(MapUserTrackingMode)
        
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .updateCurrentLocation:
            
            return .none
        case .changeTrakingMode(let newMode):
            state.mapUserTrakingMode = newMode
            return .none
        default:
            return .none
        }
    }
}
