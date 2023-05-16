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
    
    //typealias ClusterPinsType = Int
    
    let addPinUseCase: AddPinUseCase
    let getPinsUseCase: GetPinsUseCase
    
    struct IdForDebounce: Hashable { }
    
    struct State: Equatable {
        
        var mapAction: MapView.Action = .none
        var mapState: MapView.State = .justShowing
        
        var currentLocation: MKCoordinateRegion = MKCoordinateRegion()
        var pinsUsingMap: [PinCluster] = []
        var pinsUsingList: [Pin] = []
        var mapUserTrakingMode: MapUserTrackingMode = .follow
        var showingPinsView: [AnnotaitionPinView] = []
        var listPins: [Pin] = []
        var temporaryPinLocation: MKCoordinateRegion = MKCoordinateRegion()
        var category: PinsCategory?
        var detailPin: Pin?
    }
    enum Action: Equatable {
        
        case act(MapView.Action)
        case changeMapState(MapView.State)
        case popUpClose
        case actAndChange(MapView.Action)
        case loadPinsUsingMap(category: PinsCategory?, centerLatitude: Double, centerLongitude: Double, latitudeDelta: Double, longitudeDelta: Double)
        case loadPinsUsingList([Int])
        case mapPins([PinCluster])
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
            
        case .changeMapState(let newState):
            state.mapState = newState
            return .none
            
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
                    
                    await action.send(.loadPinsUsingMap(category: category,
                                                        centerLatitude: centerLatitude,
                                                        centerLongitude: centerLongitude,
                                                        latitudeDelta: latitudeDelta,
                                                        longitudeDelta: longitudeDelta))
                }
            case .requestUpdate(let latitude, let longitude, latitudeDelta: let latitudeDelta, longitudeDelta: let longitudeDelta):
                state.mapState = .loadPin
                let category = state.category
                return .run { action in
                    await action.send(.loadPinsUsingMap(
                        category: category,
                        centerLatitude: latitude,
                        centerLongitude: longitude,
                        latitudeDelta: latitudeDelta,
                        longitudeDelta: longitudeDelta
                    ))
                }
            case .requestCurrentShowingPinViews( let views ):
                state.showingPinsView = views
                state.mapAction = .none
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
                    await action.send(.loadPinsUsingMap(
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
            
        case let .loadPinsUsingMap(category, centerLatitude, centerLongitude, latitudeDelta, longitudeDelta):
            guard let category = category else {
                return .none
            }
            let center = (centerLatitude, centerLongitude)
            print("@KIO test update Load Pin")
            return .task {
                let mapPins: [PinCluster]
                mapPins = try await getPinsUseCase.excuteUsingMap(
                    category: category,
                    center: center,
                    latitudeDelta: latitudeDelta,
                    longitudeDelta: longitudeDelta
                )
                
                print("@KIO test update once \(mapPins)")
                return .mapPins(mapPins)
            }
            
        case .loadPinsUsingList(let ids):
            return .task {
                let listPins = try await getPinsUseCase.excuteUsingList(ids: ids)
                return .listPins(listPins)
            }
            
            
        case .addPin(let music, let latitude, let longitude):
            return .run { action in
                let pin = try await addPinUseCase.excute(music: music, latitude: latitude, longitude: longitude)
                print("@KIO addpinReducer \(pin)")
                await action.send(.completeAddPin(pin))
            }
            
        case .mapPins(let pins):
            print("@KIO test update map Pins")
            state.pinsUsingMap = pins
            state.mapAction = .responseUpdate(pins)
            return .none
            
        case .completeAddPin(let pin):
            
            state.detailPin = pin
            state.mapState = .showingPopUp
            state.mapAction = .completeAdd(pin)
            return .none
            
        case .listPins(let pins):
            state.pinsUsingList = pins
            return .none
            
        case .tapPin( let point ):
            var returnPin: PinCluster?
            
            for view in state.showingPinsView {
                if view.frame.minX != 0.0 {
                    //                    print("@KIO tap x : \(view.frame.minX - 10) <= \(point.x) <= \(view.frame.minX + 32)  y : \(view.frame.minY - 20) <= \(point.y) <= \(view.frame.minY + 36)")
                    if view.frame.minX - 10 <= point.x
                        && point.x <= view.frame.minX + 32
                        && view.frame.minY - 20 <= point.y
                        && point.y <= view.frame.minY + 36 {
                        
                        returnPin = view.pinCluter
                    }
                }
            }
            guard let returnPin = returnPin else  {
                
                return .none
            }
            
            return .run { action in
                await action.send(
                    .actAndChange(
                        .setCenterWithModal(
                            returnPin.location.latitude,
                            returnPin.location.longitude
                        )
                    )
                )
                await action.send(.loadPinsUsingList(returnPin.pinIds))
            }
            
        case .showPopUpAndCloseAfter:
            
            print("@KIO PIN remove bfore")
            state.detailPin = nil
            state.mapAction = .removeAllAnnotation
            
            //[Temporary]
            
            return .run { action in
                await action.send(.actAndChange(.setCenter(latitude: RequestLocationRepository.manager.latitude, longitude: RequestLocationRepository.manager.longitude)))
                await action.send(.changeMapState(.justShowing))
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
            // [Temporary]
            
            print("@KIO plz \(pin)")
            state.detailPin = pin // modal
            return .send(.actAndChange(.setCenterWithModal(pin.location.latitude, pin.location.longitude)))
            
        case let .setCategory(category):
            state.category = category
            state.mapAction = .requestCallMapInfo
            return .none
            
        case .popUpClose:
            
            state.mapState = .justShowing
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

