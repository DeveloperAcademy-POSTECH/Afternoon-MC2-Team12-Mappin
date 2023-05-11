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

    var isArchive: Bool = false
    var userTrackingMode: MKUserTrackingMode
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           
            mapView.setRegion(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: CLLocationDegrees(RequestLocationRepository.manager.latitude), longitude: CLLocationDegrees(RequestLocationRepository.manager.longitude)),
                    latitudinalMeters: MapView.Constants.defaultLatitudeDelta,
                    longitudinalMeters: MapView.Constants.defaultLongitudeDelta),
                animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
           
            store.send(
                .act(
                    .update(
                        here: (
                            RequestLocationRepository.manager.latitude,
                            RequestLocationRepository.manager.longitude
                        ),
                        latitudeDelta: Constants.defaultLatitudeDelta,
                        longitudeDelta: Constants.defaultLongitudeDelta
                    )
                )
            )
        }
        
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        mapView.register(ClusterdPin.self, forAnnotationViewWithReuseIdentifier: "")
        
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
       
        switch store.mapAction {
        case .none:
            break
        case .createTemporaryPin(currentLocation: let currentLocation):
            
            let newPin = PinAnnotation(Pin.empty)
            newPin.pin.location.latitude = currentLocation.latitude
            newPin.pin.location.longitude = currentLocation.longitude
            
            mapView.addAnnotation(newPin)
            
        case .updatePins(let newPins):
            
            print("@LOG cece")
            mapView.removeAllAnotation()
            mapView.addAnnotations(newPins.map { PinAnnotation($0) })
            
        case .update(here: let here, _, _):
            
            mapView.setRegion(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: CLLocationDegrees(here.0), longitude: CLLocationDegrees(here.1)),
                    latitudinalMeters: MapView.Constants.defaultLatitudeDelta,
                    longitudinalMeters: MapView.Constants.defaultLongitudeDelta),
                animated: true)
            
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
           
            parent.store.send(.act(.update(here: (mapView.region.center.latitude, mapView.region.center.longitude), latitudeDelta: mapView.region.span.latitudeDelta, longitudeDelta: mapView.region.span.longitudeDelta)))
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "") as? ClusterdPin,
                  let pinAnnotation = annotation as? PinAnnotation else {
                return MKAnnotationView()
            }
            
            pinView.pin = pinAnnotation.pin
            
            return pinView
        }
    }
}

extension MapView {
    private struct Constants {
        static var defaultLatitudeDelta: Double = 0.0043282051271913355
        static var defaultLongitudeDelta: Double = 0.002735072544965078
    }
}

extension MapView {
    
    enum Action: Equatable {
        
        static func == (lhs: MapView.Action, rhs: MapView.Action) -> Bool {
            false
        }
        
        case none
        case createTemporaryPin(currentLocation: CLLocationCoordinate2D)
        case updatePins([Pin])
        case update(here: (Double, Double), latitudeDelta: Double, longitudeDelta: Double)
        
        var yame: Int {
            (1...10000).randomElement()!
        }
    }
}


