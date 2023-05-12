//
//  AnnotaitionPin.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import UIKit
import MapKit


class AnnotaitionPin: MKAnnotationView {
    
    var pin: Pin
    let clusteredCountLabel: UILabel
    let pinBackGroundImage: UIImageView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backGroundLayout()
        
        clusteredCountLabel.text = "\(pin.count)"
        if pin.id == RequestDeviceRepository().deviceId {
            clusteredCountLabel.textColor = .blue
            pinBackGroundImage.image = UIImage(named: pin.count == 1 ? "pinBlueSingle" : "pinBlue")!
            
        }
        else {
            clusteredCountLabel.textColor = .gray
            pinBackGroundImage.image = UIImage(named: pin.count == 1 ? "pinGraySingle" : "pinGray")!
        }
        
        pinBackGroundImage.contentMode = .scaleAspectFit
        backGroundLayout()
        if pin.count != 0 { addCountLabel() }
    }
    
    func addCountLabel() {
        
        addSubview(clusteredCountLabel)
        
        clusteredCountLabel.translatesAutoresizingMaskIntoConstraints = false
        clusteredCountLabel.centerXAnchor.constraint(equalTo: pinBackGroundImage.centerXAnchor).isActive = true
        clusteredCountLabel.centerYAnchor.constraint(equalTo: pinBackGroundImage.centerYAnchor, constant: -3).isActive = true
        
    }
    
    func backGroundLayout() {
        
        addSubview(pinBackGroundImage)
        
        pinBackGroundImage.translatesAutoresizingMaskIntoConstraints = false
        pinBackGroundImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pinBackGroundImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
