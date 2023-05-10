//
//  MapView.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var action: Action
    
    @State private var zoomLevel: Double = 0.01
    var region: MKCoordinateRegion = MKCoordinateRegion()
    var isArchive: Bool = false
    var userTrackingMode: MKUserTrackingMode
 
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: RequestLocationRepository.manager.latitude, longitude: RequestLocationRepository.manager.longitude), span: MKCoordinateSpan(latitudeDelta: 0.0043282051271913355, longitudeDelta: 0.002735072544965078)), animated: true)
        }
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = isArchive
        mapView.register(ClusterdPin.self, forAnnotationViewWithReuseIdentifier: "")
        
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        switch action {
        case .none:
            break
        case .createTemporaryPin(currentLocation: let currentLocation):
    
            let newPin = PinAnnotation(Pin.empty)
            newPin.pin.location.latitude = currentLocation.latitude
            newPin.pin.location.longitude = currentLocation.longitude
            
            mapView.addAnnotation(newPin)
            
        case .updatePins(let newPins):
            
            mapView.removeAllAnotation()
            mapView.addAnnotations(newPins.map { PinAnnotation($0) })
            
        case .move(here: let here):
            
            mapView.setRegion(
                MKCoordinateRegion(
                    center: here,
                    latitudinalMeters: 0.0043282051271913355,
                    longitudinalMeters: 0.002735072544965078),
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
            parent.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
        }
    }
}

extension MapView {
    
    enum Action {
        
        case none
        case createTemporaryPin(currentLocation: CLLocationCoordinate2D)
        case updatePins([Pin])
        case move(here: CLLocationCoordinate2D)
        
        var yame: Int {
            (1...10000).randomElement()!
        }
    }
}


