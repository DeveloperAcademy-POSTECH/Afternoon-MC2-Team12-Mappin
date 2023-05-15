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
        var showingPinsView: [AnnotaitionPinView] = []
        var detailPin: Pin?
        var temporaryPinLocation: MKCoordinateRegion = MKCoordinateRegion()
        var category: PinsCategory?
    }
    enum Action: Equatable {
        
        case act(MapView.Action)
        case popUpClose
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
        case focusToLocation(latitude: Double, longitude: Double)
        case focusToPin(Pin)
        case setCategory(PinsCategory)
        case modalMinimumHeight(Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
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
                let category = state.category
                return .run { action in
                
                    await action.send(.loadPins(category: category,
                                          centerLatitude: centerLatitude,
                                          centerLongitude: centerLongitude,
                                          latitudeDelta: latitudeDelta,
                                          longitudeDelta: longitudeDelta))
                }
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
            guard let category = category else {
                return .none
            }
            let center = (centerLatitude, centerLongitude)
            return .merge(
                .task {
                    let mapPins: [Pin]
//                    if centerLatitude != 404 && centerLongitude != 404 {
//                        mapPins = try await getPinsUseCase.excuteUsingMap(
//                            category: category,
//                            center: center,
//                            latitudeDelta: latitudeDelta,
//                            longitudeDelta: longitudeDelta
//                        )
//                    }
//                    else {
//                        mapPins = try await getPinsUseCase.excuteUsingMap(
//                            category: category,
//                            center: center,
//                            latitudeDelta: latitudeDelta,
//                            longitudeDelta: longitudeDelta
//                        )
//                    }
                    mapPins = try await getPinsUseCase.excuteUsingMap(
                        category: category,
                        center: center,
                        latitudeDelta: latitudeDelta,
                        longitudeDelta: longitudeDelta
                    )

                    
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
//                    print("@KIO tap x : \(view.frame.minX - 10) <= \(point.x) <= \(view.frame.minX + 32)  y : \(view.frame.minY - 20) <= \(point.y) <= \(view.frame.minY + 36)")
                    if view.frame.minX - 10 <= point.x
                        && point.x <= view.frame.minX + 32
                        && view.frame.minY - 20 <= point.y
                        && point.y <= view.frame.minY + 36 {
                        
                        //print("@KIO tap origin : \(view.frame.minX), \(view.frame.minY) comapar : \(point.x), \(point.y)")
                        returnPin = view.pin
                    }
                }
            }
            state.detailPin = returnPin
            guard let returnPin = returnPin else  {
                
                return .none
            }
            if returnPin.count > 1 {
                print("@KIO tap here")
                state.detailPin = nil
                return .run { action in
                    await action.send(
                        .actAndChange(
                            .setCenterAndZoomUp(returnPin)
                        )
                    )
                }
            }
            else {
                return .run { action in
                    await action.send(
                        .actAndChange(
                            .setCenter(latitude: returnPin.location.latitude,
                                       longitude: returnPin.location.longitude
                                      )
                        )
                    )
                }
            }
        case .showPopUpAndCloseAfter:
            
            print("@KIO PIN remove bfore")
            state.mapAction = .removePin(id: "-1")
            state.detailPin = nil
            
            return .run { action in
                 await action.send(.actAndChange(.setCenter(latitude: RequestLocationRepository.manager.latitude, longitude: RequestLocationRepository.manager.longitude)))
            }
            
        case .actTemporaryPinLocation(let here):
            state.temporaryPinLocation = here
            return .none
            
        case .refreshPins:
            state.mapAction = .requestCallMapInfo
            return .none
            
        case let .focusToLocation(latitude, longitude):
            return .send(.actAndChange(.setCenter(latitude: latitude, longitude: longitude, isModal: false)))
            
        case let .focusToPin(pin):
            state.detailPin = pin
            return .send(.actAndChange(.setCenter(latitude: pin.location.latitude, longitude: pin.location.longitude, isModal: false)))
            
        case let .setCategory(category):
            state.category = category
            state.mapAction = .requestCallMapInfo
            return .none
            
        case .popUpClose:
            state.detailPin = nil
            return .send(.refreshPins)
            
        case .modalMinimumHeight(let isModal):
            let location = state.temporaryPinLocation.center
           
            return .run { action in
                await action.send(.actAndChange(.setCenter(latitude: location.latitude, longitude: location.longitude, isModal: isModal)))
            }
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

