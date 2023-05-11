//
//  PinAnnotationProtocol.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    
    var pin: Pin
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: pin.location.latitude, longitude: pin.location.longitude)
    }
    
    init(_ pin: Pin) {
        
        self.pin = pin
    }
}
