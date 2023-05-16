//
//  MapView.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct MapView: UIViewRepresentable {
    
    @Binding var action: Action
    let store: ViewStoreOf<PinMusicReducer>
    var userTrackingMode: MKUserTrackingMode
    
    //@State var currentLocationVisible
    
    var isArchive: Bool = false
    static var isAnimating = false
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        //        if !isArchive {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //                mapView.setRegion(latitude: RequestLocationRepository.manager.latitude, longitude:
        //                                    RequestLocationRepository.manager.longitude,
        //                                  latitudeDelta: Constants.defaultLatitudeDelta,
        //                                  longitudeDelta: Constants.defaultLongitudeDelta)
        //            }
        //        }
        //
        mapView.isRotateEnabled = false
        mapView.userTrackingMode = isArchive ? .none : .follow
        mapView.isUserInteractionEnabled = isArchive
        if isArchive {
            mapView.register(AnnotaitionPinView.self, forAnnotationViewWithReuseIdentifier: "AnnotaitionPinView")
        }
        else {
            mapView.register(AnnotaitionPinView.self, forAnnotationViewWithReuseIdentifier: "TemporaryAnnotaitionPinView")
        }
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        print("@KIO what? come \(store.state)")
        switch store.mapAction {
        case .none:
            mapView.showsUserLocation = true
            break
            
        case .setCenterWithModal(let latitude, let longitude, let much):
            let latitudeDelta = mapView.region.span.latitudeDelta
            let longitudeDelta = mapView.region.span.longitudeDelta
            print("@KIO lati 3 \(latitude) and \(longitude)")
            
            mapView.setRegion(latitude: latitude - (latitudeDelta / much),
                              longitude: longitude,
                              latitudeDelta: latitudeDelta,
                              longitudeDelta: longitudeDelta)
            
        case .removeAllAnnotation:
            mapView.removeAllAnotation()
            
        case .responseUpdate(let newPins):
            if isArchive && store.state.mapState == .loadPin {
                
                mapView.removeAllAnotation()
                mapView.addAnnotations( newPins.map{ PinAnnotation($0) })
                store.send(.changeMapState(.justShowing))
            }
            break
            
        case .requestUpdate(_, _, _, _):
            break
            
        case .setCenter(let latitude, let longitude, let isModal):
            mapView.showsUserLocation = true
            mapView.setRegion(latitude: isModal ? latitude - Constants.centerOffSet : latitude,
                              longitude: longitude,
                              latitudeDelta: MapView.Constants.defaultLatitudeDelta,
                              longitudeDelta: MapView.Constants.defaultLongitudeDelta)
            
            
        case .setCenterWithModalAndAddTemporaryPin(let latitude, let longitude):
            
            mapView.showsUserLocation = false
            store.send(.changeMapState(.showTemporaryPin))
            
            let currentLocation = MKCoordinateRegion(center:
                                                        CLLocationCoordinate2D(
                                                            latitude:  latitude,
                                                            longitude: longitude
                                                        ),
                                                     span: MKCoordinateSpan(latitudeDelta: Constants.defaultLatitudeDelta,
                                                                            longitudeDelta: Constants.defaultLongitudeDelta))
            
            var temporaryPin = PinCluster.empty
            temporaryPin.location.latitude = latitude
            temporaryPin.location.longitude = longitude
            
            let temp = PinAnnotation(temporaryPin)
            mapView.addAnnotation(temp)
            
            var region = mapView.region
            region.center.latitude = latitude
            region.center.longitude = longitude
            
            store.send(.actTemporaryPinLocation(
                region
            ))
            
            let latitudeDelta = mapView.region.span.latitudeDelta
            let longitudeDelta = mapView.region.span.longitudeDelta
            
            store.send(.changeMapState(.showTemporaryPin))
            
            mapView.setRegion(latitude: latitude - (latitudeDelta / 2.5 ),
                              longitude: longitude,
                              latitudeDelta: latitudeDelta,
                              longitudeDelta: longitudeDelta)
            
            store.send(.actAndChange(.dummy))
            
            
        case .cancelModal(let latitude, let longitude):
            
            store.send(.changeMapState(.justShowing))
            
            mapView.removeAllAnotation()
            
            store.send(.actAndChange(.none))
            mapView.setRegion(latitude: latitude, longitude: longitude, latitudeDelta: Constants.defaultLatitudeDelta, longitudeDelta: Constants.defaultLongitudeDelta)
            
        case .completeAdd(let pin):
            
            store.send(.actAndChange(.setCenter(latitude: pin.location.latitude, longitude: pin.location.longitude)))
            var pin = PinCluster.empty
            pin.location.latitude = store.state.temporaryPinLocation.center.latitude
            pin.location.longitude = store.state.temporaryPinLocation.center.longitude
            mapView.addAnnotation(PinAnnotation(pin))
            
            
        case .requestCallMapInfo:
            
            store.send(
                .act(
                    .reponseCallMapInfo(
                        centerLatitude: mapView.region.center.latitude,
                        centerLongitude: mapView.region.center.longitude,
                        latitudeDelta: mapView.region.span.latitudeDelta,
                        longitudeDelta: mapView.region.span.longitudeDelta)
                )
            )
            
        default:
            break
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            if parent.isArchive {
                print( print("@KIO check \(mapView.region.center.latitude) and \(mapView.region.span.latitudeDelta)"))
                parent.store.send(.act(.requestUpdate(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude, latitudeDelta: mapView.region.span.latitudeDelta, longitudeDelta: mapView.region.span.longitudeDelta)))
                
                let pinAnnotationViews = mapView.annotations.map { annotation in
                    guard let pinAnnotationView = mapView.view(for: annotation) as? AnnotaitionPinView else { return AnnotaitionPinView() }
                    
                    return pinAnnotationView
                }
                parent.store.send(.act(.requestCurrentShowingPinViews(pinAnnotationViews)))
            }
        }
        
        func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
            if parent.isArchive {
                let pinAnnotationViews = mapView.annotations.map { annotation in
                    guard let pinAnnotationView = mapView.view(for: annotation) as? AnnotaitionPinView else { return AnnotaitionPinView() }
                    
                    return pinAnnotationView
                }
                parent.store.send(.act(.requestCurrentShowingPinViews(pinAnnotationViews)))
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if !MapView.isAnimating && parent.isArchive {
                guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotaitionPinView") as? AnnotaitionPinView,
                      let pinAnnotation = annotation as? PinAnnotation else {
                    
                    let current = AnnotaitionPinView()
                    current.pinCategory = nil
                    
                    return current
                }
                
                pinView.annotation = pinAnnotation
                pinView.pinCluter = pinAnnotation.pinCluter
                
                return pinView
            }
            else {
                guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "TemporaryAnnotaitionPinView") as? AnnotaitionPinView,
                      let pinAnnotation = annotation as? PinAnnotation else {
                    
                    let returnView = AnnotaitionPinView()
                    returnView.pinCategory = nil
                    return returnView
                }
                
                pinView.annotation = pinAnnotation
                pinView.pinCluter = pinAnnotation.pinCluter
                pinView.alpha = parent.store.state.mapState == .showTemporaryPin ? 0.2 : 1.0
                
                return pinView
            }
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if parent.isArchive == false && parent.store.state.mapState != .showTemporaryPin && parent.store.mapState != .showingPopUp {
                if let location = userLocation.location {
                    mapView.setRegion(animated: false,
                                      latitude: location.coordinate.latitude,
                                      longitude: location.coordinate.longitude,
                                      latitudeDelta: Constants.defaultLatitudeDelta,
                                      longitudeDelta: Constants.defaultLongitudeDelta)
                }
            }
        }
    }
    
}

