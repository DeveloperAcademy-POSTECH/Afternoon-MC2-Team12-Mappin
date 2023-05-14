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
        
        var mapAction: MapView.Action = .none {
            didSet(value) {
                print("@KIO here \(value)")
            }
        }
        
        var currentLocation: MKCoordinateRegion = MKCoordinateRegion()
        var pinsUsingMap: [Pin] = []
        var pinsUsingList: [Pin] = []
        var mapUserTrakingMode: MapUserTrackingMode = .follow
        var showingPinsView: [AnnotaitionPinView] = []
        var detailPin: Pin?
        var temporaryPinLocation: MKCoordinateRegion = MKCoordinateRegion()
        var category: PinsCategory?
        var lastAction: UniqueAction<Action>?
    }
    
    
    enum Action: Equatable {
        
        case act(MapView.Action)
        case actAndChange(MapView.Action)
        case loadPins(category: PinsCategory?, centerLatitude: Double, centerLongitude: Double, latitudeDelta: Double, longitudeDelta: Double)
        case mapPins([Pin])
        case listPins([Pin])
        case addPin(music: Music, latitude: Double, longitude: Double)
        case tapPin(CGPoint)
        case showPopUpAndCloseAfter
        case completeAddPin(Pin)
        case actTemporaryPinLocation(MKCoordinateRegion)
        case none
        case refreshPins
        case focusToPin(Pin)
        case setCategory(PinsCategory)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
//        state.lastAction = .init(action)
        
        switch action {
        case .none:
            return .none
            
        case .act(let value):
            switch value {
            case .none:
                return .none
            case .responseUpdate(_):
                return .none
            case .reponseCallMapInfo(let centerLatitude, let centerLongitude, let latitudeDelta, let longitudeDelta):
                print("@KIO here callmap")
                let category = state.category
                return .run { action in
                    print("@KIO here Byo")
                    await action.send(.loadPins(category: category,
                                          centerLatitude: centerLatitude,
                                          centerLongitude: centerLongitude,
                                          latitudeDelta: latitudeDelta,
                                          longitudeDelta: longitudeDelta))
                }
            case .requestUpdate(let latitude, let longitude, latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
                let category = state.category
                print("@KIO WHy?")
                return .run { action in
                    await action.send(.loadPins(
                        category: category,
                        centerLatitude: latitude,
                        centerLongitude: longitude,
                        latitudeDelta: latitudeDelta,
                        longitudeDelta: longitudeDelta
                    ))
                }
            case .requestCurrentShowingPinViews( let views ):
                state.showingPinsView = views
                return .none
            default:
                return .none
            }
            
        case .actAndChange(let value):
            
            state.mapAction = value
            switch value {
            case .none:
                return .none
            case .responseUpdate(_):
                return .none
                
            case .requestUpdate(let latitude, let longitude, latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
                let category = state.category
                
                return .run { action in
                    await action.send(.loadPins(
                        category: category,
                        centerLatitude: latitude,
                        centerLongitude: longitude,
                        latitudeDelta: latitudeDelta,
                        longitudeDelta: longitudeDelta
                    ))
                }
            default:
                return .none
            }
            
        case let .loadPins(category, centerLatitude, centerLongitude, latitudeDelta, longitudeDelta):
            print("@KIO here Loadpins")
            let center = (centerLatitude, centerLongitude)
            return .merge(
                .task {
                    let mapPins: [Pin]
                    if centerLatitude != 404 && centerLongitude != 404 {
                        mapPins = try await getPinsUseCase.excuteUsingMap(
                            category: category,
                            center: center,
                            latitudeDelta: latitudeDelta,
                            longitudeDelta: longitudeDelta
                        )
                    }
                    else {
                        mapPins = try await getPinsUseCase.excuteUsingMap(
                            category: category,
                            center: center,
                            latitudeDelta: latitudeDelta,
                            longitudeDelta: longitudeDelta
                        )
                    }
                    print("@KIO here \(mapPins)")
                    return .mapPins(mapPins)
                },
                .task {
                    let listPins: [Pin]
                    if centerLatitude != 404 && centerLongitude != 404 {
                        listPins = try await getPinsUseCase.excuteUsingList(
                            category: category,
                            center: center,
                            latitudeDelta: latitudeDelta,
                            longitudeDelta: longitudeDelta
                        )
                    }
                    else {
                        print("@KIO here fuck")
                        listPins = try await getPinsUseCase.excuteUsingList(
                            category: category,
                            center: center,
                            latitudeDelta: latitudeDelta,
                            longitudeDelta: longitudeDelta
                        )
                    }
                    return .listPins(listPins)
                }
            )
            
            
        case .addPin(let music, let latitude, let longitude):
            return .run { action in
                let pin = try await addPinUseCase.excute(music: music, latitude: latitude, longitude: longitude)
                print("@KIO addpinReducer \(pin)")
                await action.send(.completeAddPin(pin))
            }
            
        case .mapPins(let pins):
            state.pinsUsingMap = pins
            print("@KIO WHy? \(pins)")
            state.mapAction = .responseUpdate(pins)
            return .none
            
        case .completeAddPin(let pin):
            state.detailPin = pin
            state.mapAction = .completeAdd(pin)
            return .none
            
        case .listPins(let pins):
            state.pinsUsingList = pins
            return .none
            
        case .tapPin( let point ):
            var returnPin: Pin?
            
            for view in state.showingPinsView {
                if view.frame.minX != 0.0 {
                    if view.frame.minX <= point.x
                        && point.x <= view.frame.minX + 40
                        && view.frame.minY - 40 <= point.y
                        && point.y <= view.frame.minY {
                        
                        returnPin = view.pin
                    }
                }
            }
            state.detailPin = returnPin
            guard let returnPin = returnPin else  {
                return .none
            }
            if returnPin.count > 1 {
                return .run { action in
                    await action.send(
                        .actAndChange(
                            .setCenterAndZoomUp(returnPin)
                        )
                    )
                }
            }
            return .run { action in
                await action.send(
                    .actAndChange(
                        .setCenter(latitude: returnPin.location.latitude,
                                   longitude: returnPin.location.longitude
                                    )
                                  )
                    )
            }
        case .showPopUpAndCloseAfter:
            
            print("@KIO PIN remove bfore")
            state.mapAction = .removePin(id: "-1")
            state.detailPin = nil
            
            return .run { action in
                try await action.send(.actAndChange(.setCenter(latitude: RequestLocationRepository.manager.latitude, longitude: RequestLocationRepository.manager.longitude)))
            }
            
        case .actTemporaryPinLocation(let here):
            state.temporaryPinLocation = here
            return .none
            
        case .refreshPins:
            print("@BYO action.refreshPins")
            return .none
            
        case let .focusToPin(pin):
            print("@BYO action.focusToPin \(pin)")
            return .send(.actAndChange(.setCenter(latitude: pin.location.latitude, longitude: pin.location.longitude, isModal: false)))
            
        case let .setCategory(category):
            state.category = category
            state.mapAction = .requestCallMapInfo
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

