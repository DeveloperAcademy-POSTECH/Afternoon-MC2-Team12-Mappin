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
        
    }
}

