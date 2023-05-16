//
//  LocationAuthorization.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import CoreLocation

final class RequestLocationRepository: NSObject, CLLocationManagerDelegate, LocationRepository {
    
    static var manager = RequestLocationRepository()
    
    var manager: CLLocationManager
    var latitude: Double
    var longitude: Double
    
    private override init() {
        manager = CLLocationManager()
        latitude = 0
        longitude = 0
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        print("Start")
        
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("User have authorization already")
            manager.startUpdatingLocation()
        
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            manager.allowsBackgroundLocationUpdates = true
            manager.startUpdatingLocation()
            
        default:
            manager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location service error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.last?.coordinate.latitude.magnitude ,
           let longitude = locations.last?.coordinate.longitude.magnitude
        else {
            self.latitude = 0
            self.longitude = 0
            return
        }
        
        self.latitude = latitude
        self.longitude = longitude
    }
}
