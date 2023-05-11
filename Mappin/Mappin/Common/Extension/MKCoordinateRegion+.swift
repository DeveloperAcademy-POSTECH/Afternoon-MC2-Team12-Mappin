//
//  MKCoordinateRegion+.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/08.
//

import MapKit

extension MKCoordinateRegion: Equatable {
    
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude && lhs.center.longitude == rhs.center.longitude
    }
}

