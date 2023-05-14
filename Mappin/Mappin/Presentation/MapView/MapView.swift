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
    
    var isArchive: Bool = false
    static var isAnimating = false
    @State var currentHasTemporaryPin: Bool = false
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        if !isArchive {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                mapView.setRegion(latitude: RequestLocationRepository.manager.latitude, longitude:
                                    RequestLocationRepository.manager.longitude,
                                  latitudeDelta: Constants.defaultLatitudeDelta,
                                  longitudeDelta: Constants.defaultLongitudeDelta)
            }
        }
        
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
            break
            
        case .responseUpdate(let newPins):
            if isArchive {
//                var pinAnnotations = mapView.annotations.map { annotation in
//
//                    guard let pinAnnotation = annotation as? PinAnnotation else { return PinAnnotation(Pin.empty) } // 나중에 내위치 안뜨면 여기잘못일듯
//                    return pinAnnotation
//                }
//
//                pinAnnotations.forEach { existAnnotation in
//                    if newPins.contains(where: { $0.id == existAnnotation.pin.id}) {
//
//                    }
//                    else {
//                        mapView.removeAnnotation(existAnnotation)
//                    }
//                }
//
//                newPins.forEach { annotation in
//                    if pinAnnotations.contains(where: { $0.pin.id == annotation.id}) {
//
//                    }
//                    else {
//                        let newAnnotation = PinAnnotation(annotation)
//                        mapView.addAnnotation(newAnnotation)
//                    }
//                }
                mapView.removeAllAnotation()
                mapView.addAnnotations(newPins.map{ PinAnnotation($0) })
            }
        case .requestUpdate(let latitude, let longitude, _, _):
            
            mapView.setRegion(latitude: latitude,
                              longitude: longitude,
                              latitudeDelta: Constants.defaultLatitudeDelta,
                              longitudeDelta: Constants.defaultLongitudeDelta)
            mapView.setRegion(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)),
                    latitudinalMeters: MapView.Constants.defaultLatitudeDelta,
                    longitudinalMeters: MapView.Constants.defaultLongitudeDelta),
                animated: true)
            
        case .setCenter(let latitude, let longitude, let isModal):
            MapView.isAnimating = true
            
            mapView.setRegion(latitude: isModal ? latitude - Constants.centerOffSet : latitude,
                              longitude: longitude,
                              latitudeDelta: isArchive ? mapView.region.span.latitudeDelta : MapView.Constants.defaultLatitudeDelta,
                              longitudeDelta:  isArchive ? mapView.region.span.longitudeDelta : MapView.Constants.defaultLongitudeDelta)
//            mapView.setRegion(
//                MKCoordinateRegion(
//                    center: CLLocationCoordinate2D(latitude: CLLocationDegrees(isModal ? latitude - Constants.centerOffSet : latitude), longitude: CLLocationDegrees(longitude)),
//                    latitudinalMeters: isArchive ? mapView.region.span.latitudeDelta : MapView.Constants.defaultLatitudeDelta,
//                    longitudinalMeters: isArchive ? mapView.region.span.latitudeDelta : MapView.Constants.defaultLongitudeDelta),
//                animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                MapView.isAnimating = false
            }
            
        case .removePin(let id):
            let annotationPins = mapView.annotations.map { annotation in
                guard let annotaionPin = annotation as? PinAnnotation else { return PinAnnotation(Pin.empty) }
                return annotaionPin
            }
            
            let willRemovePin = annotationPins.first(where: { $0.pin.id == id }) ?? PinAnnotation(Pin.empty)
            mapView.removeAnnotation(willRemovePin)
            
        case .setCenterWithModalAndAddTemporaryPin(let latitude, let longitude):
            
            store.send(.actAndChange(.setCenter(latitude: latitude, longitude: longitude, isModal: true)))
           
            
            let currentLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                                     span: MKCoordinateSpan(latitudeDelta: Constants.defaultLatitudeDelta,
                                                                            longitudeDelta: Constants.defaultLongitudeDelta))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                store.send(.actTemporaryPinLocation(currentLocation))
            }
            
            var temporaryPin = Pin.empty
            temporaryPin.location.latitude = latitude
            temporaryPin.location.longitude = longitude
            temporaryPin.id = Constants.temporaryPinId
            let temp = PinAnnotation(temporaryPin)
            mapView.addAnnotation(temp)
            
        case .cancelModal(let latitude, let longitude):
            
            mapView.removeAllAnotation()
            mapView.setRegion(latitude: latitude, longitude: longitude, latitudeDelta: Constants.defaultLatitudeDelta, longitudeDelta: Constants.defaultLongitudeDelta)
            
        case .completeAdd(let pin):
            
            store.send(.actAndChange(.setCenter(latitude: pin.location.latitude, longitude: pin.location.longitude)))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                
                currentHasTemporaryPin = false
                store.send(.showPopUpAndCloseAfter)
                mapView.removeAllAnotation()
            }
            
        case .requestCallMapInfo:
            print("@KIO here callmapInfo")
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
            if !MapView.isAnimating  && parent.isArchive {
                parent.store.send(.act(.requestUpdate(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude, latitudeDelta: mapView.region.span.latitudeDelta, longitudeDelta: mapView.region.span.longitudeDelta)))
                
                let pinAnnotationViews = mapView.annotations.map { annotation in
                    guard let pinAnnotationView = mapView.view(for: annotation) as? AnnotaitionPinView else { return AnnotaitionPinView() }
                    
                    return pinAnnotationView
                }
                parent.store.send(.act(.requestCurrentShowingPinViews(pinAnnotationViews)))
                parent.store.send(.popUpClose)
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
            if parent.isArchive {
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
                    
                    if !parent.currentHasTemporaryPin {
                        let current = AnnotaitionPinView()
                        current.pinCategory = nil
                        
                        return current
                    }
                    else {
                        return MKAnnotationView()
                    }
                }
                pinView.annotation = pinAnnotation
                pinView.pin = pinAnnotation.pin
                pinView.alpha = 0.5
                
                return pinView
            }
        }
    }
    
}

extension MapView {
    struct Constants {
        static var defaultLatitudeDelta: Double = 0.0017311351539746056
        static var defaultLongitudeDelta: Double = 0.0011165561592463291
        static var centerOffSet: Double = 0.00068
        static var temporaryPinId: String = "-1"
    }
}

extension MapView {
    
    enum Action: Equatable {
    
        case none
        case removePin(id: String) // [TemporaryPoint] 특정 핀을 지우는 메서드
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
}

extension MapView {
    
    func animationEnded(completion: @escaping ()->Void ) {
        MapView.isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            completion()
            MapView.isAnimating = false
        }
    }
}
