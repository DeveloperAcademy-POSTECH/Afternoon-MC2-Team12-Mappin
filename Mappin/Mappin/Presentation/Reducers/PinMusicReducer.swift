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

enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}

struct PinMusicReducer: ReducerProtocol {
   
    struct State {
        
        var currentLocation: MKCoordinateRegion
        var showingPins: [Pin]
        var mapUserTrakingMode: MapUserTrackingMode
    }
    
    enum Action {
        case loadPins(centerPoint: CLLocationCoordinate2D)
        case updateCurrentLocation
        case changeTrakingMode(MapUserTrackingMode)
        
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .updateCurrentLocation:
                state.currentLocation =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LocationManager.shared.latitude, longitude: LocationManager.shared.longitude), latitudinalMeters: 350, longitudinalMeters: 350)
                return .none
            case .changeTrakingMode(let newMode):
                state.mapUserTrakingMode = newMode
                return .none
            default:
                return .none
            }
        }
    }
}


// 처음 3
// 처음 4
// 3
// 왜 안올라가지?
// add -f
// 그시절 프로젝트가 올라간거져 -> 몇개없다
// 뵤 작업을 하고
// 작업을
// 파일만 추가될뿐

