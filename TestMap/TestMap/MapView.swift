//
//  MapView.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    
  
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        print("sss")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            mapView.setRegion(latitude: 36.01450, longitude: 129.32538, latitudeDelta: 0.001, longitudeDelta: 0.001)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        print("s")
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
            print(mapView.region.center)
        }
    }
    
}


import MapKit

extension  MKMapView {
    
    func removeAllAnotation() {
        removeAnnotations(self.annotations)
    }
    
    func setRegion(latitude: Double, longitude: Double, latitudeDelta: Double, longitudeDelta: Double) {
        setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)), animated: true)
    }
}

