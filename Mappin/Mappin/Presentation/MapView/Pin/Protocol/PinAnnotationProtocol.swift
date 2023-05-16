//
//  PinAnnotationProtocol.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    
    var pinCluter: PinCluster
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: pinCluter.location.latitude, longitude: pinCluter.location.longitude)
    }
    
    init(_ pinCluster: PinCluster) {
        
        self.pinCluter = pinCluster
    }
}
