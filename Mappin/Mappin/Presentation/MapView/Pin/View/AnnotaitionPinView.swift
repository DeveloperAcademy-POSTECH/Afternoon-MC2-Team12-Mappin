//
//  AnnotaitionPin.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/09.
//

import UIKit
import MapKit


class AnnotaitionPinView: MKAnnotationView {
    
    var pinCluter: PinCluster
    var pinCategory: PinsCategory? = .mine
    let clusteredCountLabel: UILabel
    let pinBackGroundImage: UIImageView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        subviews.forEach { $0.removeFromSuperview() }
        
        if pinCategory == nil {
            pinBackGroundImage.image = UIImage(named: "currentLocation")!
        }
        else if pinCategory == .mine {
            clusteredCountLabel.textColor = .blue
            pinBackGroundImage.image = UIImage(named: pinCluter.pinsCount > 1 ? "bluePin" : "bluePinSingle")!
            
        }
        else if pinCategory == .others {
            clusteredCountLabel.textColor = .gray
            pinBackGroundImage.image = UIImage(named: pinCluter.pinsCount > 1 ? "grayPin" : "grayPinSingle")!
        }
        
        pinBackGroundImage.contentMode = .scaleAspectFit
        backGroundLayout()
        if pinCluter.pinsCount > 1 { addCountLabel() }
    }
    
    func addCountLabel() {
        
        addSubview(clusteredCountLabel)
        clusteredCountLabel.text = "\(pinCluter.pinsCount)"
        
        clusteredCountLabel.translatesAutoresizingMaskIntoConstraints = false
        clusteredCountLabel.centerXAnchor.constraint(equalTo: pinBackGroundImage.centerXAnchor).isActive = true
        clusteredCountLabel.centerYAnchor.constraint(equalTo: pinBackGroundImage.centerYAnchor, constant: -3).isActive = true
        
        let offset = UIOffset(horizontal: -20, vertical: 0)
        clusteredCountLabel.frame = clusteredCountLabel.frame.offsetBy(dx: offset.horizontal, dy: offset.vertical)
    }
    
    func backGroundLayout() {
        
        addSubview(pinBackGroundImage)
        let g = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        pinBackGroundImage.addGestureRecognizer(g)
        
        pinBackGroundImage.translatesAutoresizingMaskIntoConstraints = false
        pinBackGroundImage.widthAnchor.constraint(equalToConstant: pinCategory == nil ? 20 : 46).isActive = true
        pinBackGroundImage.heightAnchor.constraint(equalToConstant: pinCategory == nil ? 20 : 46).isActive = true
        
        let offset = UIOffset(horizontal: -20, vertical: 0)
        pinBackGroundImage.frame = pinBackGroundImage.frame.offsetBy(dx: offset.horizontal, dy: offset.vertical)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        if let annotation = annotation as? PinAnnotation {
            self.pinCluter = annotation.pinCluter
        }
        else {
            self.pinCluter = PinCluster.empty
        }
        self.clusteredCountLabel = UILabel()
        self.pinBackGroundImage = UIImageView()

        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap(_ sender: Any) {
        print(pinCluter)
    }
}
