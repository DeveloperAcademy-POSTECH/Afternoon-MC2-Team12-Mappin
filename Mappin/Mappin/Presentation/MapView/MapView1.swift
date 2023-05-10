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
    var isArchive: Bool = false
    var userTrackingMode: MKUserTrackingMode
    
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.014295, longitude: 129.325791), span: MKCoordinateSpan(latitudeDelta: 0.0043282051271913355, longitudeDelta: 0.002735072544965078)), animated: true)
        }
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        // mapView.isUserInteractionEnabled = false
        mapView.register(ClusterdPin.self, forAnnotationViewWithReuseIdentifier: "")
        
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        switch action {
        case .none:
            print("MapView is made completely")
        case .createTemporaryPin(currentLocation: let currentLocation):
            var pin = Pin.empty
            print("add pin complety")
            
            pin.location.latitude = currentLocation.latitude
            pin.location.longitude = currentLocation.longitude
            let temp = PinAnnotation(pin)
            mapView.addAnnotation(temp)
            
        case .updatePins(let pins):
            mapView.removeAllAnotation()
            
            let annotations = pins.map { PinAnnotation($0) }
            mapView.addAnnotations(annotations)
            
        case .zoomLevelUp(center: let center):
            mapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)), animated: true)
        case .showDetail(pin: let pin):
            break
        case .hideDetailPin:
            break
        case .reloadPin(let pins):
            mapView.removeAllAnotation()
            let annotations = pins.map { PinAnnotation($0) }
            mapView.addAnnotations(annotations)
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
            
        }
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            guard let annotation = annotation as? PinAnnotation else { return MKAnnotationView() }
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") as? ClusterdPin else { return MKAnnotationView() }
            
            annotationView.pin = annotation.pin
            return annotationView
        }
    }
}

extension MapView {
    
    enum Action {
        
        case none
        case createTemporaryPin(currentLocation: CLLocationCoordinate2D)
        case updatePins([Pin])
        case zoomLevelUp(center: CLLocationCoordinate2D)
        case showDetail(pin: Pin)
        case hideDetailPin
        case reloadPin([Pin])
        
        var yame: Int {
            switch self {
                
            case .none:
                return 1
            case .createTemporaryPin(_):
                return 2
            case .updatePins(_):
                return 3
            case .zoomLevelUp(_):
                return 4
            case .showDetail(_):
                return 5
            case .hideDetailPin:
                return 6
            case .reloadPin(_):
                return 7
            }
        }
    }
}


