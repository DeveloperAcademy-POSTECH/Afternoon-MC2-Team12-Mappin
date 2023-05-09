//
//  SinglePin.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import UIKit
import MapKit


class SinglePin: MKAnnotationView {
    
    let pin: Pin
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    init(pin: Pin) {
        self.pin = pin
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
