//
//  AnnotaitionPin.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import UIKit
import MapKit


class AnnotaitionPinView: MKAnnotationView {
    
    var pin: Pin
    let clusteredCountLabel: UILabel
    let pinBackGroundImage: UIImageView
    
    override func layoutSubviews() {
        super.layoutSubviews()

       
        clusteredCountLabel.text = "\(pin.count)"
        if pin.id == RequestDeviceRepository().deviceId {
            clusteredCountLabel.textColor = .blue
            pinBackGroundImage.image = UIImage(named: pin.count == 1 ? "bluePinSingle" : "bluePin")!
            
        }
        else {
            clusteredCountLabel.textColor = .gray
            pinBackGroundImage.image = UIImage(named: pin.count == 1 ? "grayPinSingle" : "grayPin")!
        }
        
        pinBackGroundImage.contentMode = .scaleAspectFit
        backGroundLayout()
        if pin.count != 1 { addCountLabel() }
    }
    
    func addCountLabel() {
        
        addSubview(clusteredCountLabel)
        
        clusteredCountLabel.translatesAutoresizingMaskIntoConstraints = false
        clusteredCountLabel.centerXAnchor.constraint(equalTo: pinBackGroundImage.centerXAnchor).isActive = true
        clusteredCountLabel.centerYAnchor.constraint(equalTo: pinBackGroundImage.centerYAnchor, constant: -3).isActive = true
        
    }
    
    func backGroundLayout() {
        
        addSubview(pinBackGroundImage)
        let g = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        pinBackGroundImage.addGestureRecognizer(g)
        
        pinBackGroundImage.translatesAutoresizingMaskIntoConstraints = false
        pinBackGroundImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pinBackGroundImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let offset = UIOffset(horizontal: -10, vertical: 0)
        pinBackGroundImage.frame = pinBackGroundImage.frame.offsetBy(dx: offset.horizontal, dy: offset.vertical)
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
    
    @objc func tap(_ sender: Any) {
        print(pin)
    }
}
