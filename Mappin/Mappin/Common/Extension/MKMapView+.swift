//
//  MKMapView+.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import MapKit

extension  MKMapView {
    
    func removeAllAnotation() {
        print("LOG2 \(self.annotations.count)")
        removeAnnotations(self.annotations)
        print("LOG2 \(self.annotations)")
    }
}

