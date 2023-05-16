//
//  MKMapView+.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import MapKit

extension  MKMapView {
    
    func removeAllAnotation() {
        removeAnnotations(self.annotations)
    }
    
    func setRegion(animated: Bool = true ,latitude: Double, longitude: Double, latitudeDelta: Double, longitudeDelta: Double) {
        setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)), animated: animated)
    }
}

