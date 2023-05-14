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
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        mapView.isRotateEnabled = false
        mapView.userTrackingMode = isArchive ? .none : .follow
        //mapView.isUserInteractionEnabled = isArchive
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
                mapView.removeAllAnotation()
                mapView.addAnnotations(newPins.map { PinAnnotation($0) })
            }
            
        case .requestUpdate(here: let here, _, _):
            
            mapView.setRegion(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: CLLocationDegrees(here.0), longitude: CLLocationDegrees(here.1)),
                    latitudinalMeters: MapView.Constants.defaultLatitudeDelta,
                    longitudinalMeters: MapView.Constants.defaultLongitudeDelta),
                animated: true)
            
        case .requestCurrentShowingPinViews(_):
            break
            
        case .setCenter(let here, let isModal):
            MapView.isAnimating = true
            mapView.setRegion(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: CLLocationDegrees(isModal ? here.0 - Constants.centerOffSet : here.0), longitude: CLLocationDegrees(here.1)),
                    latitudinalMeters: MapView.Constants.defaultLatitudeDelta,
                    longitudinalMeters: MapView.Constants.defaultLongitudeDelta),
                animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                MapView.isAnimating = false
            }
            
        case .removePin(let id):
            var annotationPins = mapView.annotations.map { annotation in
                guard let annotaionPin = annotation as? PinAnnotation else { return PinAnnotation(Pin.empty) }
                return annotaionPin
            }
           
            let willRemovePin = annotationPins.first(where: { $0.pin.id == "-1" }) ?? PinAnnotation(Pin.empty)
            mapView.removeAnnotation(willRemovePin)
            
        case .setCenterWithModalAndAddTemporaryPin(here: let here):
            
            store.send(.actAndChange(.setCenter(here: here, isModal: true)))
            
            let currentLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: here.0, longitude: here.1), span: MKCoordinateSpan())
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                store.send(.actTemporaryPinLocation(currentLocation))
            }
            
            var temporaryPin = Pin.empty
            temporaryPin.location.latitude = here.0
            temporaryPin.location.longitude = here.1
            temporaryPin.id = Constants.temporaryPinId
            let temp = PinAnnotation(temporaryPin)
            
            mapView.addAnnotation(temp)
            
            
        case .cancelModal(here: let here):
            
            mapView.removeAllAnotation()
            store.send(.actAndChange(.setCenter(here: here)))
            
        case .completeAdd(let pin):
            
            store.send(.actAndChange(.setCenter(here: (pin.location.latitude, pin.location.longitude))))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
               
                store.send(.showPopUpAndCloseAfter)
                //mapView.removeAllAnotation()
            }
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
                parent.store.send(.act(.requestUpdate(here: (mapView.region.center.latitude, mapView.region.center.longitude), latitudeDelta: mapView.region.span.latitudeDelta, longitudeDelta: mapView.region.span.longitudeDelta)))
                
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
            if parent.isArchive {
                guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotaitionPinView") as? AnnotaitionPinView,
                      let pinAnnotation = annotation as? PinAnnotation else {
                    
                    return MKAnnotationView()
                }
                
                pinView.annotation = pinAnnotation
                pinView.pin = pinAnnotation.pin
                
                return pinView
            }
            else {
                guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "TemporaryAnnotaitionPinView") as? AnnotaitionPinView,
                      let pinAnnotation = annotation as? PinAnnotation else {
                    
                    return MKAnnotationView()
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
        static var defaultLatitudeDelta: Double = 0.0043282051271913355
        static var defaultLongitudeDelta: Double = 0.002735072544965078
        static var centerOffSet: Double = 0.00013
        static var temporaryPinId: String = "-1"
    }
}

extension MapView {
    
    enum Action: Equatable {
        
        static func == (lhs: MapView.Action, rhs: MapView.Action) -> Bool {
            false
        }
        
        case none
        case removePin(id: String = "-1") // [TemporaryPoint] 특정 핀을 지우는 메서드
        case responseUpdate([Pin]) // 결과값을 들고 오는
        case requestUpdate(here: (Double, Double), latitudeDelta: Double, longitudeDelta: Double) // 현재값을 reducer로 던져주는
        
        
        case requestCurrentShowingPinViews([AnnotaitionPinView]) // 현재 핀들의 뷰들의 위치를 주기 위해
        
        case setCenter(here: (Double, Double), isModal: Bool = false) // 현재위치로 지도 이동
        case setCenterWithModalAndAddTemporaryPin(here: (Double, Double)) // setcenter, removeAllAnnotation
        case cancelModal(here: (Double, Double)) // setCenter, removeAllAnntaion, popupclose
        case completeAdd(Pin) // setCenter, removeAllAnntaion
        
        var yame: Int {
            (1...10000).randomElement()!
        }
    }
}


