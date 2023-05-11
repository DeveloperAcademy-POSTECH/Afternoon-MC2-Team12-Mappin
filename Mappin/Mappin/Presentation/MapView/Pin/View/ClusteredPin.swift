//
//  ClusteredPin.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import UIKit
import MapKit


class ClusterdPin: MKAnnotationView {
    
    var pin: Pin
    let clusteredCountLabel: UILabel
    let pinBackGroundImage: UIImageView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("sdsdsdsdssdsd")
        
        clusteredCountLabel.text = "\(pin.count)"
        if pin.id == RequestDeviceRepository().deviceId {
            clusteredCountLabel.textColor = .red
            pinBackGroundImage.image = UIImage(named: "") ?? UIImage(systemName: "pin")
        }
        else {
            clusteredCountLabel.textColor = .blue
            pinBackGroundImage.image = UIImage(named: "") ?? UIImage(systemName: "pin")
        }
        
        pinBackGroundImage.contentMode = .scaleAspectFit
        layout()
    }
    
    func layout() {
        for view in [pinBackGroundImage, clusteredCountLabel] {
            addSubview(view)
        }
        
        pinBackGroundImage.translatesAutoresizingMaskIntoConstraints = false
        pinBackGroundImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        pinBackGroundImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        clusteredCountLabel.translatesAutoresizingMaskIntoConstraints = false
        clusteredCountLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        clusteredCountLabel.topAnchor.constraint(equalTo: self.clusteredCountLabel.topAnchor, constant: 21).isActive = true
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        if let annotation = annotation as? PinAnnotation {
            self.pin = annotation.pin
        }
        else {
            self.pin = Pin.empty
        }
        self.clusteredCountLabel = UILabel()
        self.pinBackGroundImage = UIImageView()
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