extension MapView {
    struct Constants {
        static var defaultLatitudeDelta: Double = 0.0017311351539746056
        static var defaultLongitudeDelta: Double = 0.0011165561592463291
        static var centerOffSet: Double = 0.00068
        static var temporaryPinId: Int = -1
    }
}

extension MapView {
    
    enum Action: Equatable {
        
        case none
        case responseUpdate([PinCluster]) // 결과값을 들고 오는
        case requestUpdate(latitude: Double, longitude: Double, latitudeDelta: Double, longitudeDelta: Double) // 현재값을 reducer로 던져주는
        
        case requestCurrentShowingPinViews([AnnotaitionPinView]) // 현재 핀들의 뷰들의 위치를 주기 위해
        
        case setCenter(latitude: Double, longitude: Double, isModal: Bool = false) // 현재위치로 지도 이동
        case setCenterWithModalAndAddTemporaryPin(latitude: Double, longitude: Double) // setcenter, removeAllAnnotation
        case cancelModal(latitude: Double, longitude: Double) // setCenter, removeAllAnntaion, popupclose
        case completeAdd(Pin) // setCenter, removeAllAnntaion
        
        
        case requestCallMapInfo
        case reponseCallMapInfo(centerLatitude: Double, centerLongitude: Double, latitudeDelta: Double, longitudeDelta: Double)
        case removeAllAnnotation
        case setCenterWithModal(Double, Double, Double)
        case showUserLocation(Bool)
        case dummy
        
        var yame: Int {
            (1...10000).randomElement()!
        }
    }
    
    enum State: Equatable {
        
        case justShowing
        case animating
        case showTemporaryPin
        case loadPin
        case showingPopUp
        
    }
}

extension MapView {
    
    func animationEnded(completion: @escaping ()->Void ) {
        MapView.isAnimating = true
        completion()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            
            MapView.isAnimating = false
        }
    }
}
