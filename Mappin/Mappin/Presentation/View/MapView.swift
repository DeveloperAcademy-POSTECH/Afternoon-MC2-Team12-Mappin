//
//  MapView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/08.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(25.2048, 55.2708), latitudinalMeters: 10000, longitudinalMeters: 10000)
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(region))
                .ignoresSafeArea()
            VStack {
                Text("54.67310° N, 25.29575° E")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                
                Spacer()
            }
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
