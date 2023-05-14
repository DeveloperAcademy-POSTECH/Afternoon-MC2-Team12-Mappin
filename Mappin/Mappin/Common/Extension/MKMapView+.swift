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
}

