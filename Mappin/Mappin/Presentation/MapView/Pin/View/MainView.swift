//
//  MapView.swift
//  Mappin
//
//  Created by 예슬 on 2023/05/03.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    //    @State private var region = MKCoordinateRegion(
    //        center: CLLocationCoordinate2D(latitude: 37.334_900,
    //                                       longitude: -122.009_020),
    //        latitudinalMeters: 750,
    //        longitudinalMeters: 750
    //    )
    //
    //    @State private var showSheet = false
    
    var body: some View {
        ZStack{
            //            Map(coordinateRegion: $region, interactionModes: [])
            //                .ignoresSafeArea()
            //            //            .sheet(isPresented: .constant(true)) {
            //            //                VStack(spacing: 15){
            //            //
            //            //                }
            //            //                .padding()
            //            //                .padding(.top)
            //            //            }
            //
            //
            //            VStack{
            //
            //
            //                Button(action: {
            //                    print("Add Musics")
            //                    self.showSheet = true
            //                }) {
            //                    Text("현재 위치에 음악 핀하기")
            //                        .fontWeight(.semibold)
            //                        .font(.title2)
            //
            //                    .padding()
            //                    .frame(maxWidth: .infinity)
            //                    .foregroundColor(.blue)
            //                    .background(Color.white)
            //                    .cornerRadius(20)
            //                }
            //                .sheet(isPresented: $showSheet) {
            //                    Home()
            //                }
            //
            //                Button(action: {
            //                    print("Archive")
            //                }) {
            //                    Text("내 핀과 다른 사람들 핀 구경하기")
            //                        .fontWeight(.semibold)
            //                        .font(.title2)
            //
            //                    .padding()
            //                    .frame(maxWidth: .infinity)
            //                    .foregroundColor(.blue)
            //                    .background(Color.white)
            //                    .cornerRadius(20)
            //                }
            //            }
            //            .padding(15)
            
            MapView1()
           // PrimaryView()
            
        }
    }
}
    
    
    
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
        }
    }

