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
        
        switch store.mapAction {
        case .none:
            print("@KIO cute \(mapView.annotations.count)")
            mapView.showsUserLocation = true
            mapView
            break
            
        case .responseUpdate(let newPins):
            if isArchive && store.state.mapState == .loadPin {
                print("@KIO test update responseUpdate")
                
                mapView.removeAllAnotation()
                mapView.addAnnotations(newPins.map{ PinAnnotation($0) })
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
            
            
        case .removePin(let id):
            let annotationPins = mapView.annotations.map { annotation in
                guard let annotaionPin = annotation as? PinAnnotation else { return PinAnnotation(Pin.empty) }
                return annotaionPin
            }
            
            let willRemovePin = annotationPins.first(where: { $0.pin.id == id }) ?? PinAnnotation(Pin.empty)
            mapView.removeAnnotation(willRemovePin)
            
        case .setCenterWithModalAndAddTemporaryPin(let latitude, let longitude):
            
            mapView.showsUserLocation = false
            store.send(.changeMapState(.showTemporaryPin))
            store.send(.actAndChange(.setCenter(latitude: latitude, longitude: longitude, isModal: true)))
            
            
            let currentLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                                     span: MKCoordinateSpan(latitudeDelta: Constants.defaultLatitudeDelta,
                                                                            longitudeDelta: Constants.defaultLongitudeDelta))
            
            
            store.send(.actTemporaryPinLocation(currentLocation))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                var temporaryPin = Pin.empty
                temporaryPin.location.latitude = latitude
                temporaryPin.location.longitude = longitude
                temporaryPin.id = Constants.temporaryPinId
                let temp = PinAnnotation(temporaryPin)
                print("@KIO test dont show \(store.state.mapState)")
                mapView.addAnnotation(temp)
            }
            
            
        case .cancelModal(let latitude, let longitude):
            
            store.send(.changeMapState(.justShowing))
            
            mapView.removeAllAnotation()
            
            print("@KIO cute \(store.state.mapAction)")
            store.send(.actAndChange(.none))
            mapView.setRegion(latitude: latitude, longitude: longitude, latitudeDelta: Constants.defaultLatitudeDelta, longitudeDelta: Constants.defaultLongitudeDelta)
            
        case .completeAdd(let pin):
            
            store.send(.actAndChange(.setCenter(latitude: pin.location.latitude, longitude: pin.location.longitude)))
            var pin = Pin.empty
            pin.location.latitude = store.state.temporaryPinLocation.center.latitude
            pin.location.longitude = store.state.temporaryPinLocation.center.longitude
            mapView.addAnnotation(PinAnnotation(pin))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                
                mapView.showsUserLocation = true
                store.send(.showPopUpAndCloseAfter)
                mapView.removeAllAnotation()
                store.send(.changeMapState(.justShowing))
            }
            
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
        case .setCenterAndZoomUp(let pin):
            print("@KIO tap zoom here")
            mapView.setRegion(MKCoordinateRegion(center:
                                                    CLLocationCoordinate2D(
                                                        latitude: pin.location.latitude,
                                                        longitude: pin.location.longitude),
                                                 span:
                                                    MKCoordinateSpan(
                                                        latitudeDelta: mapView.region.span.latitudeDelta / 2,
                                                        longitudeDelta: mapView.region.span.longitudeDelta / 2
                                                    )
                                                ),
                              animated: true)
            store.send(.changeMapState(.justShowing))
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
                pinView.pin = pinAnnotation.pin
                
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
                pinView.pin = pinAnnotation.pin
                pinView.alpha = parent.store.state.mapState == .showTemporaryPin ? 0.5 : 1.0
                
                return pinView
            }
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if parent.isArchive == false {
                if let location = userLocation.location {
                    mapView.setRegion(latitude: location.coordinate.latitude,
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
        case removePin(id: Int) // [TemporaryPoint] 특정 핀을 지우는 메서드
        case responseUpdate([Pin]) // 결과값을 들고 오는
        case requestUpdate(latitude: Double, longitude: Double, latitudeDelta: Double, longitudeDelta: Double) // 현재값을 reducer로 던져주는
        
        case requestCurrentShowingPinViews([AnnotaitionPinView]) // 현재 핀들의 뷰들의 위치를 주기 위해
        
        case setCenter(latitude: Double, longitude: Double, isModal: Bool = false) // 현재위치로 지도 이동
        case setCenterWithModalAndAddTemporaryPin(latitude: Double, longitude: Double) // setcenter, removeAllAnnotation
        case cancelModal(latitude: Double, longitude: Double) // setCenter, removeAllAnntaion, popupclose
        case completeAdd(Pin) // setCenter, removeAllAnntaion
        case setCenterAndZoomUp(Pin)
        
        case requestCallMapInfo
        case reponseCallMapInfo(centerLatitude: Double, centerLongitude: Double, latitudeDelta: Double, longitudeDelta: Double)
        
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
