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
        
        clusteredCountLabel.text = "\(pin.count)"
        if pin.id == RequestDeviceRepository().deviceId {
            clusteredCountLabel.textColor = .red
            pinBackGroundImage.image = UIImage(named: "pinBlue") ?? UIImage(systemName: "pin")
        }
        else {
            clusteredCountLabel.textColor = .blue
            pinBackGroundImage.image = UIImage(named: "pinBlue") ?? UIImage(systemName: "pin")
        }
        
        pinBackGroundImage.contentMode = .scaleAspectFit
        layout()
    }
    
    func layout() {
        [pinBackGroundImage, clusteredCountLabel].forEach {
            addSubview($0)
        }
        
        pinBackGroundImage.translatesAutoresizingMaskIntoConstraints = false
        pinBackGroundImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pinBackGroundImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        clusteredCountLabel.translatesAutoresizingMaskIntoConstraints = false
        clusteredCountLabel.centerXAnchor.constraint(equalTo: pinBackGroundImage.centerXAnchor).isActive = true
        clusteredCountLabel.centerYAnchor.constraint(equalTo: pinBackGroundImage.centerYAnchor, constant: -3).isActive = true
        
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        if let annotation = annotation as? PinAnnotation {
            self.pin = annotation.pin
        }
        else {
            self.pin = Pin.empty
        }
        self.clusteredCountLabel = UILabel()
        self.pinBackGroundImage = UIImageView(image: UIImage(named: "pinBlue")!)

        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
